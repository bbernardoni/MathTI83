VERTEX_FORM:
	call PutLine
	.db "Y=AX²+BX+C",0
	ld a, tX
	call Prompt
	.db "A=",0
	ld a, tY
	call Prompt
	.db "B=",0
	ld a, tAns
	call Prompt
	.db "C=",0
	call AppendStrInlineInit
	.db "Y=",0
	bcall(_RclX)
	ld a, 6
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db "(X-",0
	call ParseExpr ;-Y/(2X
	.db tChs,tY,tDiv,tLParen,t2,tX,0
	ld a, 6
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ")²+",0
	call ParseExpr ;Ans-Y²/(4X
	.db tAns,tSub,tY,tSqr,tDiv,tLParen,t4,tX,0
	ld a, 6
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	call Pause
	jp Menu_Start
GIVEN_VERTEX_AND_FOCUS:
	ld a, tA
	call Prompt
	.db "Xv=",0
	ld a, tB
	call Prompt
	.db "Yv=",0
	bcall(_OP1ToOP2)
	ld a, tC
	call Prompt
	.db "Xf=",0
	ld a, tD
	call Prompt
	.db "Yf=",0
	bcall(_CpOP1OP2)
	jr z, GIVEN_VERTEX_AND_FOCUS_HORIZONTAL
	call AppendStrInlineInit
	.db "Y=",0
	call ParseExpr ;1/4/(D-B
	.db t1,tDiv,t4,tDiv,tLParen,tD,tSub,tB,0
	ld a, 6
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db "(X-",0
	call ParseExpr
	.db tA,0
	ld a, 6
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ")²+",0
	call ParseExpr
	.db tB,0
	ld a, 6
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	call Pause
	jp Menu_Start
GIVEN_VERTEX_AND_FOCUS_HORIZONTAL:
	call AppendStrInlineInit
	.db "Y=",0
	call ParseExpr ;1/4/(C-A
	.db t1,tDiv,t4,tDiv,tLParen,tC,tSub,tA,0
	ld a, 6
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db "(X-",0
	call ParseExpr
	.db tB,0
	ld a, 6
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ")²+",0
	call ParseExpr
	.db tA,0
	ld a, 6
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	call Pause
	jp Menu_Start
PARABOLA_INFO:
	ld a, 2
	call InlineOpt
	.db "Y=",0,"X=",0
	or a
	jp z, PARABOLA_INFO_Y
	call PutLine
	.db "X=A(Y-K)²+H",0
	ld a, tAns
	call Prompt
	.db "A=",0
	ld a, tY
	call Prompt
	.db "K=",0
	ld a, tX
	call Prompt
	.db "H=",0
	bcall(_rclAns)
	bcall(_OP2set0)
	bcall(_CPOP1OP2)
	jr c, PARABOLA_INFO_X_LEFT
	call PutLine
	.db "HORIZONTAL RIGHT",0
	jr PARABOLA_INFO_X_CONTINUE
PARABOLA_INFO_X_LEFT:
	call PutLine
	.db "HORIZONTAL LEFT",0
PARABOLA_INFO_X_CONTINUE:
	call AppendStrInlineInit
	.db "VT ",0
	call PrintXY
	call AppendStrInlineInit
	.db "AOS Y=",0
	bcall(_rclY)
	ld a, 10
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	call AppendStrInlineInit
	.db "FOC (",0
	call ParseExpr ;X+1/(4Ans
	.db tX,tAdd,t1,tDiv,tLParen,t4,tAns,0
	ld a, 5
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ",",0
	bcall(_rclY)
	ld a, 4
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ")",0
	call PrintRightAlignStr
	call AppendStrInlineInit
	.db "DIRX X=",0
	call ParseExpr ;X-1/(4Ans
	.db tX,tSub,t1,tDiv,tLParen,t4,tAns,0
	ld a, 9
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	call AppendStrInlineInit
	.db "LR=",0
	call ParseExpr ;1/abs(Ans
	.db t1,tDiv,tabs,tAns,0
	ld a, 13
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	call Pause
	jp Menu_Start
PARABOLA_INFO_Y:
	call PutLine
	.db "Y=A(X-H)²+K",0
	ld a, tAns
	call Prompt
	.db "A=",0
	ld a, tX
	call Prompt
	.db "H=",0
	ld a, tY
	call Prompt
	.db "K=",0
	bcall(_rclAns)
	bcall(_OP2set0)
	bcall(_CPOP1OP2)
	jr c, PARABOLA_INFO_Y_DOWN
	call PutLine
	.db "VERTICAL UP",0
	jr PARABOLA_INFO_Y_CONTINUE
PARABOLA_INFO_Y_DOWN:
	call PutLine
	.db "VERTICAL DOWN",0
PARABOLA_INFO_Y_CONTINUE:
	call AppendStrInlineInit
	.db "VT ",0
	call PrintXY
	call AppendStrInlineInit
	.db "AOS X=",0
	bcall(_rclX)
	ld a, 10
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	call AppendStrInlineInit
	.db "FOC (",0
	bcall(_rclX)
	ld a, 4
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ",",0
	call ParseExpr ;Y+1/(4Ans
	.db tY,tAdd,t1,tDiv,tLParen,t4,tAns,0
	ld a, 5
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ")",0
	call PrintRightAlignStr
	call AppendStrInlineInit
	.db "DIRX Y=",0
	call ParseExpr ;Y-1/(4Ans
	.db tY,tSub,t1,tDiv,tLParen,t4,tAns,0
	ld a, 9
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	call AppendStrInlineInit
	.db "LR=",0
	call ParseExpr ;1/abs(Ans
	.db t1,tDiv,tabs,tAns,0
	ld a, 13
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	call Pause
	jp Menu_Start
CONIC_FORM:
	call PutLine
	.db "AX²+BY²+CX+DY=E",0
	ld a, tA
	call Prompt
	.db "A=",0
	ld a, tB
	call Prompt
	.db "B=",0
	ld a, tC
	call Prompt
	.db "C=",0
	ld a, tD
	call Prompt
	.db "D=",0
	ld a, tE
	call Prompt
	.db "E=",0
	call PutLine
	.db "(X-H)²/A+",0
	call PutLine
	.db "(Y-K)²/B=1",0
	call ParseExpr ;E+C²/(4A)+D²/(4B
	.db tE,tAdd,tC,tSqr,tDiv,tLParen,t4,tA,tRParen,tAdd,tD,tSqr,tDiv,tLParen,t4,tB,0
	bcall(_StoX)
	call AppendStrInlineInit
	.db "H=",0
	call ParseExpr ;-C/(2A
	.db tChs,tC,tDiv,tLParen,t2,tA,0
	ld a, 14
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	call AppendStrInlineInit
	.db "A=",0
	call ParseExpr ;X/A
	.db tX,tDiv,tA,0
	ld a, 14
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	call AppendStrInlineInit
	.db "K=",0
	call ParseExpr ;-D/(2B
	.db tChs,tD,tDiv,tLParen,t2,tB,0
	ld a, 14
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	call AppendStrInlineInit
	.db "B=",0
	call ParseExpr ;X/B
	.db tX,tDiv,tB,0
	ld a, 14
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	call Pause
	jp Menu_Start
CONIC_INFO:
	call PutLine
	.db "(X-H)²/A+",0
	call PutLine
	.db "(Y-K)²/B=1",0
	ld a, tX
	call Prompt
	.db "H=",0
	ld a, tA
	call Prompt
	.db "A=",0
	ld a, tY
	call Prompt
	.db "K=",0
	ld a, tB
	call Prompt
	.db "B=",0
	call ParseExpr
	.db tA,tSub,tB,0
	bcall(_OP2set0)
	bcall(_CPOP1OP2)
	jr c, CONIC_INFO_VERTICAL
	jr nz, CONIC_INFO_HORIZONTAL
	call PutLine
	.db "CIRCLE",0
	call AppendStrInlineInit
	.db "CT ",0
	call PrintXY
	jr CONIC_INFO_CONTINUE
CONIC_INFO_VERTICAL:
	call PutLine
	.db "VERTICAL",0
	call AppendStrInlineInit
	.db "CT ",0
	call PrintXY
	call PutLine
	.db "FOC = Y +/-",0
	call ParseExpr
	.db tAbs,tA,tSub,tB,0
	call PrintInlineSqrt
	jr CONIC_INFO_CONTINUE
CONIC_INFO_HORIZONTAL:
	call PutLine
	.db "HORIZONTAL",0
	call AppendStrInlineInit
	.db "CT ",0
	call PrintXY
	call PutLine
	.db "FOC = X +/-",0
	call ParseExpr
	.db tAbs,tA,tSub,tB,0
	call PrintInlineSqrt
CONIC_INFO_CONTINUE:
	call PutLine
	.db "AXIS LENGTHS",0
	call ParseExpr
	.db t4,tAbs,tA,0
	call PrintInlineSqrt
	call ParseExpr
	.db t4,tAbs,tB,0
	call PrintInlineSqrt
	call Pause
	call ParseExpr
	.db tA,tB,0
	bcall(_OP2set0)
	bcall(_CPOP1OP2)
	jp nc, Menu_Start
	call ParseExpr
	.db tA,tSub,tB,0
	bcall(_OP2set0)
	bcall(_CPOP1OP2)
	jr c, CONIC_INFO_VERTICAL_VTS
	call PutLine
	.db "VTS = X +/-",0
	call ParseExpr
	.db tAbs,tA,0
	call PrintInlineSqrt
	jr CONIC_INFO_CONTINUE_VTS
CONIC_INFO_VERTICAL_VTS:
	call PutLine
	.db "VTS = Y +/-",0
	call ParseExpr
	.db tAbs,tB,0
	call PrintInlineSqrt
CONIC_INFO_CONTINUE_VTS:
	call PutLine
	.db "SLOPE OF ASYM",0
	call ParseExpr
	.db tAbs,tB,tDiv,tA,0
	call PrintInlineSqrt
	call Pause
	jp Menu_Start
CONIC_GRAPHS:
	ld a, 2
	call InlineOpt
	.db "CON",0,"STD FORM",0
	or a
	jp z, CONIC_GRAPHS_CON
	call PutLine
	.db "AX²+BY²+CX+DY=E",0
	ld a, tA
	call Prompt
	.db "A=",0
	ld a, tB
	call Prompt
	.db "B=",0
	ld a, tC
	call Prompt
	.db "C=",0
	ld a, tD
	call Prompt
	.db "D=",0
	ld a, tE
	call Prompt
	.db "E=",0
	call ParseExpr ; A=-A/B
	.db tChs,tA,tDiv,tB,0
	ld a, tA
	call StoOther
	call ParseExpr ; C=-C/B
	.db tChs,tC,tDiv,tB,0
	ld a, tC
	call StoOther
	call ParseExpr ; E=D²/(4B²)+E/B
	.db tD,tSqr,tDiv,tLParen,t4,tB,tSqr,tRParen,tAdd,tE,tDiv,tB,0
	ld a, tE
	call StoOther
	call ParseExpr ; D=-D/(2B
	.db tChs,tD,tDiv,tLParen,t2,tB,0
	ld a, tD
	call StoOther
	; +/-√(AX²+CX+E)+D
	ld hl, 5E03h
	ld (OP1), hl
	ld hl, tQ
	push hl
	ld (OP1+2), hl
	ld hl, CONIC_GRAPHS_CON - CONIC_GRAPHS_STD_EQU
	bcall(_CreateEqu)
	inc de
	inc de
	ld hl, CONIC_GRAPHS_STD_EQU
	ld bc, CONIC_GRAPHS_CON - CONIC_GRAPHS_STD_EQU
	ldir
	bcall(_PushRealO4)
	ld hl, 5E03h
	ld (OP1), hl
	ld hl, tR
	ld (OP1+2), hl
	ld hl, CONIC_GRAPHS_CON - CONIC_GRAPHS_STD_EQU - 1
	bcall(_CreateEqu)
	inc de
	inc de
	ld hl, CONIC_GRAPHS_STD_EQU+1
	ld bc, CONIC_GRAPHS_CON - CONIC_GRAPHS_STD_EQU - 1
	ldir
	;set graphDraw, (iy + graphFlags)
	bcall(_PushRealO4)
	bcall(_DrawCmd)
	bcall(_popRealO1)
	rst rFindSym
	bcall(_DelVar)
	bcall(_DrawCmd)
	bcall(_popRealO1)
	rst rFindSym
	bcall(_DelVar)
	call Pause
	jp Menu_Start
CONIC_GRAPHS_STD_EQU:
	.db tChs,tSqrt,tA,tX,tSqr,tAdd,tC,tX,tAdd,tE,tRParen,tAdd,tD
CONIC_GRAPHS_CON:
	call PutLine
	.db "(X-H)²/A+",0
	call PutLine
	.db "(Y-K)²/B=1",0
	ld a, tC
	call Prompt
	.db "H=",0
	ld a, tA
	call Prompt
	.db "A=",0
	ld a, tD
	call Prompt
	.db "K=",0
	ld a, tB
	call Prompt
	.db "B=",0
	; +/-√(B-B/A(X-C)²)+D
	ld hl, 5E03h
	ld (OP1), hl
	ld hl, tQ
	push hl
	ld (OP1+2), hl
	ld hl, CONIC_GRAPHS_CON_EQU_END - CONIC_GRAPHS_CON_EQU
	bcall(_CreateEqu)
	inc de
	inc de
	ld hl, CONIC_GRAPHS_CON_EQU
	ld bc, CONIC_GRAPHS_CON_EQU_END - CONIC_GRAPHS_CON_EQU
	ldir
	bcall(_PushRealO4)
	ld hl, 5E03h
	ld (OP1), hl
	ld hl, tR
	ld (OP1+2), hl
	ld hl, CONIC_GRAPHS_CON_EQU_END - CONIC_GRAPHS_CON_EQU - 1
	bcall(_CreateEqu)
	inc de
	inc de
	ld hl, CONIC_GRAPHS_CON_EQU+1
	ld bc, CONIC_GRAPHS_CON_EQU_END - CONIC_GRAPHS_CON_EQU - 1
	ldir
	;set graphDraw, (iy + graphFlags)
	bcall(_PushRealO4)
	bcall(_DrawCmd)
	bcall(_popRealO1)
	rst rFindSym
	bcall(_DelVar)
	bcall(_DrawCmd)
	bcall(_popRealO1)
	rst rFindSym
	bcall(_DelVar)
	call Pause
	jp Menu_Start
CONIC_GRAPHS_CON_EQU:
	.db tChs,tSqrt,tB,tSub,tB,tLParen,tX,tSub,tC,tRParen,tSqr,tDiv,tA,tRParen,tAdd,tD
CONIC_GRAPHS_CON_EQU_END: