#lang racket
(require parser-tools/lex
         parser-tools/yacc
         (prefix-in : parser-tools/lex-sre))

(define (write-csv-table table [out (current-output-port)])
  ((compose
    (λ (csv) (display csv out))
    (λ (rows) (string-join rows "\n"))
    (curry map (compose
                (λ (row) (string-join row ","))
                (curry map csv-escape))))
   table))

(define (table->csv filename table)
  (with-output-to-file filename #:mode 'text #:exists 'replace
    (λ () (write-csv-table table))))

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
        [else (~a thing)]))

(define csv-unescape
  (compose (λ (s) (regexp-replace* #px"\r\n" s "\n"))
           (λ (s) (regexp-replace* #px"\"\"" s "\""))
           (λ (s) (regexp-replace #px"\"$" s ""))
           (λ (s) (regexp-replace #px"^\"" s ""))))

(define-tokens csv-data
  (DATUM))
(define-empty-tokens csv-terminals
  (EOF NEWLINE COMMA))

(define csv-lexer
  (lexer
   [#\,
    (token-COMMA)]
   [(eof)
    (token-EOF)]
   [(:or "\n" "\r\n")
    (token-NEWLINE)]
   [(:: #\" (:* (:or (:: #\" #\")
                     (:~ #\")))
        #\")
    (token-DATUM (or (string->number
                      (substring lexeme 1 (sub1 (string-length lexeme))))
                     (csv-unescape lexeme)))]
   [(:+ (:~ #\, #\newline #\return))
    (token-DATUM (or (string->number lexeme)
                     lexeme))]))

(define csv-parser
  (parser
   (tokens csv-data csv-terminals)
   (grammar
    [table ((row NEWLINE table) (cons $1 $3))
           ((row NEWLINE)       (list $1))
           ((row)               (list $1))]
    [row ((DATUM COMMA row) (cons $1 $3))
         ((COMMA row)       (cons "" $2))
         ((DATUM)           (list $1))
         ((COMMA)           (list "" ""))])
   (start table)
   (end EOF)
   (error (λ (bool-1 thing bool-2)
            (displayln thing)))))

(define (lex-this lexer input)
  (λ () (lexer input)))

(define (read-csv-table [in (current-input-port)])
  (csv-parser (lex-this csv-lexer in)))

(define (csv->table filename)
  (with-input-from-file filename #:mode 'text
    (λ () (read-csv-table))))

(provide csv->table
         table->csv
         write-csv-table
         read-csv-table)
