selmb 0
setr r0, 0xAA
setr r2, 0x0C
writem 0x0C        ; escribe 0xAA en 0x0C
setr r0, 0x11

init:
	readm r2       ; escribe en R0 lo que está en la dirección de memoria dada por R2
	selmb 3
ff:
	writem 11111111b
	jmp ff