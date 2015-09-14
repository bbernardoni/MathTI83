SetTI:
	;put a line of 6 pixels to the left of the screen
	di
	push BC
	push HL
	push DE
	ld A, (pencol)
	dec A
	ld C, A
	srl A
	srl A
	srl A
	add A, $20
	ld D, A
	ld A, C
	and 7
	ld C, A
	ld A, 7
	sub C
	ld E, 1
LineLoopShift6:
	or A
	jr Z, LineLoopSkip6
	sla E
	dec A
	jr LineLoopShift6
LineLoopSkip6:
	ld A, $80
	out ($10), A
	call $000B
	ld A, D
	out ($10), A
	in A, ($11)
	ld HL, AppBackUpScreen
	ld B, 6
LineLoopIn6:
	call $000B
	in A, ($11)
	or E
	ld (HL), A
	inc HL
	djnz LineLoopIn6
	call $000B
	ld A, $80
	out ($10), A
	call $000B
	ld A, D
	out ($10), A
	ld HL, AppBackUpScreen
	ld B, 6
LineLoopOut6:
	ld A, (HL)
	inc HL
	call $000B
	out ($11), A
	djnz LineLoopOut6
	pop DE
	pop HL
	pop BC
	ei
	set TextInverse, (IY + TextFlags)
	ret
	
MoveUp:
	call SelectOptionE
	dec E
	jr NZ, UpdateCursor
	ld C, D
	ld B, 0
	ld HL, optionLengths
	add HL, BC
	dec HL
	ld A, (HL)
	ld E, A
	jr UpdateCursor
	
MoveDown:
	call SelectOptionE
	inc E
	ld C, D
	ld B, 0
	ld HL, optionLengths
	add HL, BC
	dec HL
	ld A, (HL)
	inc A
	cp E
	jr NZ, UpdateCursor
	ld E, 1
	jr UpdateCursor
	
UpdateCursor:
	call SelectOptionE
	jp MenuLoop
	
SelectOptionE:
	ld A, E
	add A, A
	ld C, A
	add A, A
	add A, C
	add A, $80
	ld C, A
	di
	out ($10), A
	call $000B
	ld A, $20
	out ($10), A
	in A, ($11)
	ld HL, AppBackUpScreen
	ld B, 6
LineLoopIn:
	call $000B
	in A, ($11)
	xor $FE
	ld (HL), A
	inc HL
	djnz LineLoopIn
	call $000B
	ld A, C
	out ($10), A
	call $000B
	ld A, $20
	out ($10), A
	ld HL, AppBackUpScreen
	ld B, 6
LineLoopOut:
	ld A, (HL)
	inc HL
	call $000B
	out ($11), A
	djnz LineLoopOut
	ei
	ret
	
MoveLeft:
	ld E, 1
	dec D
	jp NZ, Menu
	ld A, (titleLength)
	ld D, A
	jp Menu
	
MoveRight:
	ld E, 1
	inc D
	ld A, (titleLength)
	inc A
	cp D
	jp NZ, Menu
	ld D, 1
	jp Menu