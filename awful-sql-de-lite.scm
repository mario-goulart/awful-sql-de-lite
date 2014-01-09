(module awful-sql-de-lite (enable-db switch-to-sql-de-lite-database)

(import chicken scheme regex)
(use awful sql-de-lite)

(define (enable-db . ignore) ;; backward compatibility: `enable-db' was a parameter
  (switch-to-sql-de-lite-database))

(define (switch-to-sql-de-lite-database)

  (db-enabled? #t)

  (db-connect open-database)

  (db-disconnect close-database)

  (db-inquirer
   (lambda (q #!key (default '()) values)
     (let ((result
            (if values
                (apply query (append (list
                                      (map-rows (lambda (data) data))
                                      (sql (db-connection) q))
                                     values))
                (query (map-rows (lambda (data) data))
                       (sql (db-connection) q)))))
       (if (null? result)
           default
           result))))

  (sql-quoter (lambda (data)
                (++ "'" (string-substitute* (concat data) '(("'" . "''"))) "'")))

  (db-make-row-obj (lambda (q)
                     (error '$db-row-obj "Not implemented for sql-de-lite.")))
  )
) ; end module
