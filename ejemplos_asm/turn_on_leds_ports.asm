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
	setr r7, 1
	add R0, r7  ; Increment the counter
	setr r6, 3
	and R0, r6  ; Take modulus 4 of the counter to get a number in the range 0-3
	setr R2, 1  ; Start with '0001'
	; Loop to left shift R2 by R0 times

	setr R3, 0  ; Initialize loop counter
SHIFT_LOOP:
	cmp R3, R0
	jmpeq END_SHIFT_LOOP
	shl R2  ; Shift R2 left by 1 bit
	add R3, r7  ; Increment loop counter
	jmp SHIFT_LOOP
END_SHIFT_LOOP:
	writem 0x10  ; Store the updated counter value
	cpyr R0, R2  ; Copy R2 (which holds the LED pattern) to R0
	ret  ; Return from subroutine
