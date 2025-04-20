REM Hold location details
DIM ldet$(10,5)
lde% = 0
lno% = 1
lea% = 2
lso% = 3
lwe% = 4

REM --- Load Game Data ---
co% = 0
OPEN 1,8,2,"gamedata,s,r"
Readline:
INPUT#1, ol$
IF LEFT$(ol$,3)="LOC" THEN GOSUB HandleLocationLine
IF ST=0 THEN GOTO Readline:

REM All done
CLOSE 1
END

REM PROCESS A LOCATION RECORD (line=Description,North,South,East,West)
HandleLocationLine:
ol$ = RIGHT$(ol$,LEN(ol$)-4) : REM Drop Loc tag

REM Break down location details
FOR i=0 TO 4
GOSUB FindStr
ldet$(co%,i)=LEFT$(ol$,dp%-1)
ol$ = RIGHT$(ol$, LEN(ol$) - dp%)
NEXT

REM All done
RETURN

FindStr:
dp%=1
FindLoop:
IF MID$(ol$, dp%, 1) = ";" THEN RETURN
dp%=dp%+1
IF dp%< LEN(ol$) THEN GOTO FindLoop
dp%=len(ol$)
RETURN

NextToken:
token$ = LEFT$(ol$, dp% - 1)
ol$ = MID$(ol$, dp% + 1)
RETURN

