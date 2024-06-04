;; writeMoveset
;;
;; write's the current player's character's moveset to the fix layer

movem.l A0/D0, $MOVEM_STORAGE
lea $2TERRY, A0

writeChar:
move.l (A0)+, D0
beq done ; is it the terminator? then we are done
move.l D0, $3c0000
bra writeChar


done:
movem.l $MOVEM_STORAGE, A0/D0
rts