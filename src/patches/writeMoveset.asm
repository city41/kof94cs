;; writeMoveset
;;
;; write's the current player's character's moveset to the fix layer
;; but only in single player mode

movem.l A0/D0, $MOVEM_STORAGE

lea $2CHARID_TO_MOVE_SET, A0

;; is P1 playing?
cmpi.b #1, $BIOS_PLAYER_MOD1
bne loadPlayer2
;; ok player 1 is playing. but is this versus mode?
cmpi.b #1, $BIOS_PLAYER_MOD2
beq done ; it is versus mode, nothing to do

;; single player, p1 game
clr.w D0
move.b $108171, D0 ; load player 1's current character's ID
add.w D0, D0  ; quadruple it as the table is of longs
add.w D0, D0  ; quadruple it as the table is of longs
adda.w D0, A0 ; move forward in the table to the character's pointer

bra doneLoadPlayerPointer

loadPlayer2:
;; we already know p1 is not playing
;; single player, p2 game
clr.w D0
move.b $108171, D0 ; load player 1's current character's ID
move.b $108371, D0 ; load player 2's current character's ID
add.w D0, D0  ; quadruple it as the table is of longs
add.w D0, D0  ; quadruple it as the table is of longs
adda.w D0, A0 ; move forward in the table to the character's pointer

doneLoadPlayerPointer:
movea.l (A0), A0 ; go from the pointer to the actual data

writeChar:
move.l (A0)+, D0
beq done ; is it the terminator? then we are done
move.l D0, $3c0000
bra writeChar


done:
movem.l $MOVEM_STORAGE, A0/D0
rts