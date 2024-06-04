# writing pause

fix location: 7270, fix value: 1341 at PC:005F1C
fix location: 7290, fix value: 1355 at PC:005F1C
fix location: 72b0, fix value: 1353 at PC:005F1C
fix location: 72d0, fix value: 1345 at PC:005F1C
fix location: 7250, fix value: 1350 at PC:005F1C
fix location: 7270, fix value: 1341 at PC:005F1C
fix location: 7290, fix value: 1355 at PC:005F1C
fix location: 72b0, fix value: 1353 at PC:005F1C
fix location: 72d0, fix value: 1345 at PC:005F1C
fix location: 7250, fix value: 1350 at PC:005F1C
fix location: 7270, fix value: 1341 at PC:005F1C
fix location: 7290, fix value: 1355 at PC:005F1C
fix location: 72b0, fix value: 1353 at PC:005F1C
fix location: 72d0, fix value: 1345 at PC:005F1C
fix location: 7250, fix value: 1350 at PC:005F1C
fix location: 7270, fix value: 1341 at PC:005F1C
fix location: 7290, fix value: 1355 at PC:005F1C
fix location: 72b0, fix value: 1353 at PC:005F1C
fix location: 72d0, fix value: 1345 at PC:005F1C
fix location: 7250, fix value: 1350 at PC:005F1C
fix location: 7270, fix value: 1341 at PC:005F1C
fix location: 7290, fix value: 1355 at PC:005F1C
fix location: 72b0, fix value: 1353 at PC:005F1C

350 - P

341 - A
355 - U
353 - S
345 - E

"PAUSE" is stored as a byte string starting at 53064

This address is written at 32f00

movea.l #$53064, D0

This is in subroutine 32ea6, which seems to be "if in pause mode, send PAUSE pointer to fix write routine", and it does this every frame.

It seems to be looking to see if it's in game mode with
btst #1, $582(A5) (108582)

Seems 108582 is 2 when fighting

It looks like the pause flag is at 108786
0 - not paused
80 - paused
