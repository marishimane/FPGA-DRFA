; COUNTER = 0x10
; PATTERN = 0x20

START:
	selmb 3
	setr r0, 0
	writem 0x10
	setr R4, 0  ; Reset pattern count
	setr r7, 1  ; para incrementar
	jmp GAMELOOP

GAMELOOP:
	call RAND   ; Generate a random LED index, returns in R0

	setr r5, 0x20
	add r5, r4
	writem r5  ; writem PATTERN + R4 => Store the LED index in memory to remember the pattern
	add R4, r7   ; Increase the pattern count

	; Display the pattern by lighting up the LEDs
	setr R1, 0  ; Reset the pattern index

PATTERNLOOP:
	setr r5, 0x20
	add r5, r1
	readm r5  ; readm PATTERN + R1 => Get the LED pattern into R0

	writem 0xFF  ; Set the LEDs according to the pattern
	call DELAY  ; Delay
	setr R0, 0  ; Turn off all LEDs
	writem 0xFF
	call DELAY  ; Delay
	add R1, r7  ; Increment the pattern index
	cmp R1, R4  ; Check if we've shown the whole pattern
	jmpneq PATTERNLOOP  ; If not, repeat


	; Now the player repeats the pattern
	setr R1, 0  ; Reset the pattern index
REPEATLOOP:
	; Assuming CHECK logic here that waits for a button press
	readm 0xFE  ; Read the user input from the input port
	cpyr r6, r0 ; User input
	setr r5, 0x20
	add r5, r1
	readm r5  ; readm PATTERN + R1 => Get the LED pattern into R0
	cmp R0, R6  ; Compare it with the pattern
	jmpneq GAMEOVER  ; If it's wrong, game over
	add R1, r7  ; Increment the pattern index
	cmp R1, R4  ; Check if the whole pattern has been repeated
	jmpneq REPEATLOOP  ; If not, repeat

	jmp GAMELOOP  ; Repeat the game loop

GAMEOVER:
	setr R2, 0  ; Initialize loop counter
GAMEOVER_LOOP:
	setr R0, 15  ; Set all LEDs on (binary 1111)
	writem 0xFF
	call DELAY  ; Delay for blink effect
	setr R0, 0  ; Set all LEDs off
	writem 0xFF
	call DELAY  ; Delay for blink effect
	jmpneq GAMEOVER_LOOP



RAND:
	readm 0x10  ; Get the current counter value into R0
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


DELAY:
	setr r6, 2
LOOP_DELAY:
	sub r6, r7
	cmp r6, r7
	jmpneq LOOP_DELAY
	ret