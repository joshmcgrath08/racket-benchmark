#lang racket

(require plot benchmark)

(define files
  (list
   "external/fib5.rkt"
   "external/fib20.rkt"
   "external/collatz1000.rkt"))

(define (jit-no-jit jit)
  (bgroup
   (if jit "jit" "no jit")
   (map (lambda (f)
          (mk-shell-benchmark
           f
           (format (if jit "racket ~a" "racket -j ~a") f)))
    files)))

(define results
  (run-benchmarks
   (mk-bgroup "" (list (jit-no-jit #t) (jit-no-jit #f)))
   (bopts #:num-trials 31)))

(parameterize ([plot-x-ticks no-ticks])
  (plot-file
   #:title "jit vs no jit"
   #:x-label #f
   #:y-label "normalized time"
   (render-benchmark-alts (list "jit" "no jit") results "jit")
   "jit-no-jit.pdf"))