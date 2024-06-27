;; writeMoveset
;;
;; write's the current player's character's moveset to the fix layer
;; in versus mode, write's the moveset of whoever paused the game

movem.l A0/D0, $MOVEM_STORAGE

lea $2CHARID_TO_MOVE_SET, A0

;; is P1 playing?
cmpi.b #1, $BIOS_PLAYER_MOD1
bne loadPlayer2
;; ok player 1 is playing. but is this versus mode?
cmpi.b #1, $BIOS_PLAYER_MOD2
bne loadPlayer1 ; ok single player mode, go load p1

;; ok this is versus mode
;; if we don't yet know who paused, don't do anything
;; we will know on the next frame, so no worries
cmpi.b #0, $WHO_PAUSED_LAST
beq done
;; in versus mode, we will load the moveset of whoever paused the game
cmpi.b #1, $WHO_PAUSED_LAST
beq loadPlayer1
bra loadPlayer2

;; load p1 moveset
loadPlayer1:
clr.w D0
move.b $108171, D0 ; load player 1's current character's ID
add.w D0, D0  ; quadruple it as the table is of longs
add.w D0, D0  ; quadruple it as the table is of longs
adda.w D0, A0 ; move forward in the table to the character's pointer
bra doneLoadPlayerPointer

loadPlayer2:
clr.w D0
move.b $108171, D0 ; load player 1's current character's ID
move.b $108371, D0 ; load player 2's current character's ID
add.w D0, D0  ; quadruple it as the table is of longs
add.w D0, D0  ; quadruple it as the table is of longs
adda.w D0, A0 ; move forward in the table to the character's pointer
bra doneLoadPlayerPointer

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