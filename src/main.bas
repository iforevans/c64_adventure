REM Variables setup
DIM ldet$(10,3) :REM Location details
DIM odet$(10,2) : REM Object details
REM Directions (indices into direction string)
dn%=1:de%=dn%+2:ds%=dn%+4:dw%=dn%+6
di%=dn%+8:do%=dn%+10:du%=dn%+12:dd%=dn%+14
va%=3 : REM Visited already?
lc%=0 : REM Location count
oc%=0 : REM Object count
ca%=-1 : REM Object is carried
pl%=0 : REM Player location
verb$=""
noun$=""
 
REM Game Setup
GOSUB LoadGameData
GOSUB DisplaySetup
GOSUB ShowCurrentLoc

REM Main program loop
MainGameLoop:
ol$="" : REM Just in case the player just presses enter
PRINT
INPUT "What next"; ol$
GOSUB ParsePlayerInput
IF verb$ = "go" THEN GOSUB HandleGoCommand: GOTO MainGameLoop
IF verb$ = "look" THEN GOSUB HandleLookCommand: GOTO MainGameLoop
IF verb$ = "inv" THEN GOSUB HandleInvCommand: GOTO MainGameLoop
IF verb$ = "get" THEN GOSUB HandleGetCommand: GOTO MainGameLoop
IF verb$ = "drop" THEN GOSUB HandleDropCommand: GOTO MainGameLoop
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
GOTO ShowObjects
PrintFullDesc:
PRINT ldet$(pl%, 1)
ldet$(pl%,va%) = "Y"
ShowObjects:
PRINT "You can also see: ";
FOR i=0 TO oc%-1
    IF VAL(odet$(i,2)) <> pl% THEN GOTO ObjNotPresent
    PRINT odet$(i,0);
    PRINT " ";
    ObjNotPresent:
NEXT i
PRINT
PRINT "Exits";
IF MID$(ldet$(pl%,2), dn%, 2) <> "-1" THEN PRINT ". North";
IF MID$(ldet$(pl%,2), de%, 2) <> "-1" THEN PRINT ". East";
IF MID$(ldet$(pl%,2), ds%, 2) <> "-1" THEN PRINT ". South";
IF MID$(ldet$(pl%,2), dw%, 2) <> "-1" THEN PRINT ". West";
IF MID$(ldet$(pl%,2), di%, 2) <> "-1" THEN PRINT ". In";
IF MID$(ldet$(pl%,2), do%, 2) <> "-1" THEN PRINT ". Out";
IF MID$(ldet$(pl%,2), du%, 2) <> "-1" THEN PRINT ". Up";
IF MID$(ldet$(pl%,2), dd%, 2) <> "-1" THEN PRINT ". Down";
PRINT
RETURN

HandleDropCommand:
REM Find the object
oi% = -1
FOR i=0 To oc%
    IF odet$(i, 0) = noun$ THEN oi%=i:i=oc%
NEXT i
REM Object exists?
IF oi% = -1 THEN GOTO hdcInvalidRequest:
REM Player already carrying it?
IF odet$(oi%, 2) <> "-1" THEN GOTO hdcInvalidRequest:
REM obj exists, and is carried
odet$(oi%, 2) = STR$(pl%)
PRINT "You drop the ";
PRINT noun$
RETURN
hdcInvalidRequest:
PRINT "You don't have a ";
PRINT  noun$;
RETURN

HandleGetCommand:
REM Find the object
oi% = -1
FOR i=0 To oc%
    IF odet$(i, 0) = noun$ THEN oi%=i:i=oc%
NEXT i
REM Object exists?
IF oi% = -1 THEN GOTO hgcInvalidRequest:
REM Player already carrying it?
IF odet$(oi%, 2) = "-1" THEN GOTO hgcAlreadyCarried
REM Object is in players location?
IF pl% <> VAL(odet$(oi%, 2)) THEN GOTO hgcInvalidRequest
REM obj exists, not already carried, and here!
odet$(oi%, 2) = "-1"
PRINT "You get the ";
PRINT noun$
RETURN
hgcAlreadyCarried:
PRINT "You already have the ";
PRINT noun$
RETURN
hgcInvalidRequest:
PRINT "I don't see a ";
PRINT  noun$;
PRINT " here!"
RETURN

HandleInvCommand:
PRINT "You are carrying: "
FOR i=0 To oc%
    IF odet$(i, 2) <> "-1" THEN GOTO hicNext
    PRINT odet$(i, 0); 
    PRINT " "
hicNext:
NEXT i
RETURN

HandleLookCommand:
ldet$(pl%, va%) = "N"
GOTO ShowCurrentLoc
RETURN

REM Needs optimization
HandleGoCommand:
dir$=Left$(noun$,1)
IF dir$ <> "n" THEN GOTO CheckEast
nl% = VAL(MID$(ldet$(pl%,2), dn%, 2))
IF nl% = -1 THEN GOTO hgcInvalidDirection
pl% = nl%
GOTO hgcValidDirection
CheckEast:
IF dir$ <> "e" THEN GOTO CheckSouth
nl% = VAL(MID$(ldet$(pl%,2), de%, 2))
IF nl% = -1 THEN GOTO hgcInvalidDirection
pl% = nl%
GOTO hgcValidDirection
CheckSouth:
IF dir$ <> "s" THEN GOTO CheckWest
nl% = VAL(MID$(ldet$(pl%,2), ds%, 2))
IF nl% = -1 THEN GOTO hgcInvalidDirection
pl% = nl%
GOTO hgcValidDirection
CheckWest:
IF dir$ <> "w" THEN GOTO CheckIn
nl% = VAL(MID$(ldet$(pl%,2), dw%, 2))
IF nl% = -1 THEN GOTO hgcInvalidDirection
pl% = nl%
GOTO hgcValidDirection
CheckIn:
IF dir$ <> "i" THEN GOTO CheckOut
nl% = VAL(MID$(ldet$(pl%,2), di%, 2))
IF nl% = -1 THEN GOTO hgcInvalidDirection
pl% = nl%
GOTO hgcValidDirection
CheckOut:
IF dir$ <> "o" THEN GOTO hgcInvalidDirection
nl% = VAL(MID$(ldet$(pl%,2), do%, 2))
IF nl% = -1 THEN GOTO hgcInvalidDirection
pl% = nl%
GOTO hgcValidDirection
hgcInvalidDirection:
PRINT "You can't go that way!"
RETURN
hgcValidDirection:
GOSUB ShowCurrentLoc
RETURN

ParsePlayerInput:
sc$=" "
verb$=""
noun$=""
GOSUB FindChar
IF dp% = LEN(ol$) THEN GOTO ppiNoSpaceFound
verb$ = LEFT$(ol$, dp%-1)
noun$ = RIGHT$(ol$, LEN(ol$) - dp%)
RETURN
ppiNoSpaceFound:
verb$=ol$
noun$=""
RETURN

LoadGameData:
REM --- Load GameData Data ---
OPEN 1,8,2,"gamedata,s,r"
lgdReadline:
INPUT#1, ol$
IF LEFT$(ol$,3)="LOC" THEN GOSUB LoadLocation
IF LEFT$(ol$,3)="OBJ" THEN GOSUB LoadObject
IF LEFT$(ol$,3)="END" THEN GOTO lgdLoadDone
IF STATUS=0 THEN GOTO lgdReadline:
lgdLoadDone:
CLOSE 1
RETURN

LoadLocation:
REM 1st line is short desc
INPUT#1, ldet$(lc%, 0)
REM 2nd line is long desc
INPUT#1, ldet$(lc%, 1)
REM 3rd line is exits line
REM NESWIOUP - two chars per direction
INPUT#1, ldet$(lc%, 2)
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
fcLoop:
IF MID$(ol$, dp%, 1) = sc$ THEN RETURN
dp%=dp%+1
IF dp%< LEN(ol$) THEN GOTO fcLoop
dp%=len(ol$)
RETURN

DisplaySetup:
REM Set foreground/background colours
POKE 53281,6 : POKE 53280,6

REM Some useful colours
LB$=CHR$(154): WT$=CHR$(5)
YL$=CHR$(158): CY$=CHR$(159):

REM CLEAR SCREEN, WHITE TEXT
PRINT WT$: PRINT CHR$(147): PRINT CHR$(19);
PRINT "======================="
PRINT "Adventure by Ifor Evans"
PRINT "======================="
PRINT
RETURN