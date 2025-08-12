(define-constant contract-owner 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
(define-data-var draw-open bool true)
(define-data-var winner (optional principal) none)

(define-constant err-not-owner (err u100))
(define-constant err-draw-closed (err u101))
(define-constant err-no-winner (err u102))

;; Ensure only owner can call
(define-private (is-owner)
  (is-eq tx-sender contract-owner)
)

;; Open or close the draw
(define-public (set-draw-status (status bool))
  (begin
    (asserts! (is-owner) err-not-owner)
    (var-set draw-open status)
    (ok status)
  )
)

;; Select a winner
(define-public (pick-winner (player principal))
  (begin
    (asserts! (is-owner) err-not-owner)
    (asserts! (var-get draw-open) err-draw-closed)
    (var-set winner (some player))
    (ok player)
  )
)

;; View winner
(define-read-only (get-winner)
  (match (var-get winner)
    winner-principal (ok winner-principal)
    err-no-winner
  )
)

;; View status
(define-read-only (is-draw-open)
  (ok (var-get draw-open))
)
