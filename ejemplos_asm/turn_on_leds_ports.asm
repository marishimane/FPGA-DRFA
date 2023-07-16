; COUNTER = 0x10

START:
	selmb 3
	setr r0, 0
	writem 0x10
ff:
	call RAND
	writem 11111111b
	jmp ff

RAND:
	readm 0x10  ; Get the current counter value into R0
	setr r1, 1
	add R0, r1  ; Increment the counter
	writem 0x10 ; stores the new counter
	setr r2, 3
	and r0, r2 ; modulo 4

	setr r1, 0
	cmp r0, r1
	jmpeq CERO
	setr r1, 1
	cmp r0, r1
	jmpeq UNO
	setr r1, 2
	cmp r0, r1
	jmpeq DOS
	setr r1, 3
	cmp r0, r1
	jmpeq TRES

CERO:
	setr r0, 00000001b
	ret

UNO:
	setr r0, 00000010b
	ret

DOS:
	setr r0, 00000100b
	ret

TRES:
	setr r0, 00001000b
	ret
