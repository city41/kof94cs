;; clearMoveset
;;
;; erases a moveset from the fix layer. Really just clears the fix layer starting
;; at 7028

movem.w D4-D6, $MOVEM_STORAGE

move.w #37, D4  ; columns set for dba
clearColumn:
move.w #$7028, D5 ; upper corner, base address
move.w D4, D6     ; copy it for multiplying
mulu.w #$20, D6 
add.w D6, D5      ; D5 now has the starting address for the column
move.w #20, D6  ; rows set for dba 
clearTile:
move.w D5, $3c0000    ; VRAMADDR
move.w #$f20, $3c0002 ; VRAMRW
addi.w #1, D5 ; move to next tile address
dbra D6, clearTile
dbra D4, clearColumn


movem.w $MOVEM_STORAGE, D4-D6

rts