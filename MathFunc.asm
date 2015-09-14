VPutS:
	push AF
	push DE
	push IX
VPutS10:
	LD A,(HL) ; get a character of string name
	INC HL
	OR A ; end of string?
	JR Z, VputS20 ; yes --->
	bcall(_VPutMap) ; display one character of string
	JR NC, VPutS10 ; display rest of string IF FITS
VputS20:
	pop IX
	pop DE
	pop AF
	ret
PutS:
	push BC
	push AF
	ld A,(winBtm)
	ld B,A ; B = bottom line of window
PutS10:
	ld A,(HL) ; get a character of string name
	inc HL
	or A ; end of string?
	scf ; indicate entire string was displayed
	jr Z, PutS20 ; yes --->
	bcall(_PutC) ; display one character of string
	ld A,(curRow) ; check cursor position
	cp B ; off end of window?
	jr C,PutS10 ; no, display rest of string
PutS20:
	ld BC, (curRow)
	ld (textShadCur), BC
	pop BC ; restore A (but not F)
	ld A,B
	pop BC ; restore BC
	ret
PutLine: ;via code stream
	pop HL
	push BC
	push AF
	ld A,(winBtm)
	ld B,A ; B = bottom line of window
PutLine10:
	ld A,(HL) ; get a character of string name
	inc HL
	or A ; end of string?
	scf ; indicate entire string was displayed
	jr Z, PutLine20 ; yes --->
	bcall(_PutC) ; display one character of string
	ld A,(curRow) ; check cursor position
	cp B ; off end of window?
	jr C,PutLine10 ; no, display rest of string
PutLine20:
	ld BC, (curRow)
	ld (textShadCur), BC
	pop BC ; restore A (but not F)
	ld A,B
	pop BC ; restore BC
	push HL
	push AF
	ld A, (curCol)
	or A
	call NZ, NewLine
	pop AF
	ret
;pass prompt sting via code stream, returns op1 //ans
Prompt:
	pop hl
	ld de,ioPrompt
	ld b,a
	bcall(_strcopy);copy prompt string
	inc hl
	push hl
	push bc
	ld hl,PromptStart
	ld de,appBackUpScreen
	ld bc,PromptEnd-PromptStart
	ldir;copy code to saferam
	jp appBackUpScreen
PromptStart:
	res 6,(iy+1Ch)
	res onInterrupt,(iy+onFlags)
	ld a, cxPrgmInput
	bcall(_newContext)
	bcall(_mon)
	set 7,(iy+9)
	ld a, 3Fh
	bcall(_newContext)
	bcall(_ZeroOP1)
	ld hl,2D04h
	ld (OP1),hl
	AppOnErr(PromptErr)
	bcall(_ParseInp)
	AppOffErr
	pop af
	cp tX
	jr nz, $+6
	bcall(_StoX)
	ret
	cp tY
	jr nz, $+6
	bcall(_StoY)
	ret
	cp tAns
	jr nz, $+6
	bcall(_StoAns)
	ret
	call StoOther
	ret
PromptEnd:
PromptErr:
	cp E_Break
	jp z, appBackUpScreen
	call PutLine
	.db "ERROR: TRY AGAIN",0
	jp appBackUpScreen
; starts new line and updates text shadow
NewLine:
	bcall(_newLine)
	ld hl, (curRow)
	ld (textShadCur), hl
	ret
; parse expresion in the code stream and returns op1
ParseExpr:
	ld bc, 2D04h
	ld (OP1), bc
	ld a, 1
	ld (OP1+2), a
	ld bc, 0
	ld (OP1+3), bc
	pop hl
	push hl
	xor a
	cpir
	ld a, b
	cpl
	ld b, a
	ld a, c
	cpl
	ld c, a
	ld h, b
	ld l, c
	bcall(_CreateStrng)
	pop hl
	inc de
	inc de
	ldir
	inc hl
	push hl
	bcall(_OP4ToOP1)
	AppOnErr(ParseExprErr)
	bcall(_ParseInp)
	AppOffErr
	bcall(_PushOP1)
	ld bc, 2D04h
	ld (OP1), bc
	ld a, 1
	ld (OP1+2), a
	ld bc, 0
	ld (OP1+3), bc
	bcall(_ChkFindSym)
	bcall(_DelVar)
	bcall(_PopOP1)
	ret
ParseExprErr:
	pop hl
	cp E_DivBy0
	jr z, ParseExprErrDivBy0
	cp E_Domain
	jr z, ParseExprErrDomain
	call PutLine
	.db "ERROR!",0
	call Pause
	jp Menu_Start
ParseExprErrDivBy0:
	call PutLine
	.db "ERR: DIVIDE BY 0",0
	call Pause
	jp Menu_Start
ParseExprErrDomain:
	call PutLine
	.db "ERR: DOMAIN",0
	call Pause
	jp Menu_Start
; stores variable in other
StoOther:
	push af
	bcall(_PushOP1)
	pop af
	ld hl, 0
	ld (OP1+1), a
	ld (OP1+2), hl
	bcall(_StoOther)
	ret
; displays op1 like disp, then pause
PrintPause:
	bcall(_FormDisp)
; pause and wait for key press
Pause:
	bcall(_getKey)
	ld hl, (curRow)
	ld (textShadCur), hl
	ret
; add string at hl to appBackUpScreen (init call)
AppendStrInit:
	xor a
	ld (appBackUpScreen), a
; add string at hl to appBackUpScreen
AppendStr:
	push hl
	ld hl, appBackUpScreen
	ld bc, 0
	xor a
	cpir
	ld d, h
	ld e, l
	dec de
	pop hl
	bcall(_StrCopy)
	ret
; add string in code stream to appBackUpScreen (init call)
AppendStrInlineInit:
	xor a
	ld (appBackUpScreen), a
; add string in code stream to appBackUpScreen
AppendStrInline:
	ld hl, appBackUpScreen
	ld bc, 0
	xor a
	cpir
	ld d, h
	ld e, l
	dec de
	pop hl
	bcall(_StrCopy)
	jp (hl)
; print string at appBackUpScreen as right aligned
PrintRightAlignStr:
	ld hl, appBackUpScreen
	bcall(_StrLength)
	ld a, 16
	sub c
	and 0Fh
	ld (curcol), a
	bcall(_PutS)
	ld hl, (curRow)
	ld (textShadCur), hl
	ret
; ask for options inline, a = number of options
; input consective options as null terminated strings
InlineOpt:
	ld c, 00h
	ld b, a
InlineOptLoop:
	res textInverse,(iy+textFlags)
	pop hl
	push hl
	xor a
	ld (curcol), a
	ld d, b
InlineOptDispLoop:
	ld a, b
	sub d
	cp c
	jr nz, $+6
	set textInverse,(iy+textFlags)
	call PutS
	res textInverse,(iy+textFlags)
	dec d
	jr z, InlineOptGetKey
	ld a, " "
	bcall(_PutC)
	jr InlineOptDispLoop
InlineOptGetKey:
	res onInterrupt,(iy+onFlags)
	push hl
	push bc
	bcall(_getKey)
	pop bc
	pop hl
	cp kRight
	jr c, InlineOptGetKey
	jr z, InlineOptInc
	cp kLeft
	jr z, InlineOptDec
	cp kEnter
	jr nz, InlineOptGetKey
	ex (sp), hl
	ld d, c
	push de
	ld b, 16
	xor a
	ld (curcol), a
InlineOptEndDispLoop:
	ld a, d
	or a
	jr z, InlineOptEndDispChar
	ld a, " "
	bcall(_PutC)
	xor a
	cp (hl)
	jr nz, InlineOptDecSkipA
	dec d
InlineOptDecSkipA:
	inc hl
	djnz InlineOptEndDispLoop
	jr InlineOptContinue
InlineOptEndDispChar:
	ld a, (hl)
	or a
	jr nz, InlineOptDecSkipB
	dec d
	ld a, " "
InlineOptDecSkipB:
	bcall(_PutC)
	inc hl
	djnz InlineOptEndDispLoop
InlineOptContinue:
	ld hl, (curRow)
	ld (textShadCur), hl
	pop af
	ret
InlineOptInc:
	inc c
	ld a, b
	cp c
	jp nz, InlineOptLoop
	ld c, 0
	jr InlineOptLoop
InlineOptDec:
	dec c
	jp p, InlineOptLoop
	ld c, b
	dec c
	jp InlineOptLoop
;CModB:
;	ld e, c
;	ld a, c
;	ld d, b
;	cp d
;	ret c
;CModBSL:
;	cp d
;	jr c, CModBSLSkip
;	bit 7, d
;	jr nz, CModBMSBSkip
;	sla d
;	jr CModBSL
;CModBMSBSkip:
;	sub d
;	ld e, a
;CModBSLSkip:
;	ld a, e
;	srl d
;	cp d
;	jr c, CModBSubSkip
;	sub d
;CModBSubSkip:
;	ld e, a
;	ld a, b
;	cp d
;	jr nz, CModBSLSkip
;	ld a, e
;	ret	

; Print op1 and sqrt of op1
PrintSqrt:
	call AppendStrInlineInit
	.db "√",0
	ld a, 15
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	call SqRoot
	bcall(_FormDisp)
	ret
; Print op1 and sqrt of op1
PrintInlineSqrt:
	call AppendStrInlineInit
	.db "√",0
	ld a, 5
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db " OR ",0
	call SqRoot
	ld a, 6
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	ret
SqRoot:
	bcall(_CkOP1Pos)
	jr z, SqRootReal
	bcall(_CkOP1FP0)
	jr z, SqRootReal
	bcall(_OP2Set0)
	bcall(_CSqRoot)
	ret
SqRootReal:
	bcall(_SqRoot)
	ret
; Print op1 and pi*op1
PrintPi:
	ld a, 15
	bcall(_FormReal)
	ld hl, OP3
	call AppendStrInit
	call AppendStrInline
	.db "π",0
	call PrintRightAlignStr
	ld a, 4
	bcall(_GETCONOP2)
	bcall(_FPMult)
	bcall(_FormDisp)
	ret
; Pass in ath str and hl for beginning address
FindAthStr:
	or a
	ret z
	ld d, a
	xor a
FindAthStrLoop:
	ld bc, 0
	cpir
	dec d
	jr nz, FindAthStrLoop
	ret
; Print starting at hl to e
PrintToE:
	ld (pencol), hl
	ld hl, appBackUpScreen
	call VPutS
	ld hl, (pencol)
	ld a, l
	cp e
	ret nc
	ld a, h
	add a, 5
	ld d, a
	bcall(_ClearRect)
	ret
; Print (X,Y)
PrintXY:
	call AppendStrInline
	.db "(",0
	bcall(_rclX)
	ld a, 5
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ",",0
	bcall(_rclY)
	ld a, 5
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ")",0
	call PrintRightAlignStr
	ret
; prints a string at appBackUpScreen centered in small text at y posn a, a=x posn
VPrintCentered:
	push af
	ld hl, appBackUpScreen
	bcall(_StrLength)
	push bc
	add hl, bc
	ld d, h
	ld e, l
	dec hl
	lddr
	ld hl, appBackUpScreen
	pop bc
	push bc
	ld (hl), c
	bcall(_SStringLength)
	pop bc
	ld de, appBackUpScreen
	inc hl
	ldir
	dec hl
	ld (hl), 0
	pop hl
	ld l, a
	ld a, 96
	sub l
	jr c, VPrintCenteredCarry
	srl a
	jr VPrintCenteredCont
VPrintCenteredCarry:
	xor a
VPrintCenteredCont:
	ld l, a
	ld (pencol), hl
	ld hl, appBackUpScreen
	call VPutS
	ld h, a
	ld a, (penCol)
	dec a
	ld l, a
	ret
PrintCenteredLine:
	ld b, h
	ld c, a
	ld d, l
	ld e, a
	ld h, 1
	bcall(_ILine)
	ret