DIM ldet$(10,9) :REM Location details
DIM odet$(10,2) : REM Object details
lc%=0 : REM Location count
oc%=0 : REM Object count
pl%=0 : REM Player location
verb$=""
noun$=""

GOSUB LoadGameData
PRINT "Adventure by Ifor Evans"
PRINT "Let's begin!"
PRINT
REM Main program loop
MainGameLoop:
PRINT ldet$(pl%, 1)
ol$="" : REM Just in case the player just presses enter
INPUT "What would you like to do"; ol$
GOSUB ParsePlayerInput
PRINT "verb";:PRINT verb$
PRINT "noun";:PRINT noun$
IF verb$ = "quit" THEN GOTO EndProg
PRINT "Sorry, I don't understand wht you mean!"
GOTO MainGameLoop

EndProg:
PRINT "Thanks for playing! See you next time."
REM All Done
END

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

