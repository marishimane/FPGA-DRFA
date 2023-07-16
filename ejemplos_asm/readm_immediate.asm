selmb 0
setr r0, 0xAA
writem 0x88
setr r2, 0x0C
setr r0, 0xFF

init:
	readm 0x88     ; debe escribir 0xAA en R0
	selmb 3
ff:
	writem 11111111b
	jmp ff