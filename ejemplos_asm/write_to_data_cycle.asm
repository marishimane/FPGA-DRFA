; escribe numeros del 1 al 10 en la memoria de datos

init:
	setr r1, 0x01 ; seteo el contador en 1
	setr r2, 0x0B ; seteo el limite en 11
	setr r4, 0x01 ; para sumar 1
	setr r3, 0x00 ; direccion inicial de la memoria de datos
	selmb 00b     ; escribo en el primer memory bank
loop:
	writem r3
	add r1, r4    ; inc contador
	add r3, r4    ; inc mem
	cmp r1, r2    ; me fijo si me pase
	jmpneq loop
fin: