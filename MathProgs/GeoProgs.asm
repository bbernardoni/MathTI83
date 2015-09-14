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
	call SqRoot
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
	.db "R=",0
	ld a, tY
	call Prompt
	.db "θ=",0
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