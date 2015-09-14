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
	call SqRoot
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