; cuenta la cantidad de apariciones de target en el rango de memoria dado

init:
	setr r1, 0x00  ; contador
	setr r2, 0x00  ; rango inf memoria
	setr r3, 0x10  ; rango sup memoria
	setr r4, 0xAA  ; target
	setr r5, 0x01  ; cte 1
	selmb 01b      ; asumo que esta en este memory bank (al menos para la ver 1)
loop:
	readm r2
	cmp r0, r4     ; en r1 esta lo que lei de memoria
	jmpneq finloop ; si no es el target sigo loopeando
	add r1, r5     ; inc contador
finloop:
	add r2, r5     ; inc mem
	cmp r2, r3     ; me fijo si me pase del limite sup
	jmpneq loop
fin: