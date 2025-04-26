REM Hold location object details
DIM ldet$(10,9)
DIM odet$(10,1)

REM --- Load GameData Data ---
lc%=0
oc%=0
OPEN 1,8,2,"gamedata,s,r"

Readline:
INPUT#1, ol$
IF LEFT$(ol$,3)="LOC" THEN GOSUB LoadLocation
IF LEFT$(ol$,3)="OBJ" THEN GOSUB LoadObject
IF LEFT$(ol$,3)="END" THEN GOTO LoadDone
IF STATUS=0 THEN GOTO Readline:
LoadDone:
CLOSE 1

REM All Done
PRINT "All Game Data Loaded ..."
PRINT "Location Data"
FOR i=0 TO lc%
    PRINT ldet$(i,0)
    PRINT ldet$(i,1)
    FOR j=0 TO 7
        PRINT ldet$(i, j+2);
    NEXT j
    PRINT
NEXT i
PRINT "Object Data"
FOR i=0 TO oc%
    PRINT odet$(i,0)
    PRINT odet$(i,1)
NEXT i


EndProg:
END

LoadLocation:
REM 1st line is short desc
INPUT#1, ldet$(lc%, 0)
REM 2nd line is long desc
INPUT#1, ldet$(lc%, 1)
REM 3rd line is exits line
REM exits line = N, E, S, W, U, D, I, O
INPUT#1, ol$
REM Break down exit details
FOR i=0 TO 7
    GOSUB FindSemiColon
    ldet$(lc%,i+2)=LEFT$(ol$,dp%-1)
    ol$ = RIGHT$(ol$, LEN(ol$) - dp%)
NEXT i
lc%=lc%+1
RETURN

LoadObject:
REM 1st line is short desc
INPUT#1, odet$(oc%, 0)
REM 2nd line is long desc
INPUT#1, odet$(oc%, 1)
oc%=oc%+1
RETURN

FindSemiColon:
dp%=1
FindLoop:
IF MID$(ol$, dp%, 1) = ";" THEN RETURN
dp%=dp%+1
IF dp%< LEN(ol$) THEN GOTO FindLoop
dp%=len(ol$)
RETURN

