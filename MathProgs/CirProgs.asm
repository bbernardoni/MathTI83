UNIT_CIRCLE:
	bcall(_ClrLCD)
	bcall(_GrBufClr)
	ld hl, UNIT_CIRCLE_DATA
	push hl
	ld a, 68
	ld (curGX2), a
	ld (curGX), a
	ld a, 31
	ld (curGY2), a
	ld a, 5
	ld (curGY), a
	set useFastCirc, (iy+plotFlag3)
	bcall(_GrphCirc)
	res useFastCirc, (iy+plotFlag3)
UNIT_CIRCLE_LOOP:
	ld bc, 68*256+31
	pop hl
	ld d, (hl)
	inc hl
	ld e, (hl)
	dec hl
	push de
	push hl
	ld h, 1
	bcall(_ILine)
	call AppendStrInlineInit
	.db "rad=",0
	pop hl
	push hl
	or a
	ld de, UNIT_CIRCLE_DATA
	sbc hl, de
	ld a, l
	srl a
	push af
	ld hl, UNIT_CIRCLE_RAD_TEXT
	call FindAthStr
	call AppendStr
	ld hl, 0*256+1
	ld e, 40
	call PrintToE
	;sin
	call AppendStrInlineInit
	.db "sin=",0
	pop af
	push af
	ld hl, UNIT_CIRCLE_SIN_TEXT
	call FindAthStr
	call AppendStr
	ld hl, 10*256+1
	ld e, 40
	call PrintToE
	;cos
	call AppendStrInlineInit
	.db "cos=",0
	pop af
	push af
	add a, 4
	and 1111b
	ld hl, UNIT_CIRCLE_SIN_TEXT
	call FindAthStr
	call AppendStr
	ld hl, 17*256+1
	ld e, 40
	call PrintToE
	;tan
	call AppendStrInlineInit
	.db "tan=",0
	pop af
	push af
	and 111b
	ld hl, UNIT_CIRCLE_TAN_TEXT
	call FindAthStr
	call AppendStr
	ld hl, 24*256+1
	ld e, 40
	call PrintToE
	;cot
	call AppendStrInlineInit
	.db "cot=",0
	pop af
	push af
	sub 4
	neg
	and 111b
	ld hl, UNIT_CIRCLE_TAN_TEXT
	call FindAthStr
	call AppendStr
	ld hl, 31*256+1
	ld e, 40
	call PrintToE
	;sec
	call AppendStrInlineInit
	.db "sec=",0
	pop af
	push af
	ld hl, UNIT_CIRCLE_SEC_TEXT
	call FindAthStr
	call AppendStr
	ld hl, 38*256+1
	ld e, 40
	call PrintToE
	;csc
	call AppendStrInlineInit
	.db "csc=",0
	pop af
	push af
	add a, 12
	and 1111b
	ld hl, UNIT_CIRCLE_SEC_TEXT
	call FindAthStr
	call AppendStr
	ld hl, 45*256+1
	ld e, 40
	call PrintToE
	;(x,y)
	call AppendStrInlineInit
	.db "(",0
	pop af
	push af
	add a, 4
	and 1111b
	ld hl, UNIT_CIRCLE_SIN_TEXT
	call FindAthStr
	call AppendStr
	call AppendStrInline
	.db ",",0
	pop af
	ld hl, UNIT_CIRCLE_SIN_TEXT
	call FindAthStr
	call AppendStr
	call AppendStrInline
	.db ")",0
	ld hl, 57*256+1
	ld e, 48
	call PrintToE
	bcall(_GetKey)
	pop hl
	cp kQuit
	jr z, UNIT_CIRCLE_QUIT
	cp kUp
	jr z, UNIT_CIRCLE_UP
	cp kDown
	jr z, UNIT_CIRCLE_DOWN
	cp kLeft
	jr z, UNIT_CIRCLE_UP
	cp kRight
	jr z, UNIT_CIRCLE_DOWN
	pop de
	push hl
	jp UNIT_CIRCLE_LOOP
UNIT_CIRCLE_CONTINUE:
	pop de
	push hl
	ld bc, 68*256+31
	ld h, 0
	bcall(_ILine)
	jp UNIT_CIRCLE_LOOP
UNIT_CIRCLE_QUIT:
	pop de
	set graphDraw, (iy+graphFlags)
	jp Menu_Start
UNIT_CIRCLE_UP:
	inc hl
	inc hl
	ld a, (UNIT_CIRCLE_DATA+32) / 100h
	cp h
	jr nz, UNIT_CIRCLE_CONTINUE
	ld a, (UNIT_CIRCLE_DATA+32) & FFh
	cp l
	jr nz, UNIT_CIRCLE_CONTINUE
	ld hl, UNIT_CIRCLE_DATA
	jr UNIT_CIRCLE_CONTINUE
UNIT_CIRCLE_DOWN:
	dec hl
	dec hl
	ld a, (UNIT_CIRCLE_DATA-2) / 100h
	cp h
	jr nz, UNIT_CIRCLE_CONTINUE
	ld a, (UNIT_CIRCLE_DATA-2) & FFh
	cp l
	jr nz, UNIT_CIRCLE_CONTINUE
	ld hl, UNIT_CIRCLE_DATA+30
	jr UNIT_CIRCLE_CONTINUE
UNIT_CIRCLE_DATA:
	.db 93, 31, 90, 44, 85, 48, 81, 53
	.db 68, 56, 55, 53, 51, 48, 46, 44
	.db 43, 31, 46, 18, 51, 14, 55,  9
	.db 68,  6, 81,  9, 85, 14, 90, 18
UNIT_CIRCLE_RAD_TEXT:
	.db "0"   ,0,"π/6" ,0,"π/4" ,0,"π/3"  ,0
	.db "π/2" ,0,"2π/3",0,"3π/4",0,"5π/6" ,0
	.db "π"   ,0,"7π/6",0,"5π/4",0,"4π/3" ,0
	.db "3π/2",0,"5π/3",0,"7π/4",0,"11π/6",0
UNIT_CIRCLE_SIN_TEXT:
	.db "0" ,0,"1/2"  ,0,"√2/2" ,0,"√3/2" ,0
	.db "1" ,0,"√3/2" ,0,"√2/2" ,0,"1/2"  ,0
	.db "0" ,0,"-1/2" ,0,"-√2/2",0,"-√3/2",0
	.db "-1",0,"-√3/2",0,"-√2/2",0,"-1/2" ,0
UNIT_CIRCLE_TAN_TEXT:
	.db "0"  ,0,"√3/3",0,"1" ,0,"√3"   ,0
	.db "und",0,"-√3" ,0,"-1",0,"-√3/3",0
UNIT_CIRCLE_SEC_TEXT:
	.db "1"  ,0,"2√3/3" ,0,"√2" ,0,"2"     ,0
	.db "und",0,"-2"    ,0,"-√2",0,"-2√3/3",0
	.db "-1" ,0,"-2√3/3",0,"-√2",0,"-2"    ,0
	.db "und",0,"2"     ,0,"√2" ,0,"2√3/3" ,0
ARC_LENGTH:
	bit trigDeg, (iy+trigFlags)
	jr z, ARC_LENGTH_RAD
	call PutLine
	.db "(θ/180)πR",0
	ld a, tX
	call Prompt
	.db "ANGLE=",0
	ld a, tY
	call Prompt
	.db "RADIUS=",0
	call ParseExpr ;XYπ/180
	.db tX,tY,tDiv,t1,t8,t0,0
	call PrintPi
	call Pause
	jp Menu_Start
ARC_LENGTH_RAD:
	call PutLine
	.db "θR",0
	ld a, tX
	call Prompt
	.db "ANGLE=",0
	ld a, tY
	call Prompt
	.db "RADIUS=",0
	call ParseExpr ;XY
	.db tX,tY,0
	call PrintPause
	jp Menu_Start
SECTOR_AREA:
	bit trigDeg, (iy+trigFlags)
	jr z, SECTOR_AREA_RAD
	call PutLine
	.db "(θ/360)πR²",0
	ld a, tX
	call Prompt
	.db "DEGREES=",0
	ld a, tY
	call Prompt
	.db "RADIUS=",0
	call ParseExpr ;XY²π/360
	.db tX,tY,tSqr,tDiv,t3,t6,t0,0
	call PrintPi
	call Pause
	jp Menu_Start
SECTOR_AREA_RAD:
	call PutLine
	.db "θR²/2",0
	ld a, tX
	call Prompt
	.db "DEGREES=",0
	ld a, tY
	call Prompt
	.db "RADIUS=",0
	call ParseExpr ;XY²/2
	.db tX,tY,tSqr,tDiv,t2,0
	call PrintPause
	jp Menu_Start
SEGMENT_AREA:
	bit trigDeg, (iy+trigFlags)
	jr z, SEGMENT_AREA_RAD
	call PutLine
	.db "θπR²/360-",0
	call AppendStrInlineInit
	.db "R²sin(θ)/2",0
	call PrintRightAlignStr
	ld a, tX
	call Prompt
	.db "ANGLE=",0
	ld a, tY
	call Prompt
	.db "RADIUS=",0
	call ParseExpr ;XπY²/360-Y²/2sin(X
	.db tX,tPi,tY,tSqr,tDiv,t3,t6,t0,tSub,tY,tSqr,tDiv,t2,tSin,tX,0
	call PrintPause
	jp Menu_Start
SEGMENT_AREA_RAD:
	call PutLine
	.db "R²/2(θ-sin(θ))",0
	ld a, tX
	call Prompt
	.db "ANGLE=",0
	ld a, tY
	call Prompt
	.db "RADIUS=",0
	call ParseExpr ;Y²/2(X-sin(X
	.db tY,tSqr,tDiv,t2,tLParen,tX,tSub,tSin,tX,0
	call PrintPause
	jp Menu_Start
CIRCLE_ANGLES:
	call SubMenu
	.db "CIRCLE ANGLES",0
	.db 6
	.db "1: INSCRIBED ANGLE",0
	.db "2: TAN CHORD ANGLE",0
	.db "3: CHORD CHORD ANGLE",0
	.db "4: SEC SEC ANGLE",0
	.db "5: TAN TAN ANGLE",0
	.db "6: SEC TAN ANGLE",0
	.dw INSCRIBED_ANGLE
	.dw INSCRIBED_ANGLE
	.dw CHORD_CHORD_ANGLE
	.dw SEC_TAN_ANGLE
	.dw SEC_TAN_ANGLE
	.dw SEC_TAN_ANGLE
INSCRIBED_ANGLE:
	call PutLine
	.db "A/2",0
	ld a, tAns
	call Prompt
	.db "ANGLE=",0
	call ParseExpr ;Ans/2
	.db tAns,tDiv,t2,0
	call PrintPause
	jp Menu_Start
CHORD_CHORD_ANGLE:
	call PutLine
	.db "(A1+A2)/2",0
	ld a, tX
	call Prompt
	.db "ANGLE=",0
	ld a, tY
	call Prompt
	.db "ANGLE=",0
	call ParseExpr ;(X+Y)/2
	.db tLParen,tX,tAdd,tY,tRParen,tDiv,t2,0
	call PrintPause
	jp Menu_Start
SEC_TAN_ANGLE:
	call PutLine
	.db "(O-I)/2",0
	ld a, tX
	call Prompt
	.db "OUT ANGLE=",0
	ld a, tY
	call Prompt
	.db "IN ANGLE=",0
	call ParseExpr ;(X-Y)/2
	.db tLParen,tX,tSub,tY,tRParen,tDiv,t2,0
	call PrintPause
	jp Menu_Start
CIRCLE_LENGTHS:
	call SubMenu
	.db "CIRCLE ANGLES",0
	.db 6
	.db "1: CHORD-CHORD",0
	.db "2: SEC-SEC IN",0
	.db "3: SEC-SEC OUT",0
	.db "4: TAN-SEC IN",0
	.db "5: TAN-SEC OUT",0
	.db "6: TAN-SEC TAN",0
	.dw CHORD_CHORD_LENGTH
	.dw SEC_SEC_IN_LENGTH
	.dw SEC_SEC_OUT_LENGTH
	.dw TAN_SEC_IN_LENGTH
	.dw TAN_SEC_OUT_LENGTH
	.dw TAN_SEC_TAN_LENGTH
CHORD_CHORD_LENGTH:
	call PutLine
	.db "OO/A",0
	ld a, tX
	call Prompt
	.db "OPP LEN=",0
	ld a, tY
	call Prompt
	.db "OPP LEN=",0
	ld a, tAns
	call Prompt
	.db "ADJ LEN=",0
	call ParseExpr ;XY/Ans
	.db tX,tY,tDiv,tAns,0
	call PrintPause
	jp Menu_Start
SEC_SEC_IN_LENGTH:
	call PutLine
	.db "Oo(Oo+Oi)/Ao-Ao",0
	ld a, tX
	call Prompt
	.db "OPP IN=",0
	ld a, tY
	call Prompt
	.db "OPP OUT=",0
	ld a, tAns
	call Prompt
	.db "ADJ OUT=",0
	call ParseExpr ;Y(Y+X)/Ans-Ans
	.db tY,tLParen,tY,tAdd,tX,tRParen,tDiv,tAns,tSub,tAns,0
	call PrintPause
	jp Menu_Start
SEC_SEC_OUT_LENGTH:
	call PutLine
	.db "(√(Ai²+4Oo²+4OiOo)-Ai)/2",0
	ld a, tX
	call Prompt
	.db "OPP IN=",0
	ld a, tY
	call Prompt
	.db "OPP OUT=",0
	ld a, tAns
	call Prompt
	.db "ADJ IN=",0
	call ParseExpr ;(√(Ans²+4Y²+4XY)-Ans)/2
	.db tLParen,tSqrt,tAns,tSqr,tAdd,t4,tY,tSqr,tAdd,t4,tX,tY,tRParen,tSub,tAns,tRParen,tDiv,t2,0
	call PrintPause
	jp Menu_Start
TAN_SEC_IN_LENGTH:
	call PutLine
	.db "T²/O-O",0
	ld a, tX
	call Prompt
	.db "TAN=",0
	ld a, tY
	call Prompt
	.db "OUT=",0
	call ParseExpr ;X²/Y-Y
	.db tX,tSqr,tDiv,tY,tSub,tY,0
	call PrintPause
	jp Menu_Start
TAN_SEC_OUT_LENGTH:
	call PutLine
	.db "(√(I²+4T²)-I)/2",0
	ld a, tX
	call Prompt
	.db "TAN=",0
	ld a, tY
	call Prompt
	.db "IN=",0
	call ParseExpr ;(√(Y²+4X²)-Y)/2
	.db tLParen,tSqrt,tY,tSqr,tAdd,t4,tX,tSqr,tRParen,tSub,tY,tRParen,tDiv,t2,0
	call PrintPause
	jp Menu_Start
TAN_SEC_TAN_LENGTH:
	call PutLine
	.db "√(O(O+I))",0
	ld a, tX
	call Prompt
	.db "OUT=",0
	ld a, tY
	call Prompt
	.db "IN=",0
	call ParseExpr ;√(X(X+Y
	.db tSqrt,tX,tLParen,tX,tAdd,tY,0
	call PrintPause
	jp Menu_Start