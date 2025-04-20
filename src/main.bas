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
ol$ = RIGHT$(ol$,LEN(ol$)-4)

REM Save Location Desc
GOSUB FindStr
ldet$(co%,lde%)=LEFT$(ol$,dp%-1)
ol$ = RIGHT$(ol$, LEN(ol$) - dp%)

REM All done
RETURN

FindStr:
i%=1
FindLoop:
IF MID$(ol$, i%, 1) = ";" THEN dp%=i%: RETURN
i%=i%+1
IF i%< LEN(ol$) THEN goto FindLoop
dp%=len(ol$)
RETURN

NextToken:
token$ = LEFT$(ol$, dp% - 1)
ol$ = MID$(ol$, dp% + 1)
RETURN

