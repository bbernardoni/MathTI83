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
	call ParseExpr ;(-B+SQRT(B^2-4AC))/(2A)
	.db tLParen,tChs,tY,tAdd,tSqrt,tY,tSqr,tSub,t4,tX,tAns,tRParen,tRParen,tDiv,tLParen,t2,tX,tRParen,0
	bcall(_FormDisp)
	call ParseExpr ;(-B-SQRT(B^2-4AC))/(2A)
	.db tLParen,tChs,tY,tSub,tSqrt,tY,tSqr,tSub,t4,tX,tAns,tRParen,tRParen,tDiv,tLParen,t2,tX,tRParen,0
	call PrintPause
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
2_POINTS:
	ld a, tA
	call Prompt
	.db "X1=",0
	ld a, tB
	call Prompt
	.db "Y1=",0
	ld a, tC
	call Prompt
	.db "X2=",0
	ld a, tD
	call Prompt
	.db "Y2=",0
	call PutLine
	.db "SLOPE:",0
	call ParseExpr ;(B-D)/(A-C
	.db tLParen,tB,tSub,tD,tRParen,tDiv,tLParen,tA,tSub,tC,0
	bcall(_FormDisp)
	call PutLine
	.db "DISTANCE:",0
	call ParseExpr ;(A-C)²+(B-D)²
	.db tLParen,tA,tSub,tC,tRParen,tSqr,tAdd,tLParen,tB,tSub,tD,tRParen,tSqr,0
	call PrintSqrt
	call PutLine
	.db "MIDPOINT:",0
	call AppendStrInlineInit
	.db "(",0
	call ParseExpr ;(A+C)/2
	.db tLParen,tA,tAdd,tC,tRParen,tDiv,t2,0
	ld a, 6
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ",",0
	call ParseExpr ;(B+D)/2
	.db tLParen,tB,tAdd,tD,tRParen,tDiv,t2,0
	ld a, 7
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ")",0
	call PrintRightAlignStr
	call Pause
	jp Menu_Start
POINT_TO_LINE:
	call PutLine
	.db "Ax+By+C=0 (X,Y)",0
	ld a, tA
	call Prompt
	.db "A=",0
	ld a, tB
	call Prompt
	.db "B=",0
	ld a, tC
	call Prompt
	.db "C=",0
	ld a, tX
	call Prompt
	.db "X=",0
	ld a, tY
	call Prompt
	.db "Y=",0
	call ParseExpr ;abs(AX+BY+C
	.db tAbs,tA,tX,tAdd,tB,tY,tAdd,tC,0
	bcall(_StoAns)
	ld a, 7
	bcall(_FormReal)
	ld hl, OP3
	call AppendStrInit
	call AppendStrInline
	.db "/√",0
	call ParseExpr ;A²+B²
	.db tA,tSqr,tAdd,tB,tSqr,0
	ld a, 7
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	bcall(_SqRoot)
	bcall(_OP1ToOP2)
	bcall(_RclAns)
	bcall(_FPDiv)
	call PrintPause
	jp Menu_Start
RADIANS_TO_DEGREES:
	ld a, 2
	call InlineOpt
	.db "RAD→DEG",0,"DEG→RAD",0
	or a
	jr nz, DEGREES_TO_RADIANS
	ld a, tAns
	call Prompt
	.db "ANGLE=",0
	call ParseExpr ;180*Ans/π
	.db t1,t8,t0,tAns,tDiv,tPi,0
	bcall(_FormDisp)
	set fmtBin,(iy+fmtOverride)
	set fmtHex,(iy+fmtOverride)
	set fmtOct,(iy+fmtOverride)
	bcall(_FormBase)
	ld hl, OP3
	call AppendStrInit
	call PrintRightAlignStr
	res fmtBin,(iy+fmtOverride)
	res fmtHex,(iy+fmtOverride)
	res fmtOct,(iy+fmtOverride)
	jr RADIANS_TO_DEGREES_CONTINUE
DEGREES_TO_RADIANS:
	ld a, tAns
	call Prompt
	.db "ANGLE=",0
	call ParseExpr ;Ans/180
	.db tAns,tDiv,t1,t8,t0,0
	call PrintPi
RADIANS_TO_DEGREES_CONTINUE:
	call Pause
	jp Menu_Start
2_POINTS_3D:
	ld a, tA
	call Prompt
	.db "X1=",0
	ld a, tB
	call Prompt
	.db "Y1=",0
	ld a, tC
	call Prompt
	.db "Z1=",0
	ld a, tD
	call Prompt
	.db "X2=",0
	ld a, tE
	call Prompt
	.db "Y2=",0
	ld a, tF
	call Prompt
	.db "Z2=",0
	call PutLine
	.db "DISTANCE:",0
	call ParseExpr ;(A-D)²+(B-E)²+(C-F)²
	.db tLParen,tA,tSub,tD,tRParen,tSqr,tAdd
	.db tLParen,tB,tSub,tE,tRParen,tSqr,tAdd
	.db tLParen,tC,tSub,tF,tRParen,tSqr,0
	call PrintSqrt
	call PutLine
	.db "MIDPOINT:",0
	call AppendStrInlineInit
	.db "(",0
	call ParseExpr ;(A+D)/2
	.db tLParen,tA,tAdd,tD,tRParen,tDiv,t2,0
	ld a, 6
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ",",0
	call ParseExpr ;(B+E)/2
	.db tLParen,tB,tAdd,tE,tRParen,tDiv,t2,0
	ld a, 6
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ",",0
	call ParseExpr ;(C+F)/2
	.db tLParen,tC,tAdd,tF,tRParen,tDiv,t2,0
	ld a, 6
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ")",0
	call PrintRightAlignStr
	call Pause
	jp Menu_Start
POLAR_COORDINATES:
	ld a, 2
	call InlineOpt
	.db "POL→REC",0,"REC→POL",0
	or a
	jp z, POLAR_TO_RECTANGLE
	ld a, tX
	call Prompt
	.db "X=",0
	ld a, tY
	call Prompt
	.db "Y=",0
	call AppendStrInlineInit
	.db "(",0
	call ParseExpr ;R>Pr(X,Y
	.db tRToPr,tX,tComma,tY,0
	ld a, 6
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ",",0
	call ParseExpr ;R>Po(X,Y
	.db tRToPo,tX,tComma,tY,0
	ld a, 7
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ")",0
	call PrintRightAlignStr
	call Pause
	jp Menu_Start
POLAR_TO_RECTANGLE:
	ld a, tX
	call Prompt
	.db "X=",0
	ld a, tY
	call Prompt
	.db "Y=",0
	call AppendStrInlineInit
	.db "(",0
	call ParseExpr ;P>Rx(X,Y
	.db tPToRx,tX,tComma,tY,0
	ld a, 6
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ",",0
	call ParseExpr ;P>Ry(X,Y
	.db tPToRy,tX,tComma,tY,0
	ld a, 7
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ")",0
	call PrintRightAlignStr
	call Pause
	jp Menu_Start
SURFACE_AREA:
	call SubMenu
	.db "SURFACE AREA",0
	.db 6
	.db "1: CYLINDER LATERAL AREA",0
	.db "2: CYLINDER TOTAL AREA",0
	.db "3: CONE LATERAL AREA",0
	.db "4: CONE TOTAL AREA",0
	.db "5: SPHERE AREA",0
	.db "6: HEMISPHERE AREA",0
	.dw CYLINDER_LATERAL_AREA
	.dw CYLINDER_TOTAL_AREA
	.dw CONE_LATERAL_AREA
	.dw CONE_TOTAL_AREA
	.dw SPHERE_AREA
	.dw HEMISPHERE_AREA
CYLINDER_LATERAL_AREA:
	call PutLine
	.db "2πRH",0
	ld a, tX
	call Prompt
	.db "RADIUS=",0
	ld a, tY
	call Prompt
	.db "HEIGHT=",0
	call ParseExpr ;2XY
	.db t2,tX,tY,0
	call PrintPi
	call Pause
	jp Menu_Start
CYLINDER_TOTAL_AREA:
	call PutLine
	.db "2πRH+2πR²",0
	ld a, tX
	call Prompt
	.db "RADIUS=",0
	ld a, tY
	call Prompt
	.db "HEIGHT=",0
	call ParseExpr ;2XY+2X²
	.db t2,tX,tY,tAdd,t2,tX,tSqr,0
	call PrintPi
	call Pause
	jp Menu_Start
CONE_LATERAL_AREA:
	call PutLine
	.db "πRH",0
	ld a, tX
	call Prompt
	.db "RADIUS=",0
	ld a, tY
	call Prompt
	.db "HEIGHT=",0
	call ParseExpr ;XY
	.db tX,tY,0
	call PrintPi
	call Pause
	jp Menu_Start
CONE_TOTAL_AREA:
	call PutLine
	.db "πRH+πR²",0
	ld a, tX
	call Prompt
	.db "RADIUS=",0
	ld a, tY
	call Prompt
	.db "HEIGHT=",0
	call ParseExpr ;XY+X²
	.db tX,tY,tAdd,tX,tSqr,0
	call PrintPi
	call Pause
	jp Menu_Start
SPHERE_AREA:
	call PutLine
	.db "4πR²",0
	ld a, tX
	call Prompt
	.db "RADIUS=",0
	call ParseExpr ;4X²
	.db t4,tX,tSqr,0
	call PrintPi
	call Pause
	jp Menu_Start
HEMISPHERE_AREA:
	call PutLine
	.db "3πR²",0
	ld a, tX
	call Prompt
	.db "RADIUS=",0
	call ParseExpr ;3X²
	.db t3,tX,tSqr,0
	call PrintPi
	call Pause
	jp Menu_Start
VOLUME:
	call SubMenu
	.db "VOLUME",0
	.db 4
	.db "1: CYLINDER",0
	.db "2: CONE",0
	.db "3: PYRAMID",0
	.db "4: SPHERE",0
	.dw CYLINDER_VOLUME
	.dw CONE_VOLUME
	.dw PYRAMID_VOLUME
	.dw SPHERE_VOLUME
CYLINDER_VOLUME:
	call PutLine
	.db "πR²H",0
	ld a, tX
	call Prompt
	.db "RADIUS=",0
	ld a, tY
	call Prompt
	.db "HEIGHT=",0
	call ParseExpr ;X²Y
	.db tX,tSqr,tY,0
	call PrintPi
	call Pause
	jp Menu_Start
CONE_VOLUME:
	call PutLine
	.db "πR²H/3",0
	ld a, tX
	call Prompt
	.db "RADIUS=",0
	ld a, tY
	call Prompt
	.db "HEIGHT=",0
	call ParseExpr ;X²Y/3
	.db tX,tSqr,tY,tDiv,t3,0
	call PrintPi
	call Pause
	jp Menu_Start
PYRAMID_VOLUME:
	call PutLine
	.db "BH/3",0
	ld a, tX
	call Prompt
	.db "BASE AREA=",0
	ld a, tY
	call Prompt
	.db "HEIGHT=",0
	call ParseExpr ;XY/3
	.db tX,tY,tDiv,t3,0
	call PrintPi
	call Pause
	jp Menu_Start
SPHERE_VOLUME:
	call PutLine
	.db "4/3*πR³",0
	ld a, tX
	call Prompt
	.db "RADIUS=",0
	call ParseExpr ;R³4/3
	.db tX,tCube,t4,tDiv,t3,0
	call PrintPi
	call Pause
	jp Menu_Start
PYTHAGOREAN_THEOREM:
	ld a, 2
	call InlineOpt
	.db "HYP",0,"SIDE",0
	or a
	jr nz, PYTHAGOREAN_THEOREM_SIDE
	call PutLine
	.db "A²+B²=C²",0
	ld a, tX
	call Prompt
	.db "A=",0
	ld a, tY
	call Prompt
	.db "B=",0
	call ParseExpr ;X²+Y²
	.db tX,tSqr,tAdd,tY,tSqr,0
	call PrintSqrt
	jr PYTHAGOREAN_THEOREM_CONTINUE
PYTHAGOREAN_THEOREM_SIDE:
	call PutLine
	.db "A²+B²=C²",0
	ld a, tX
	call Prompt
	.db "A=",0
	ld a, tY
	call Prompt
	.db "C=",0
	call ParseExpr ;Y²-X²
	.db tY,tSqr,tSub,tX,tSqr,0
	call PrintSqrt
PYTHAGOREAN_THEOREM_CONTINUE:
	call Pause
	jp Menu_Start
HERONS_FORMULA:
	call PutLine
	.db "√S(S-A)(S-B)",0
	call AppendStrInlineInit
	.db "(S-C)",0
	call PrintRightAlignStr
	ld a, tA
	call Prompt
	.db "SIDE 1=",0
	ld a, tB
	call Prompt
	.db "SIDE 2=",0
	ld a, tC
	call Prompt
	.db "SIDE 3=",0
	call ParseExpr ;Ans=(A+B+C)/2
	.db tLParen,tA,tAdd,tB,tAdd,tC,tRParen,tDiv,t2,0
	bcall(_StoAns)
	call ParseExpr ;Ans(Ans-A)(Ans-B)(Ans-C)
	.db tAns,tLParen,tAns,tSub,tA,tRParen,tLParen,tAns,tSub,tB,tRParen,tLParen,tAns,tSub,tC,tRParen,0
	call PrintSqrt
	call Pause
	jp Menu_Start
TRIG_ANGLE_AND_SIDE:
	ld a, tX
	call Prompt
	.db "ANGLE=",0
	ld a, tY
	call Prompt
	.db "SIDE=",0
	ld a, 3
	call InlineOpt
	.db "ADJ",0,"OPP",0,"HYP",0
	or a
	jr z, TRIG_ADJ
	dec a
	jp z, TRIG_OPP
	call AppendStrInlineInit
	.db "ADJ=",0
	call ParseExpr ;Ycos(X
	.db tY,tCos,tX,0
	ld a, 12
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	call AppendStrInlineInit
	.db "OPP=",0
	call ParseExpr ;Ysin(X
	.db tY,tSin,tX,0
	ld a, 12
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	call Pause
	jp Menu_Start
TRIG_ADJ:
	call AppendStrInlineInit
	.db "OPP=",0
	call ParseExpr ;Ytan(X
	.db tY,tTan,tX,0
	ld a, 12
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	call AppendStrInlineInit
	.db "HYP=",0
	call ParseExpr ;Y/cos(X
	.db tY,tDiv,tCos,tX,0
	ld a, 12
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	call Pause
	jp Menu_Start
TRIG_OPP:
	call AppendStrInlineInit
	.db "ADJ=",0
	call ParseExpr ;Y/tan(X
	.db tY,tDiv,tTan,tX,0
	ld a, 12
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	call AppendStrInlineInit
	.db "HYP=",0
	call ParseExpr ;Y/sin(X
	.db tY,tDiv,tSin,tX,0
	ld a, 12
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	call Pause
	jp Menu_Start
SOLVE_TRIANGLE:
	;aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
	
	jp Menu_Start
AREA_GIVEN_SAS:
	call PutLine
	.db "ab/2*sin(C)",0
	ld a, tX
	call Prompt
	.db "SIDE 1=",0
	ld a, tAns
	call Prompt
	.db "ANGLE=",0
	ld a, tY
	call Prompt
	.db "SIDE 2=",0
	call ParseExpr ;XY/2sin(Ans
	.db tX,tY,tDiv,t2,tSin,tAns,0
	call PrintPause
	jp Menu_Start
HEIGHT_GIVEN_ASA:
	call PutLine
	.db "b/sin(180-A-C)*",0
	call AppendStrInlineInit
	.db "sin(A)*sin(C)",0
	call PrintRightAlignStr
	ld a, tX
	call Prompt
	.db "ANGLE 1=",0
	ld a, tAns
	call Prompt
	.db "SIDE=",0
	ld a, tY
	call Prompt
	.db "ANGLE 2=",0
	call ParseExpr ;Ans/sin(180-X-Y)sin(X)sin(Y
	.db tAns,tDiv,tsin,t1,t8,t0,tSub,tX,tSub,tY,tRParen,tsin,tX,tRParen,tsin,tY,0
	call PrintPause
	jp Menu_Start
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
	call PutLine
	.db "(θ/180)πR",0
	ld a, tX
	call Prompt
	.db "DEGREES=",0
	ld a, tY
	call Prompt
	.db "RADIUS=",0
	call ParseExpr ;XYπ/180
	.db tX,tY,tDiv,t1,t8,t0,0
	call PrintPi
	call Pause
	jp Menu_Start
SECTOR_AREA:
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
SEGMENT_AREA:
	call PutLine
	.db "θπR²/360-",0
	call AppendStrInlineInit
	.db "R²sin(θ)/2",0
	call PrintRightAlignStr
	ld a, tX
	call Prompt
	.db "DEGREES=",0
	ld a, tY
	call Prompt
	.db "RADIUS=",0
	call ParseExpr ;XπY²/360-Y²/2sin(X
	.db tX,tPi,tY,tSqr,tDiv,t3,t6,t0,tSub,tY,tSqr,tDiv,t2,tSin,tX,0
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
	ld hl, COMPOUND_INTEREST - CONIC_GRAPHS_CON_EQU
	bcall(_CreateEqu)
	inc de
	inc de
	ld hl, CONIC_GRAPHS_CON_EQU
	ld bc, COMPOUND_INTEREST - CONIC_GRAPHS_CON_EQU
	ldir
	bcall(_PushRealO4)
	ld hl, 5E03h
	ld (OP1), hl
	ld hl, tR
	ld (OP1+2), hl
	ld hl, COMPOUND_INTEREST - CONIC_GRAPHS_CON_EQU - 1
	bcall(_CreateEqu)
	inc de
	inc de
	ld hl, CONIC_GRAPHS_CON_EQU+1
	ld bc, COMPOUND_INTEREST - CONIC_GRAPHS_CON_EQU - 1
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
COMPOUND_INTEREST:
	call PutLine
	.db "Y=P(1+R/N)^(NT)",0
	ld a, 4;5
	call InlineOpt
	.db "Y?",0,"P?",0,"R?",0,"T?",0;,"N?",0
	cp 1
	jr z, COMPOUND_INTEREST_P
	cp 2
	jr z, COMPOUND_INTEREST_R
	cp 3
	jp z, COMPOUND_INTEREST_T
	ld a, tA
	call Prompt
	.db "P=",0
	ld a, tB
	call Prompt
	.db "R=",0
	ld a, tC
	call Prompt
	.db "N=",0
	ld a, tD
	call Prompt
	.db "T=",0
	call ParseExpr ;A(1+B/C)^(CD
	.db tA,tLParen,t1,tAdd,tB,tDiv,tC,tRParen,tPower,tLParen,tC,tD,0
	call PrintPause
	jp Menu_Start
COMPOUND_INTEREST_P:
	ld a, tA
	call Prompt
	.db "Y=",0
	ld a, tB
	call Prompt
	.db "R=",0
	ld a, tC
	call Prompt
	.db "N=",0
	ld a, tD
	call Prompt
	.db "T=",0
	call ParseExpr ;A/(1+B/C)^(CD
	.db tA,tDiv,tLParen,t1,tAdd,tB,tDiv,tC,tRParen,tPower,tLParen,tC,tD,0
	call PrintPause
	jp Menu_Start
COMPOUND_INTEREST_R:
	ld a, tA
	call Prompt
	.db "Y=",0
	ld a, tB
	call Prompt
	.db "P=",0
	ld a, tC
	call Prompt
	.db "N=",0
	ld a, tD
	call Prompt
	.db "T=",0
	call ParseExpr ;C((CD)x√(A/B)-1
	.db tC,tLParen,tLParen,tC,tD,tRParen,tXRoot,tLParen,tA,tDiv,tB,tRParen,tSub,t1,0
	call PrintPause
	jp Menu_Start
COMPOUND_INTEREST_T:
	ld a, tA
	call Prompt
	.db "Y=",0
	ld a, tB
	call Prompt
	.db "P=",0
	ld a, tC
	call Prompt
	.db "R=",0
	ld a, tD
	call Prompt
	.db "N=",0
	call ParseExpr ;log(A/B)/(Dlog(1+C/D
	.db tlog,tA,tDiv,tB,tLParen,tDiv,tRParen,tD,tlog,t1,tAdd,tC,tDiv,tD,0
	call PrintPause
	jp Menu_Start
SIMPLIFIED_COMP_INT:
	call PutLine
	.db "Y=P(1+R)^T",0
	ld a, 4
	call InlineOpt
	.db "Y?",0,"P?",0,"R?",0,"T?",0
	cp 1
	jr z, SIMPLIFIED_COMP_INT_P
	cp 2
	jr z, SIMPLIFIED_COMP_INT_R
	cp 3
	jp z, SIMPLIFIED_COMP_INT_T
	ld a, tA
	call Prompt
	.db "P=",0
	ld a, tB
	call Prompt
	.db "R=",0
	ld a, tC
	call Prompt
	.db "T=",0
	call ParseExpr ;A(1+B)^C
	.db tA,tLParen,t1,tAdd,tB,tRParen,tPower,tC,0
	call PrintPause
	jp Menu_Start
SIMPLIFIED_COMP_INT_P:
	ld a, tA
	call Prompt
	.db "Y=",0
	ld a, tB
	call Prompt
	.db "R=",0
	ld a, tC
	call Prompt
	.db "T=",0
	call ParseExpr ;A/(1+B)^C
	.db tA,tDiv,tLParen,t1,tAdd,tB,tRParen,tPower,tC,0
	call PrintPause
	jp Menu_Start
SIMPLIFIED_COMP_INT_R:
	ld a, tA
	call Prompt
	.db "Y=",0
	ld a, tB
	call Prompt
	.db "P=",0
	ld a, tC
	call Prompt
	.db "T=",0
	call ParseExpr ;Cx√(A/B)-1
	.db tC,tXRoot,tLParen,tA,tDiv,tB,tRParen,tSub,t1,0
	call PrintPause
	jp Menu_Start
SIMPLIFIED_COMP_INT_T:
	ld a, tA
	call Prompt
	.db "Y=",0
	ld a, tB
	call Prompt
	.db "P=",0
	ld a, tC
	call Prompt
	.db "R=",0
	call ParseExpr ;log(A/B)/log(1+C
	.db tlog,tA,tDiv,tB,tLParen,tDiv,tlog,t1,tAdd,tC,0
	call PrintPause
	jp Menu_Start
CONTINUOUS_COMP_INT:
	call PutLine
	.db "Y=Ae^(KT)",0
	ld a, 4
	call InlineOpt
	.db "Y?",0,"P?",0,"R?",0,"T?",0
	cp 1
	jr z, CONTINUOUS_COMP_INT_P
	cp 2
	jr z, CONTINUOUS_COMP_INT_R
	cp 3
	jr z, CONTINUOUS_COMP_INT_T
	ld a, tX
	call Prompt
	.db "P=",0
	ld a, tY
	call Prompt
	.db "R=",0
	ld a, tAns
	call Prompt
	.db "T=",0
	call ParseExpr ;Xe^(YAns
	.db tX,tExp,tY,tAns,0
	call PrintPause
	jp Menu_Start
CONTINUOUS_COMP_INT_P:
	ld a, tX
	call Prompt
	.db "Y=",0
	ld a, tY
	call Prompt
	.db "R=",0
	ld a, tAns
	call Prompt
	.db "T=",0
	call ParseExpr ;X/e^(YAns
	.db tX,tDiv,tExp,tY,tAns,0
	call PrintPause
	jp Menu_Start
CONTINUOUS_COMP_INT_R:
	ld a, tX
	call Prompt
	.db "Y=",0
	ld a, tY
	call Prompt
	.db "P=",0
	ld a, tAns
	call Prompt
	.db "T=",0
	call ParseExpr ;ln(X/Y)/Ans
	.db tLn,tX,tDiv,tY,tLParen,tDiv,tAns,0
	call PrintPause
	jp Menu_Start
CONTINUOUS_COMP_INT_T:
	ld a, tX
	call Prompt
	.db "Y=",0
	ld a, tY
	call Prompt
	.db "P=",0
	ld a, tAns
	call Prompt
	.db "R=",0
	call ParseExpr ;ln(X/Y)/Ans
	.db tLn,tX,tDiv,tY,tLParen,tDiv,tAns,0
	call PrintPause
	jp Menu_Start
DATA_INFO:
	call PutLine
	.db "ENTER AS LIST",0
	ld a, tAns
	call Prompt
	.db "DATA=",0
	call AppendStrInlineInit
	.db "MEAN=",0
	call ParseExpr
	.db tMean,tAns,0
	ld a, 11
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	call AppendStrInlineInit
	.db "MEDIAN=",0
	call ParseExpr
	.db tMedian,tAns,0
	ld a, 9
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	call ParseExpr ;sum((Ans-mean(Ans))²)/dim(Ans
	.db tsum,tLParen,tAns,tSub,tMean,tAns,tRParen,tRParen,tSqr,tRParen,tDiv,tDim,tAns,0
	call AppendStrInlineInit
	.db "VARIANCE=",0
	ld a, 7
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	bcall(_SqRoot)
	call AppendStrInlineInit
	.db "STD DEV=",0
	ld a, 8
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call PrintRightAlignStr
	; create lT
	call DATA_INFO_TEMP_NAME
	ld hl, 1
	bcall(_CreateRList)
	ld hl, 0
	push hl
DATA_INFO_MODE_LOOP:
	; get ans[1]
	bcall(_AnsName)
	rst rFindSym
	ld a, (de)
	or a
	jp z, DATA_INFO_MODE_BREAK
	ld hl, 1
	bcall(_GetLToOP1)
	bcall(_PushRealO1)
	; delete ans[1]
	bcall(_AnsName)
	rst rFindSym
	and 1Fh
	ld h, d
	ld l, e
	ld c, (hl)
	inc hl
	ld b, (hl)
	push bc
	ld hl, 1
	ld bc, 1
	bcall(_DelListEl)
	ld hl, 1
	push hl
	ld hl, 0
	push hl
DATA_INFO_MODE_FIND_LOOP:
	; get ans[hl]
	bcall(_AnsName)
	pop hl
	inc hl
	pop bc
	pop de
	bcall(_CpHLDE)
	jr nc, DATA_INFO_MODE_FIND_BREAK
	push de
	push bc
	push hl
	rst rFindSym
	pop hl
	push hl
	bcall(_GetLToOP1)
	bcall(_PopRealO2)
	bcall(_PushRealO2)
	bcall(_CpOP1OP2)
	jr nz, DATA_INFO_MODE_FIND_LOOP
	pop hl
	pop de
	pop bc
	dec hl
	inc de
	dec bc
	push bc
	push de
	push hl
	; del t[(sp)]
	bcall(_AnsName)
	rst rFindSym
	and 1Fh
	pop bc
	push bc
	inc bc
	ld hl, 1
	bcall(_DelListEl)
	jr DATA_INFO_MODE_FIND_LOOP
DATA_INFO_MODE_FIND_BREAK:
	ld h, b
	ld l, c
	pop de
	bcall(_CpHLDE)
	jr c, DATA_INFO_MODE_CONTINUE
	push hl
	jr z, DATA_INFO_MODE_ADD
	; delete t.length-1 elements
	call DATA_INFO_TEMP_NAME
	rst rFindSym
	push de
	ld h, d
	ld l, e
	ld c, (hl)
	inc hl
	ld b, (hl)
	ld h, b
	ld l, c
	dec hl
	ld bc, 2
	bcall(_DelListEl)
	; set t[1]
	bcall(_PopRealO1)
	pop de
	ld hl, 1
	bcall(_PutToL)
	jp DATA_INFO_MODE_LOOP
DATA_INFO_MODE_ADD:
	; addpend from op stack
	call DATA_INFO_TEMP_NAME
	rst rFindSym
	and 1Fh
	bcall(_IncLstSize)
	push de
	push hl
	bcall(_PopRealO1)
	pop hl
	pop de
	bcall(_PutToL)
	jp DATA_INFO_MODE_LOOP
DATA_INFO_MODE_CONTINUE:
	push de
	bcall(_PopRealO1)
	jp DATA_INFO_MODE_LOOP
DATA_INFO_MODE_BREAK:
	pop hl
	call PutLine
	.db "MODE=",0
	call DATA_INFO_TEMP_NAME
	bcall(_FormDisp)
	bcall(_CleanAll)
	call Pause
	jp Menu_Start
DATA_INFO_TEMP_NAME:
	ld hl, 2401h
	ld (OP1), hl
	ld hl, (pTempCnt)
	ld (OP1+2), hl
	ret
MARGIN_OF_ERROR:
	call PutLine
	.db "2√P(1-P)/N",0
	ld a, tX
	call Prompt
	.db "PERCENT=",0
	ld a, tY
	call Prompt
	.db "NUMBER=",0
	call ParseExpr ;2√X(1-X)/Y
	.db t2,tSqrt,tX,tLParen,t1,tSub,tX,tRParen,tDiv,tY,0
	call PrintPause
	jp Menu_Start
NUMBER_FROM_ME:
	call PutLine
	.db "P(1-P)/(M/2)²",0
	ld a, tX
	call Prompt
	.db "PERCENT=",0
	ld a, tY
	call Prompt
	.db "MARGIN=",0
	call ParseExpr ;X(1-X)/(Y/2)²
	.db tX,tLParen,t1,tSub,tX,tRParen,tDiv,tLParen,tY,tDiv,t2,tRParen,tSqr,0
	call PrintPause
	jp Menu_Start
ADDING_POSITION_VECTORS:
	ld a, tA
	call Prompt
	.db "V1R=",0
	ld a, tB
	call Prompt
	.db "V1θ=",0
	ld a, tC
	call Prompt
	.db "V2R=",0
	ld a, tD
	call Prompt
	.db "V2θ=",0
	call AppendStrInlineInit
	.db "(",0
	call ParseExpr ;Acos(B
	.db tA,tCos,tB,0
	bcall(_StoX)
	ld a, 6
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ",",0
	call ParseExpr ;Asin(B
	.db tA,tSin,tB,0
	bcall(_StoY)
	ld a, 7
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ")",0
	call PrintRightAlignStr
	bcall(_RclX)
	ld a, tA
	call StoOther
	bcall(_RclY)
	ld a, tB
	call StoOther
	call AppendStrInlineInit
	.db "(",0
	call ParseExpr ;Ccos(D
	.db tC,tCos,tD,0
	bcall(_StoX)
	ld a, 6
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ",",0
	call ParseExpr ;Csin(D
	.db tC,tSin,tD,0
	bcall(_StoY)
	ld a, 7
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ")",0
	call PrintRightAlignStr
	bcall(_RclX)
	ld a, tC
	call StoOther
	bcall(_RclY)
	ld a, tD
	call StoOther
	call AppendStrInlineInit
	.db "(",0
	call ParseExpr ;A+C
	.db tA,tAdd,tC,0
	bcall(_StoX)
	ld a, 6
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ",",0
	call ParseExpr ;B+D
	.db tB,tAdd,tD,0
	bcall(_StoY)
	ld a, 7
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ")",0
	call PrintRightAlignStr
	call AppendStrInlineInit
	.db "(",0
	call ParseExpr ;R>Pr(X,Y
	.db tRToPr,tX,tComma,tY,0
	ld a, 6
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ",",0
	call ParseExpr ;R>Po(X,Y
	.db tRToPo,tX,tComma,tY,0
	ld a, 7
	bcall(_FormReal)
	ld hl, OP3
	call AppendStr
	call AppendStrInline
	.db ")",0
	call PrintRightAlignStr
	call Pause
	jp Menu_Start
CABLE_TENSION:
	ld a, tX
	call Prompt
	.db "θ1=",0
	ld a, tY
	call Prompt
	.db "θ2=",0
	ld a, tAns
	call Prompt
	.db "F=",0
	call ParseExpr ;Ans/(cos(X)sin(Y)/cos(Y)+sin(X
	.db tAns,tDiv,tLParen,tCos,tX,tRParen,tSin,tY,tLParen,tDiv,tCos,tY,tLParen,tAdd,tSin,tX,0
	bcall(_FormDisp)
	call ParseExpr ;Ans/(cos(Y)sin(X)/cos(X)+sin(Y
	.db tAns,tDiv,tLParen,tCos,tY,tRParen,tSin,tX,tLParen,tDiv,tCos,tX,tLParen,tAdd,tSin,tY,0
	call PrintPause
	jp Menu_Start
ANGLE_BETWEEN_VECTORS:
	call PutLine
	.db "cos",11h,"((u",0Ch,"v)/",0
	call PutLine
	.db "(mag(u)*mag(v))",0
	ld a, tA
	call Prompt
	.db "ui=",0
	ld a, tB
	call Prompt
	.db "uj=",0
	ld a, tC
	call Prompt
	.db "vi=",0
	ld a, tD
	call Prompt
	.db "vj=",0
	call ParseExpr ;cos^-1((AC+BD)/(√(A²+B²)√(C²+D²
	.db tACos,tLParen,tA,tC,tAdd,tB,tD,tRParen,tDiv
	.db tLParen,tSqrt,tA,tSqr,tAdd,tB,tSqr,tRParen,tSqrt,tC,tSqr,tAdd,tD,tSqr,0
	call PrintPause
	jp Menu_Start