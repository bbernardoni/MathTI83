;display titles
	ld HL, TitleLength
	ld C, (HL)
	ld B, C
	ld HL, $0001
	ld (pencol), HL
	ld HL, titles
TitleDispLoop:
	ld A, C
	sub B
	inc A
	cp D
	call Z, SetTI
	call VPutS
	res TextInverse, (IY + TextFlags)
	ld A, (pencol)
	inc A
	ld (pencol), A
	djnz TitleDispLoop

	;display options
	push DE
	ld C, D
	ld HL, optionLengths
	xor A
OptionLengthLoop:
	dec C
	jr Z, OptionBreakLengthLoop
	add A, (HL)
	inc HL
	jr OptionLengthLoop
OptionBreakLengthLoop:
	ld C, (HL)
	ld HL, options
	ld B, A
	or A
	jr Z, Option0LoopSkip
Option0Loop:
	inc HL
	ld A, (HL)
	or A
	jr NZ, Option0Loop
	inc HL
	djnz Option0Loop
Option0LoopSkip:
	ld B, C
	ld E, $01
	ld A, $00
OptionDispLoop:
	add A, $06
	ld D, A
	ld (pencol), DE
	call VputS
	djnz OptionDispLoop
	pop DE
	
	;highlight option 1
	call SelectOptionE