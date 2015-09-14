QUADRATIC_FORMULA:
	call PutLine
	.db "AX²+BX+C=0",0
	ld a, tX
	call Prompt
	.db "A=",0
	ld a, tY
	call Prompt
	.db "B=",0
	ld a, tAns
	call Prompt
	.db "C=",0
	ld a, 2
	call InlineOpt
	.db "SOLVE",0,"SHOW WORK",0
	or a
	jp nz, QUADRATIC_FORMULA_SHOW_WORK
	call ParseExpr ;(-B+SQRT(B^2-4AC))/(2A)
	.db tLParen,tChs,tY,tAdd,tSqrt,tY,tSqr,tSub,t4,tX,tAns,tRParen,tRParen,tDiv,tLParen,t2,tX,tRParen,0
	bcall(_FormDisp)
	call ParseExpr ;(-B-SQRT(B^2-4AC))/(2A)
	.db tLParen,tChs,tY,tSub,tSqrt,tY,tSqr,tSub,t4,tX,tAns,tRParen,tRParen,tDiv,tLParen,t2,tX,tRParen,0
	call PrintPause
	jp Menu_Start
QUADRATIC_FORMULA_SHOW_WORK:
	bcall(_ClrLCD)
	bcall(_GrBufClr)
	call AppendStrInlineInit
	.db Lneg,"B+-√(B²-4AC)",0
	ld a, 0
	call VPrintCentered
	ld a, 56
	call PrintCenteredLine
	call AppendStrInlineInit
	.db "2A",0
	ld a, 8
	call VPrintCentered
	;-Y+-√(Y²-4XAns)/(2X)
	bcall(_RclY)
	bcall(_InvOP1S)
	ld a, 4
	bcall(_FormReal)
	ld hl, OP3
	call AppendStrInit
	call AppendStrInline
	.db "+-√(",0
	bcall(_RclY)
	ld a, 4
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db "²-4*",0
	bcall(_RclX)
	ld a, 4
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db "*",0
	bcall(_RclAns)
	ld a, 4
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ")",0
	ld a, 14
	call VPrintCentered
	ld a, 42
	call PrintCenteredLine
	call AppendStrInlineInit
	.db "2*",0
	bcall(_RclX)
	ld a, 8
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	ld a, 22
	call VPrintCentered
	;Y+-√(Ans)/X
	call ParseExpr ;Ans=Y²-4XAns
	.db tY,tSqr,tSub,t4,tX,tAns,0
	bcall(_StoAns)
	call ParseExpr ;X=2X
	.db t2,tX,0
	bcall(_StoX)
	bcall(_RclY)
	bcall(_InvOP1S)
	bcall(_StoY)
	ld a, 8
	bcall(_FormReal)
	ld hl, OP3
	call AppendStrInit
	call AppendStrInline
	.db "+-√(",0
	bcall(_RclAns)
	ld a, 8
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ")",0
	ld a, 28
	call VPrintCentered
	ld a, 28
	call PrintCenteredLine
	bcall(_RclX)
	ld a, 8
	bcall(_FormReal)
	ld hl, OP3
	call AppendStrInit
	ld a, 36
	call VPrintCentered
	;Y+-Ans/X
	bcall(_RclY)
	ld a, 8
	bcall(_FormReal)
	ld hl, OP3
	call AppendStrInit
	call AppendStrInline
	.db "+-",0
	call ParseExpr ;Ans=√Ans
	.db tSqrt,tAns,0
	bcall(_StoAns)
	bcall(_CkOP1Cplx)
	jr z, QUADRATIC_FORMULA_CPLX
	ld a, 8
	bcall(_FormReal)
	ld hl, OP3
	jr QUADRATIC_FORMULA_SKIP
QUADRATIC_FORMULA_CPLX:
	bcall(_FormDCplx)
	ld hl, fmtString
QUADRATIC_FORMULA_SKIP:
	call AppendStr
	ld a, 42
	call VPrintCentered
	ld a, 14
	call PrintCenteredLine
	bcall(_RclX)
	ld a, 8
	bcall(_FormReal)
	ld hl, OP3
	call AppendStrInit
	ld a, 50
	call VPrintCentered
	;X, Y
	call ParseExpr ;(Y-Ans)/X
	.db tLParen,tY,tSub,tAns,tRParen,tDiv,tX,0
	bcall(_PushOP1)
	call ParseExpr ;(Y+Ans)/X
	.db tLParen,tY,tAdd,tAns,tRParen,tDiv,tX,0
	ld a, 8
	bcall(_FormReal)
	ld hl, OP3
	call AppendStrInit
	call AppendStrInline
	.db " OR ",0
	bcall(_PopOP1)
	ld a, 8
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	ld a, 57
	call VPrintCentered
	call Pause
	jp Menu_Start
SYSTEMS_OF_EQUATIONS:
	call PutLine
	.db "AX+BY=C DX+EY=F",0
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
	ld a, tF
	call Prompt
	.db "F=",0
	call ParseExpr ;X=DB-AE
	.db tD,tB,tSub,tA,tE,0
	bcall(_StoX)
	call ParseExpr ;(FB-EC)/X
	.db tLParen,tF,tB,tSub,tE,tC,tRParen,tDiv,tX,0
	bcall(_FormDisp)
	call ParseExpr ;(FA-DC)/-X
	.db tLParen,tF,tA,tSub,tD,tC,tRParen,tDiv,tChs,tX,0
	call PrintPause
	jp Menu_Start
REDUCING_RADICALS:
	ld a, tX
	call Prompt
	.db "√",0
	bcall(_OP1Set2)
	bcall(_StoAns)
	bcall(_OP1Set1)
	bcall(_StoY)
REDUCING_RADICALS_LOOP:
	call ParseExpr ;round(X/Ans²,0)*Ans²
	.db tRound,tX,tDiv,tAns,tSqr,tComma,t0,tRParen,tMul,tAns,tSqr,0
	bcall(_OP1toOP2)
	bcall(_RclX)
	bcall(_CpOP1OP2)
	jr nz, REDUCING_RADICALS_CONTINUE
	call ParseExpr ;Y=Y*Ans
	.db tY,tAns,0
	bcall(_StoY)
	call ParseExpr ;X=X/Ans²
	.db tX,tDiv,tAns,tSqr,0
	bcall(_StoX)
	jr REDUCING_RADICALS_LOOP
REDUCING_RADICALS_CONTINUE:
	bcall(_RclAns)
	bcall(_Plus1)
	bcall(_StoAns)
	bcall(_FPSquare)
	bcall(_OP1toOP2)
	bcall(_RclX)
	bcall(_CpOP1OP2)
	jr nc, REDUCING_RADICALS_LOOP
	bcall(_RclY)
	ld a, 7
	bcall(_FormReal)
	ld hl, OP3
	call AppendStrInit
	call AppendStrInline
	.db "√",0
	bcall(_RclX)
	ld a, 8
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	call Pause
	jp Menu_Start
CUBIC_FORMULA:
	call PutLine
	.db "AX³+BX²+CX+D=0",0
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
	call ParseExpr ;B=B/A
	.db tB,tDiv,tA,0
	ld a, tB
	call StoOther
	call ParseExpr ;C=C/A
	.db tC,tDiv,tA,0
	ld a, tC
	call StoOther
	call ParseExpr ;D=D/A
	.db tD,tDiv,tA,0
	ld a, tD
	call StoOther
	call ParseExpr ;X=(3C-B²)/9
	.db tLParen,t3,tC,tSub,tB,tSqr,tRParen,tDiv,t9,0
	bcall(_StoX)
	call ParseExpr ;Y=(-27D+9CB-2B³)/54
	.db tLParen,tChs,t2,t7,tD,tAdd,t9,tC,tB,tSub,t2,tB,tCube,tRParen,tDiv,t5,t4,0
	bcall(_StoY)
	call ParseExpr ;Ans=√X³+Y²
	.db tSqrt,tX,tCube,tAdd,tY,tSqr,0
	bcall(_StoAns)
	call ParseExpr ;X=³√Y+Ans
	.db tCubRt,tY,tAdd,tAns,0
	bcall(_StoX)
	call ParseExpr ;Y=³√Y-Ans
	.db tCubRt,tY,tSub,tAns,0
	bcall(_StoY)
	call ParseExpr ;Ans=√(-3)(X-Y)/2
	.db tSqrt,tChs,t3,tRParen,tLParen,tX,tSub,tY,tRParen,tDiv,t2,0
	bcall(_StoAns)
	call ParseExpr ;-B/3+X+Y
	.db tChs,tB,tDiv,t3,tAdd,tX,tAdd,tY,0
	bcall(_FormDisp)
	call ParseExpr ;-B/3-(X+Y)/2+Ans
	.db tChs,tB,tDiv,t3,tSub,tLParen,tX,tAdd,tY,tRParen,tDiv,t2,tAdd,tAns,0
	bcall(_FormDisp)
	call ParseExpr ;-B/3-(X+Y)/2-Ans
	.db tChs,tB,tDiv,t3,tSub,tLParen,tX,tAdd,tY,tRParen,tDiv,t2,tSub,tAns,0
	call PrintPause
	jp Menu_Start
BINOMIAL_THEOREM:
	call PutLine
	.db "(AX+BY)^E",0
	ld a, tA
	call Prompt
	.db "A=",0
	ld a, tB
	call Prompt
	.db "B=",0
	ld a, tE
	call Prompt
	.db "E=",0
	bcall(_StoX)
BINOMIAL_THEOREM_LOOP:
	call ParseExpr ;Y=E-X
	.db tE,tSub,tX,0
	bcall(_StoY)
	call ParseExpr ;(E nCr Y)*A^X*B^Y
	.db tLParen,tE,tnCr,tY,tRParen,tMul,tA,tPower,tX,tMul,tB,tPower,tY,0
	bcall(_FormDisp)
	call ParseExpr ;7*int(X/7)
	.db t7,tInt,tX,tDiv,t7,0
	bcall(_OP1toOP2)
	bcall(_RclX)
	bcall(_CpOP1OP2)
	bcallz(_getKey)
	bcall(_Minus1)
	bcall(_StoX)
	ld a, (OP1)
	and 80h
	jr z, BINOMIAL_THEOREM_LOOP
	ld hl, (curRow)
	ld (textShadCur), hl
	jp Menu_Start
SEQUENCES:
	call SubMenu
	.db "SEQUENCES",0
	.db 6
	.db "1: FIND Nth TERM",0
	.db "2: COMPLETE THE SEQ",0
	.db "3: FIND MISSING TERMS",0
	.db "4: SERIES SUM",0
	.db "5: GIVEN 2 TERMS",0
	.db "6: INFINITE SERIES",0
	.dw SEQUENCES_FIND_Nth_TERM
	.dw SEQUENCES_COMPLETE_THE_SEQ
	.dw SEQUENCES_FIND_MISSING_TERMS
	.dw SEQUENCES_SERIES_SUM
	.dw SEQUENCES_GIVEN_2_TERMS
	.dw SEQUENCES_INFINITE_SERIES
SEQUENCES_FIND_Nth_TERM:
	ld a, 2
	call InlineOpt
	.db "ART",0,"GEO",0
	or a
	jr z, SEQUENCES_FIND_Nth_TERM_ART
	ld a, tX
	call Prompt
	.db "1ST TERM=",0
	ld a, tY
	call Prompt
	.db "RATIO=",0
	ld a, tAns
	call Prompt
	.db "TERMS=",0
	call ParseExpr ;XY^(Ans-1
	.db tX,tY,tPower,tLParen,tAns,tSub,t1,0
	call PrintPause
	jp Menu_Start
SEQUENCES_FIND_Nth_TERM_ART:
	ld a, tX
	call Prompt
	.db "1ST TERM=",0
	ld a, tY
	call Prompt
	.db "DIFF=",0
	ld a, tAns
	call Prompt
	.db "TERMS=",0
	call ParseExpr ;X+Y(Ans-1
	.db tX,tAdd,tY,tLParen,tAns,tSub,t1,0
	call PrintPause
	jp Menu_Start
SEQUENCES_COMPLETE_THE_SEQ:
	ld a, tX
	call Prompt
	.db "A1=",0
	ld a, tY
	call Prompt
	.db "A2=",0
	ld a, tAns
	call Prompt
	.db "A3=",0
	call ParseExpr ;X+Ans-2Y
	.db tX,tAdd,tAns,tSub,t2,tY,0
	bcall(_CkOP1FP0)
	jr nz, SEQUENCES_COMPLETE_THE_SEQ_GEO
	ld b, 0
	call ParseExpr ;Y-X
	.db tY,tSub,tX,0
	bcall(_StoAns)
	bcall(_OP1Set0)
	bcall(_StoY)
	call SEQUENCES_COMPLETE_THE_SEQ_DISP
	jr SEQUENCES_COMPLETE_THE_SEQ_LOOP
SEQUENCES_COMPLETE_THE_SEQ_GEO:
	ld b, 1
	call ParseExpr ;Y/X
	.db tY,tDiv,tX,0
	bcall(_StoAns)
	bcall(_OP1Set0)
	bcall(_StoY)
	call SEQUENCES_COMPLETE_THE_SEQ_DISP
SEQUENCES_COMPLETE_THE_SEQ_LOOP:
	bcall(_GetKey)
	cp kUp
	jr z, SEQUENCES_COMPLETE_THE_SEQ_UP
	cp kDown
	jr z, SEQUENCES_COMPLETE_THE_SEQ_DOWN
	cp kAdd
	jr z, SEQUENCES_COMPLETE_THE_SEQ_UP
	cp kSub
	jr z, SEQUENCES_COMPLETE_THE_SEQ_DOWN
	cp kStore
	jr z, SEQUENCES_COMPLETE_THE_SEQ_STORE
	cp kQuit
	jr nz, SEQUENCES_COMPLETE_THE_SEQ_LOOP
	jp Menu_Start
SEQUENCES_COMPLETE_THE_SEQ_STORE:
	ld a, tY
	call Prompt
	.db "N=",0
	call SEQUENCES_COMPLETE_THE_SEQ_DISP
	jr SEQUENCES_COMPLETE_THE_SEQ_LOOP
SEQUENCES_COMPLETE_THE_SEQ_UP:
	bcall(_RclY)
	bcall(_Plus1)
	bcall(_StoY)
	call SEQUENCES_COMPLETE_THE_SEQ_DISP
	jr SEQUENCES_COMPLETE_THE_SEQ_LOOP
SEQUENCES_COMPLETE_THE_SEQ_DOWN:
	bcall(_RclY)
	bcall(_Minus1)
	bcall(_StoY)
	call SEQUENCES_COMPLETE_THE_SEQ_DISP
	jr SEQUENCES_COMPLETE_THE_SEQ_LOOP
SEQUENCES_COMPLETE_THE_SEQ_DISP:
	push bc
	call AppendStrInlineInit
	.db "{",0
	bcall(_RclY)
	ld a, 5
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ",",0
	pop af
	xor a
	push af
	jr nz, SEQUENCES_COMPLETE_THE_SEQ_DISP_GEO
	call ParseExpr ;X+Ans(Y-1
	.db tX,tAdd,tAns,tLParen,tY,tSub,t1,0
	jr SEQUENCES_COMPLETE_THE_SEQ_DISP_SKIP
SEQUENCES_COMPLETE_THE_SEQ_DISP_GEO:
	call ParseExpr ;X*Ans^(Y-1
	.db tX,tAns,tPower,tLParen,tY,tSub,t1,0
SEQUENCES_COMPLETE_THE_SEQ_DISP_SKIP:
	ld a, 8
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db "}",0
	call PrintRightAlignStr
	pop bc
	ret
SEQUENCES_FIND_MISSING_TERMS:
	ld a, tA
	call Prompt
	.db "A1=",0
	ld a, tY
	call Prompt
	.db "An=",0
	ld a, tAns
	call Prompt
	.db "N=",0
	ld a, 2
	call InlineOpt
	.db "ART",0,"GEO",0
	or a
	jr z, SEQUENCES_FIND_MISSING_TERMS_ART
	call ParseExpr ;Y=(Ans-1)^√(Y/A
	.db tLParen,tAns,tSub,t1,tRParen,tXRoot,tLParen,tY,tDiv,tA,0
	bcall(_StoY)
	bcall(_OP1Set0)
	bcall(_StoX)
SEQUENCES_FIND_MISSING_TERMS_GEO_LOOP:
	call ParseExpr ;AY^X
	.db tA,tY,tPower,tX,0
	bcall(_FormDisp)
	bcall(_RclX)
	bcall(_Plus1)
	bcall(_StoX)
	bcall(_RclAns)
	bcall(_Minus1)
	bcall(_StoAns)
	call ParseExpr ;7*int(Ans/7)
	.db t7,tInt,tAns,tDiv,t7,0
	bcall(_OP1toOP2)
	bcall(_RclAns)
	bcall(_CpOP1OP2)
	bcallz(_getKey)
	bcall(_OP2Set1)
	bcall(_CpOP1OP2)
	jr nc, SEQUENCES_FIND_MISSING_TERMS_GEO_LOOP
	jp Menu_Start
SEQUENCES_FIND_MISSING_TERMS_ART:
	call ParseExpr ;Y=(Y-A)/(Ans-1
	.db tLParen,tY,tSub,tA,tRParen,tDiv,tLParen,tAns,tSub,t1,0
	bcall(_StoY)
	bcall(_OP1Set0)
	bcall(_StoX)
SEQUENCES_FIND_MISSING_TERMS_ART_LOOP:
	call ParseExpr ;A+YX
	.db tA,tAdd,tY,tX,0
	bcall(_FormDisp)
	bcall(_RclX)
	bcall(_Plus1)
	bcall(_StoX)
	bcall(_RclAns)
	bcall(_Minus1)
	bcall(_StoAns)
	call ParseExpr ;7*int(Ans/7)
	.db t7,tInt,tAns,tDiv,t7,0
	bcall(_OP1toOP2)
	bcall(_RclAns)
	bcall(_CpOP1OP2)
	bcallz(_getKey)
	bcall(_OP2Set1)
	bcall(_CpOP1OP2)
	jr nc, SEQUENCES_FIND_MISSING_TERMS_ART_LOOP
	jp Menu_Start
SEQUENCES_SERIES_SUM:
	ld a, 2
	call InlineOpt
	.db "ART",0,"GEO",0
	or a
	jr z, SEQUENCES_SERIES_SUM_ART
	call PutLine
	.db "(A1(1-R^N))/(1-R",0
	ld a, tX
	call Prompt
	.db "A1=",0
	ld a, tY
	call Prompt
	.db "RATIO=",0
	ld a, tAns
	call Prompt
	.db "N=",0
	call ParseExpr ;(X(1-Y^Ans))/(1-Y
	.db tLParen,tX,tLParen,t1,tSub,tY,tPower,tAns,tRParen,tRParen,tDiv,tLParen,t1,tSub,tY,0
	call PrintPause
	jp Menu_Start
SEQUENCES_SERIES_SUM_ART:
	call PutLine
	.db "(A1+An)N/2",0
	ld a, tX
	call Prompt
	.db "A1=",0
	ld a, tY
	call Prompt
	.db "An=",0
	ld a, tAns
	call Prompt
	.db "N=",0
	call ParseExpr ;(X+Y)Ans/2
	.db tLParen,tX,tAdd,tY,tRParen,tAns,tDiv,t2,0
	call PrintPause
	jp Menu_Start
SEQUENCES_GIVEN_2_TERMS:
	ld a, tA
	call Prompt
	.db "Ax=",0
	ld a, tB
	call Prompt
	.db "X=",0
	ld a, tC
	call Prompt
	.db "Ay=",0
	ld a, tD
	call Prompt
	.db "Y=",0
	ld a, tX
	call Prompt
	.db "TERM=",0
	call ParseExpr ;Ans=D-B
	.db tD,tSub,tB,0
	bcall(_StoAns)
	ld a, 2
	call InlineOpt
	.db "ART",0,"GEO",0
	or a
	jr z, SEQUENCES_GIVEN_2_TERMS_ART
	call ParseExpr ;Ans=(C-A)/Ans
	.db tLParen,tC,tSub,tA,tRParen,tDiv,tAns,0
	bcall(_StoAns)
	call ParseExpr ;Y=A-DB
	.db tA,tSub,tD,tB,0
	bcall(_StoY)
	call ParseExpr ;Y+Ans*X
	.db tY,tAdd,tAns,tX,0
	call PrintPause
	jp Menu_Start
SEQUENCES_GIVEN_2_TERMS_ART:
	call ParseExpr ;Ans=Ans^√(C/A
	.db tAns,tXRoot,tLParen,tC,tDiv,tA,0
	bcall(_StoAns)
	call ParseExpr ;Y=A/D^B
	.db tA,tDiv,tD,tPower,tB,0
	bcall(_StoY)
	call ParseExpr ;YAns^X
	.db tY,tAns,tPower,tX,0
	call PrintPause
	jp Menu_Start
SEQUENCES_INFINITE_SERIES:
	call PutLine
	.db "A1/(1-R)",0
	ld a, tX
	call Prompt
	.db "A1=",0
	ld a, tY
	call Prompt
	.db "RATIO=",0
	call ParseExpr ;X/(1-Y
	.db tX,tDiv,tLParen,t1,tSub,tY,0
	call PrintPause
	jp Menu_Start