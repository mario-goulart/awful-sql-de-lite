(module awful-sql-de-lite (enable-db)

(import chicken scheme regex)
(use awful sql-de-lite)

(define (enable-db . ignore) ;; backward compatibility: `enable-db' was a parameter

  (db-enabled? #t)

  (db-connect open-database)

  (db-disconnect close-database)

  (db-inquirer (lambda (q #!key default)
                 (query (map-rows (lambda (data) data))
                        (sql (db-connection) q))))

  (sql-quoter (lambda (data)
                (++ "'" (string-substitute* (concat data) '(("'" . "''"))) "'")))

  (db-make-row-obj (lambda (q)
                     (error '$db-row-obj "Not implemented for sql-de-lite.")))
  )
) ; end module
