selmb 3
setr r0, 0xAA
setr r5, 0xFF

writem r5        ; escribe 0xA en el puerto de salida

ff:
	jmp ff
