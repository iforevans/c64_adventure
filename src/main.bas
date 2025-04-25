REM Hold location object details
DIM ldet$(10,9)
DIM odet$(10,1)

REM --- Load Location Data ---
lc%=0 :REM location count
OPEN 1,8,2,"locdata,s,r"
Readline:
INPUT#1, ol$
IF LEFT$(ol$,3)="LOC" THEN GOSUB ProcessLocationLines
IF LEFT$(ol$,3)="END" THEN GOSUB ProcessObjectLine
IF ST=0 THEN GOTO Readline:

REM --- Load Location Data ---
lc%=0 :REM location count
OPEN 1,8,2,"objdata,s,r"
Readline:
INPUT#1, ol$
IF LEFT$(ol$,3)="LOC" THEN GOSUB ProcessLocationLines
IF LEFT$(ol$,3)="END" THEN GOTO LocLoadDone
IF ST=0 THEN GOTO Readline:
REM All done
LocLoadDone:
CLOSE 1

REM --- Load Object Data ---
oc%=0 :REM location count

REM All Done
END

ProcessLocationLines:
REM 1st line is short desc
INPUT#1, ldet$(lc%, 0)
REM 2nd line is long desc
INPUT#1, ldet$(lc%, 1)
REM 3rd line is exits line
REM exits line = N, E, S, W, U, D, I, O
INPUT#1, ol$

REM Break down exits details
FOR i=0 TO 7
GOSUB FindSemiColon
ldet$(lc%,i+2)=LEFT$(ol$,dp%-1)
ol$ = RIGHT$(ol$, LEN(ol$) - dp%)
NEXT
lc%=lc%+1
RETURN

ProcessObjectLine:
REM line=Description,location
ol$ = RIGHT$(ol$,LEN(ol$)-4) : REM Drop Obj tag

REM Break down object details
FOR i=0 TO 1
GOSUB FindSemiColon
odet$(oc%,i)=LEFT$(ol$,dp%-1)
ol$ = RIGHT$(ol$, LEN(ol$) - dp%)
NEXT
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

