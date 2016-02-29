#lang racket
(require parser-tools/lex
         parser-tools/yacc
         (prefix-in : parser-tools/lex-sre))

;;; CSV MAKER

(define (write-csv table [out (current-output-port)])
  ((compose
    (λ (csv) (display csv out))
    (λ (rows) (string-join rows "\n"))
    (curry map (compose
                (λ (row) (string-join row ","))
                (curry map csv-escape))))
   table))

(define (table->csv table filename)
  (with-output-to-file filename #:mode 'text #:exists 'replace
    (λ () (write-csv table))))

(define (csv-escape thing)
  (cond [(and (string? thing)
              (or (string-contains? thing "\"")
                  (string-contains? thing ",")
                  (string-contains? thing "\n")))
         (format "\"~a\""
                 (regexp-replace* #px"\"" thing "\"\""))]
        [(and (string? thing)
              (string=? "" thing))
         "\"\""]
        [(not thing)
         "\"\""]
        [else (~a thing)]))

;;; CSV PARSER

(define csv-unescape
  (compose (λ (s) (regexp-replace* #px"\r\n" s "\n"))
           (λ (s) (regexp-replace* #px"\"\"" s "\""))
           (λ (s) (regexp-replace #px"\"$" s ""))
           (λ (s) (regexp-replace #px"^\"" s ""))))

(define (strip-quotes str)
  (substring str 1 (sub1 (string-length str))))

(define-tokens csv-data
  (DATUM))

(define-empty-tokens csv-terminals
  (EOF NEWLINE COMMA EMPTY))

(define csv-lexer
  (lexer
   [#\,
    (token-COMMA)]
   [(eof)
    (token-EOF)]
   [(:or "\n" "\r\n")
    (token-NEWLINE)]
   [(:: #\" (:+ (:or (:: #\" #\")
                     (:~ #\")))
        #\")
    (token-DATUM (or (string->number (strip-quotes lexeme))
                     (csv-unescape lexeme)))]
   ["\"\""
    (token-EMPTY)]
   [(:+ (:~ #\, #\newline #\return))
    (token-DATUM (or (string->number lexeme)
                     lexeme))]))

(define csv-parser
  (parser
   (tokens csv-data csv-terminals)
   (grammar
    (table [(row NEWLINE table) (cons $1 $3)]
           [(row NEWLINE)       (list $1)]
           [(row)               (list $1)])
    (row [(DATUM COMMA row) (cons $1 $3)]
         [(EMPTY COMMA row) (cons #f $3)]
         [(COMMA row)       (cons #f $2)]
         [(DATUM)           (list $1)]
         [(EMPTY)           (list #f)]
         [(COMMA)           (list #f #f)]))
   (start table)
   (end EOF)
   (error (λ args (void)))))

(define (lex-this lexer input)
  (λ () (lexer input)))

(define (read-csv [in (current-input-port)])
  (csv-parser (lex-this csv-lexer in)))

(define (csv->table filename)
  (with-input-from-file filename #:mode 'text
    (λ () (read-csv))))

(define (table->hashes table)
  (define (make-row-hash row headers)
    (foldr (λ (column header hsh)
             (hash-set hsh header column))
           (make-immutable-hash)
           row
           headers))

  (if (empty? table)
      '()
      (let ([headers (first table)])
        (foldr (λ (row hashes)
                 (cons (make-row-hash row headers)
                       hashes))
               '()
               (rest table)))))

(define (hashes->table headers hashes)
  (cons headers
        (map (λ (row)
               (map (λ (header) (hash-ref row header))
                    headers))
             hashes)))

(provide csv->table
         table->csv
         write-csv
         read-csv
         table->hashes
         hashes->table)
