100 REM Text based adventure game for the C64
110 REM
200 OL$ = ""
210 DIM LOCS$(10)
220 DIM OBJS$(10)
230 OPEN 1,8,2,"game.seq,s,r"
240 IF ST = 2 THEN
250 PRINT"game file not found on disk"
260 GOTO 320
270 INPUT#1, OL$
280 PRINT(OL$)
290 IF ST=0 THEN GOTO 270
300 CLOSE 1
400 REM If we get here there was an I/O error
410 PRINT "Error Detected. Exiting."
420 END
