REM Hold location object details
DIM ldet$(10,6)
DIM odet$(10,1)

REM --- Load Game Data ---
oc%=0 :REM object count
lc%=0 :REM location count

OPEN 1,8,2,"gamedata,s,r"
Readline:
INPUT#1, ol$
IF LEFT$(ol$,3)="LOC" THEN GOSUB ProcessLocationLine
IF LEFT$(ol$,3)="OBJ" THEN GOSUB ProcessObjectLine
IF ST=0 THEN GOTO Readline:

REM Test to see if we stored everything correctly
FOR i = 0 TO lc%-1
PRINT ldet$(i, 0);";";
PRINT ldet$(i, 1);";";
PRINT ldet$(i, 2);";";
PRINT ldet$(i, 3);";";
PRINT ldet$(i, 4);";"
NEXT i
REM All done
CLOSE 1
END

ProcessLocationLine:
REM line = Description,North,South,East,West
ol$ = RIGHT$(ol$,LEN(ol$)-4) : REM Drop Loc tag

REM Break down location details
FOR i=0 TO 4
GOSUB FindSemiColon
ldet$(lc%,i)=LEFT$(ol$,dp%-1)
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

