selmb 3
setr r0, 0xFF

writem 0x88        ; escribe 0xFF en la dirección 0x88
setr r0, 0xAA
writem [0x88]      ; escribe 0xAA en 0xFF

ff:
	jmp ff
