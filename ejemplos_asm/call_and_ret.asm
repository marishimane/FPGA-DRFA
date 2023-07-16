START:
	selmb 3
	setr r0, 0xFF
	call RAND
ff:
	writem 11111111b ; should write 0xAA in out port
	jmp ff

RAND:
	setr r0, 0xAA
	ret  # Return from subroutine
