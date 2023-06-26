; cuenta la cantidad de apariciones de target en el rango de memoria dado

init:
	setr r2, 0x00  ; contador
	setr r3, 0x00  ; rango inf memoria
	setr r4, 0x10  ; rango sup memoria
	setr r5, 0xAA  ; target
	setr r6, 0x01  ; cte 1
	selmb 01b      ; asumo que esta en este memory bank (al menos para la ver 1)
loop:
	readm r3
	cmp r1, r5     ; en r1 esta lo que lei de memoria
	jmpneq finloop ; si no es el target sigo loopeando
	add r2, r6     ; inc contador
finloop:
	add r3, r6     ; inc mem
	cmp r3, r4     ; me fijo si me pase del limite sup
	jmpneq loop
fin: