SubMenu:
	bcall(_clrLCDfull)
	
	;put a line of 6 pixels to the left of the screen
	di
	ld A, $80
	out ($10), A
	call $000B
	ld A, $20
	out ($10), A
	ld B, 6
SubLineLoop:
	ld A, $80
	call $000B
	out ($11), A
	djnz SubLineLoop
	ei
	
	;display titles
	set TextInverse, (IY + TextFlags)
	ld HL, $0001
	ld (pencol), HL
	pop HL
	call VPutS
	res TextInverse, (IY + TextFlags)
	
	;display options
	ld B, (HL)
	ld C, B
	ld E, $01
	ld A, $00
	inc HL
SubOptionDispLoop:
	add A, $06
	ld D, A
	ld (pencol), DE
	call VPutS
	djnz SubOptionDispLoop
	push HL
	ld B, C
	push BC
	
	;highlight option 1
	ld DE, $0101
	call SelectOptionE
	
SubMenuLoop:
	push DE
	bcall(_RunIndicOff)
	bcall(_GetKey)
	pop DE
	cp kUp
	jr Z, SubMoveUp
	cp kDown
	jr Z, SubMoveDown
	cp k1
	jr C, SubSkip
	ld B, A
	pop AF
	push AF
	add A, k1
	ld C, A
	ld A, B
	cp C
	jr NC, SubMenuLoop
	sub k1
	inc A
	ld E, A
	jr SubDone
SubSkip:
	cp kEnter
	jr Z, SubDone
	cp kQuit
	jp NZ, SubMenuLoop
	pop HL
	pop HL
	jp Menu_Start
SubDone:
	bcall(_rstrShadow)
	pop HL
	pop HL
	dec E
	ld D, 0
	add HL, DE
	add HL, DE
	ld A, (HL)
	inc HL
	ld H, (HL)
	ld L, A
	jp (HL)
	
SubMoveUp:
	call SelectOptionE
	dec E
	jr NZ, SubUpdateCursor
	pop AF
	push AF
	ld E, A
	jr SubUpdateCursor
	
SubMoveDown:
	call SelectOptionE
	inc E
	pop AF
	push AF
	inc A
	cp E
	jr NZ, SubUpdateCursor
	ld E, 1
	jr SubUpdateCursor
	
SubUpdateCursor:
	call SelectOptionE
	jr SubMenuLoop