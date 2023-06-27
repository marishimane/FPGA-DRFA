; escribe numeros del 1 al 10 en la memoria de datos

init:
	setr r0, 0x01 ; seteo el contador en 1
	setr r1, 0x0B ; seteo el limite en 11
	setr r3, 0x01 ; para sumar 1
	setr r2, 0x00 ; direccion inicial de la memoria de datos
	selmb 00b     ; escribo en el primer memory bank
loop:
	writem r2     ; escribo lo que está en R0 en la dirección dada por R2
	add r0, r3    ; inc contador
	add r2, r3    ; inc mem
	cmp r0, r1    ; me fijo si me pase
	jmpneq loop
fin: