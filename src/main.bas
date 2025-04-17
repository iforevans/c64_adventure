DIM lid$(100)
DIM ldes$(100)
DIM lno$(100)
DIM lso$(100)
DIM lea$(100)
DIM lwe$(100)
DIM carried(10)
lcount=0: ocount=0: icount=0

REM --- Load Game Data ---
OPEN 1,8,2,"gamedata,s,r"
Readline:
INPUT#1, ol$
IF LEFT$(ol$,3)="LOC" THEN GOSUB HandleLocation
IF ST=0 THEN Readline:
REM All done
CLOSE 1

REM All done
END

REM PROCESS A LOCATION RECORD (CSV: LOC,ID,Description,North,South,East,West)
HandleLocation:
lcount = lcount + 1
GOSUB GetToken  : REM DISCARD "LOC" FIELD
GOSUB GetToken  : lid$(lcount) = token$
GOSUB GetToken  : ldes$(lcount) = token$
GOSUB GetToken  : lno$(lcount) = token$
GOSUB GetToken  : lso$(lcount) = token$
GOSUB GetToken  : lea$(lcount) = token$
GOSUB GetToken  : lwe$(lcount) = token$
RETURN

REM GET TOKEN FROM A$ (CSV DELIMITED BY COMMA)
GetToken:
dp% = INSTR(ol$, ";")
IF dp% = 0 THEN token$ = ol$: ol$ = "": RETURN
token$ = LEFT$(ol$, dp% - 1)
ol$ = MID$(ol$, dp% + 1)
RETURN
