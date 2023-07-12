start:
setr r0, 0xb
setr r5, 0x1
add r0, r5       ; (0140) 0b00000 001 010 00000
selmb 3
writem 11111111b
et:
	jmp et
