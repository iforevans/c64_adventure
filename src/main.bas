REM Hold location details
DIM ldet$(10,5)
lde% = 1
lno% = 2
lea% = 3
lso% = 4
lwe% = 5

REM --- Load Game Data ---
CO% = 0
OPEN 1,8,2,"gamedata,s,r"
Readline:
INPUT#1, ol$
IF LEFT$(ol$,3)="LOC" THEN GOSUB HandleLocationLine
IF ST=0 THEN GOTO Readline:

REM All done
CLOSE 1
END

REM PROCESS A LOCATION RECORD (line=LOC,ID,Description,North,South,East,West)
HandleLocationLine:
GOSUB GetToken  : ldet$(lcount, lde%) = token$
GOSUB GetToken  : ldet$(lcount, lno%) = token$
GOSUB GetToken  : ldet$(lcount, lea%) = token$
GOSUB GetToken  : ldet$(lcount, lso%) = token$
GOSUB GetToken  : ldet$(lcount, lwe%) = token$
RETURN

REM Get next token from input line
GetToken:
dp% = 0
MainSplitLoop:
IF dp% <= LEN(ol%) AND MID$(ol$, dp%, dp%) = ";" THEN NextToken
dp% = dp% +1
GOTO MainSplitLoop

IF dp% = 0 THEN token$ = ol$: ol$ = "": RETURN

NextToken:
token$ = LEFT$(ol$, dp% - 1)
ol$ = MID$(ol$, dp% + 1)
RETURN

FindStr:
IF dp% > LEN(ol$) THEN dp% = 0: RETURN
