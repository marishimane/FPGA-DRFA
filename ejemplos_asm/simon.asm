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

	; writem PATTERN + R4 => Store the LED index in memory to remember the pattern
	setr r5, 0x20
	add r5, r4
	writem r5
	; end writem
	add R4, r7   ; Increase the pattern count

	; Display the pattern by lighting up the LEDs
	setr R1, 0  ; Reset the pattern index

PATTERNLOOP:
	; readm PATTERN + R1 => Get the LED pattern into R0
	setr r5, 0x20
	add r5, r1
	readm r5
	; end readm

	writem 0xFF  ; Set the LEDs according to the pattern
	call DELAY  ; Delays

	setr R0, 0
	writem 0xFF  ; Turn off all LEDs
	call DELAY  ; Delays

	add R1, r7  ; Increment the pattern index
	cmp R1, R4  ; Check if we've shown the whole pattern
	jmpneq PATTERNLOOP  ; If not, repeat

	; Now the player repeats the pattern
	setr R1, 0  ; Reset the pattern index
REPEATLOOP:
	; calls subroutine that waits until data in position 0xFE changes from 0 to anything different
	call WAIT_FOR_INPUT

	readm 0xFE  ; Read the user input from the input port
	setr r6, 0xF  ; Check the reset signal
	and R0, r6   ; Filter out all but the input bits

	cpyr r6, r0 ; User input
	; readm PATTERN + R1 => Get the LED pattern into R0
	setr r5, 0x20
	add r5, r1
	readm r5
	; end readm
	cmp R0, R6  ; Compare it with the pattern
	jmpneq GAMEOVER  ; If it's wrong, game over
	add R1, r7  ; Increment the pattern index
	cmp R1, R4  ; Check if the whole pattern has been repeated
	jmpneq REPEATLOOP  ; If not, repeat

	jmp GAMELOOP  ; Repeat the game loop

GAMEOVER:
	setr R2, 0  ; Initialize loop counter
GAMEOVER_LOOP:
	setr R0, 0xF  ; Set all LEDs on (binary 1111)
	writem 0xFF
	call DELAY  ; Delay for blink effect
	setr R0, 0  ; Set all LEDs off
	writem 0xFF
	call DELAY  ; Delay for blink effect
	readm 0xFE
	setr r6, 0xF  ; Check the reset signal
	and R0, r6   ; Filter out all but the input bits
	cmp R0, r6  ; Compare it with 0xF
	jmpeq RESET  ; If reset signal is set, call RESET
	jmpneq GAMEOVER_LOOP


WAIT_FOR_INPUT:
	readm 0xFE  ; Read the input data into R0
	setr r6, 0xF
	and R0, r6   ; Filter out all but the input bits
	setr r6, 0
	cmp R0, r6  ; Compare the data with 0
	jmpneq WAIT_FOR_INPUT  ; If it's NOT 0, wait: they were writing
WAIT_FOR_INPUT2:
	readm 0xFE  ; Read the input data into R0 
	setr r6, 0xF
	and R0, r6   ; Filter out all but the input bits
	setr r6, 0  ;
	cmp R0, r6  ; Compare the data with 0
	jmpeq WAIT_FOR_INPUT2  ; If it's 0, keep waiting
	ret  ; They wrote! Return from subroutine


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
	setr r0, 0
	setr R6, 1 ; Single delay
DELAY_BIG_LOOP:
	setr R5, 1 ; Single delay
DELAY_MEDIUM_LOOP:
	sub R5, r7
	cmp R5, r0
	jmpneq DELAY_MEDIUM_LOOP
	sub R6, r7
	cmp R6, r0
	jmpneq DELAY_BIG_LOOP
	ret


RESET:
	setr R1, 0
RESET_PATTERN_LOOP:
	setr R0, 0
	setr r5, 0x20
	add r5, r1
	writem r5  ; Clear the pattern memory
	add R1, r7
	cmp R1, R4
	jmpneq RESET_PATTERN_LOOP
	setr R0, 0  
	writem 0x10 ; Clear the counter
	setr R4, 0  ; Clear the pattern count
	jmp START
