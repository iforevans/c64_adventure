DIM ldet$(10,10) :REM Location details
DIM odet$(10,2) : REM Object details
REM Directions
dn%=2:de%=3:ds%=4:dw%=5
di%=6:do%=7:du%=8:dd%=9
va%=10 : REM Visited already?
lc%=0 : REM Location count
oc%=0 : REM Object count
pl%=0 : REM Player location
verb$=""
noun$=""
 
PRINT CHR$(147) : REM Clear Scr
PRINT "======================="
PRINT "Adventure by Ifor Evans"
PRINT "======================="
PRINT

GOSUB LoadGameData
REM Main program loop
MainGameLoop:
GOSUB ShowCurrentLoc
ol$="" : REM Just in case the player just presses enter
INPUT "What next"; ol$
GOSUB ParsePlayerInput
IF verb$ = "go" THEN GOSUB HandleGoCommand: GOTO MainGameLoop
IF verb$ = "quit" THEN GOTO EndProg
PRINT "Sorry, but what?"
GOTO MainGameLoop

EndProg:
PRINT "Thanks for playing! See you next time."
REM All Done
END

ShowCurrentLoc:
IF ldet$(pl%, va%) = "N" GOTO PrintFullDesc
PRINT ldet$(pl%, 0)
GOTO ShowExits
PrintFullDesc:
PRINT ldet$(pl%, 1)
ldet$(pl%,va%) = "Y"
ShowExits:
PRINT "Exits:";
IF ldet$(pl%, dn%) <> "-1" THEN PRINT " North";
IF ldet$(pl%, de%) <> "-1" THEN PRINT " East";
IF ldet$(pl%, ds%) <> "-1" THEN PRINT " South";
IF ldet$(pl%, dw%) <> "-1" THEN PRINT " West";
IF ldet$(pl%, du%) <> "-1" THEN PRINT " Up";
IF ldet$(pl%, dd%) <> "-1" THEN PRINT " Down";
IF ldet$(pl%, di%) <> "-1" THEN PRINT " In";
IF ldet$(pl%, do%) <> "-1" THEN PRINT " Out";
PRINT
RETURN


REM Find a way to optimize this!
HandleGoCommand:
dir$=Left$(noun$,1)
IF dir$ <> "n" THEN GOTO CheckEast
IF VAL(ldet$(pl%,dn%)) = -1 THEN GOTO InvalidDirection
pl% = VAL(ldet$(pl%,dn%))
RETURN
CheckEast:
IF dir$ <> "e" THEN GOTO CheckSouth
IF VAL(ldet$(pl%,de%)) = -1 THEN GOTO InvalidDirection
pl% = VAL(ldet$(pl%,de%))
RETURN
CheckSouth:
IF dir$ <> "s" THEN GOTO CheckWest
IF VAL(ldet$(pl%,ds%)) = -1 THEN GOTO InvalidDirection
pl% = VAL(ldet$(pl%,ds%))
RETURN
CheckWest:
IF dir$ <> "w" THEN GOTO CheckIn
IF VAL(ldet$(pl%,dw%)) = -1 THEN GOTO InvalidDirection
pl% = VAL(ldet$(pl%,dw%))
RETURN
CheckIn:
IF dir$ <> "i" THEN GOTO CheckOut
IF VAL(ldet$(pl%,di%)) = -1 THEN GOTO InvalidDirection
pl% = VAL(ldet$(pl%,di%))
RETURN
CheckOut:
IF dir$ <> "o" THEN GOTO InvalidDirection
IF VAL(ldet$(pl%,do%)) = -1 THEN GOTO InvalidDirection
pl% = VAL(ldet$(pl%,do%))
RETURN

InvalidDirection:
PRINT "You can't go that way!"
EndHandleGoCommand:
RETURN

ParsePlayerInput:
sc$=" "
verb$=""
noun$=""
GOSUB FindChar
IF dp% = LEN(ol$) THEN GOTO NoSpaceFound
verb$ = LEFT$(ol$, dp%-1)
noun$ = RIGHT$(ol$, LEN(ol$) - dp%)
RETURN
NoSpaceFound:
verb$=ol$
noun$=""
RETURN

LoadGameData:
REM --- Load GameData Data ---
OPEN 1,8,2,"gamedata,s,r"
Readline:
INPUT#1, ol$
IF LEFT$(ol$,3)="LOC" THEN GOSUB LoadLocation
IF LEFT$(ol$,3)="OBJ" THEN GOSUB LoadObject
IF LEFT$(ol$,3)="END" THEN GOTO LoadDone
IF STATUS=0 THEN GOTO Readline:
LoadDone:
CLOSE 1
RETURN

LoadLocation:
REM 1st line is short desc
INPUT#1, ldet$(lc%, 0)
REM 2nd line is long desc
INPUT#1, ldet$(lc%, 1)
REM 3rd line is exits line
REM exits line = N, E, S, W, U, D, I, O
INPUT#1, ol$
REM Break down exit details
sc$ = ";"
FOR i=0 TO 7
    GOSUB FindChar
    ldet$(lc%,i+2)=LEFT$(ol$,dp%-1)
    ol$ = RIGHT$(ol$, LEN(ol$) - dp%)
NEXT i
ldet$(lc%, va%) = "N" : REM Set visited already status
lc%=lc%+1
RETURN

LoadObject:
REM 1st line is objects start loc
INPUT#1, odet$(oc%, 0)
REM 2nd line is short desc
INPUT#1, odet$(oc%, 1)
REM 3rd line is long desc
INPUT#1, odet$(oc%, 2)
oc%=oc%+1
RETURN

FindChar:
dp%=1
FindLoop:
IF MID$(ol$, dp%, 1) = sc$ THEN RETURN
dp%=dp%+1
IF dp%< LEN(ol$) THEN GOTO FindLoop
dp%=len(ol$)
RETURN

