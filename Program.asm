; ===============================================================
; Math
; ===============================================================
	set appRetKeyOff, (IY + APIFlg)
	set appTextSave, (IY + appFlags)
	set appAutoScroll, (IY+appFlags)
	res FmtReal, (IY + FmtFlags)
	res FmtPolar, (IY + FmtFlags)
	set FmtRect, (IY + FmtFlags)
	
Menu_Start:
	ld DE, $0101
Menu:
	push DE
	bcall(_clrLCDfull)
	pop DE
	
.include "DispMenu.asm"
	
MenuLoop:
	push DE
	bcall(_RunIndicOff)
	bcall(_GetKey)
	pop DE
	cp kUp
	jp Z, MoveUp
	cp kDown
	jp Z, MoveDown
	cp kLeft
	jp Z, MoveLeft
	cp kRight
	jp Z, MoveRight
	cp k1
	jr C, Skip
	ld C, D
	ld B, 0
	ld HL, optionLengths
	add HL, BC
	dec HL
	ld B, A
	ld A, (HL)
	add A, k1
	ld C, A
	ld A, B
	cp C
	jr NC, MenuLoop
	sub k1
	inc A
	ld E, A
	jr Done
Skip:
	cp kQuit
	jp Z, Quit
	cp kEnter
	jr NZ, MenuLoop
Done:
	ld B, D
	ld A, E
	dec A
	ld HL, optionLengths
	dec B
	jr Z, Prog_Number_Loop_Skip
Prog_Number_Loop:
	add A, (HL)
	inc HL
	djnz Prog_Number_Loop
Prog_Number_Loop_Skip:
	ld D, 0
	ld E, A
	ld HL, Math_Vector_Table
	add HL, DE
	add HL, DE
	ld A, (HL)
	inc HL
	ld H, (HL)
	ld L, A
	push HL
	bcall(_rstrShadow)
	ret
Quit:
	res onInterrupt, (IY + onFlags)
	res appRetKeyOff, (IY + APIFlg)
	res donePrgm, (IY + doneFlags)
	bcall(_JForceCmdNoChar)
	
;to add program edit MenuText, MathVect & MathProgs
.include "MenuFunc.asm"
.include "MathProgs/AlgProgs.asm"
.include "MathProgs/GeoProgs.asm"
.include "MathProgs/TriProgs.asm"
.include "MathProgs/CirProgs.asm"
.include "MathProgs/ConProgs.asm"
.include "MathProgs/StaProgs.asm"
.include "MathProgs/PhyProgs.asm"
.include "MathVect.asm"
.include "MathFunc.asm"
.include "MenuText.asm"
.include "SubMenu.asm"