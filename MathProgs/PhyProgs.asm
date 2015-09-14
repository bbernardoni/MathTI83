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