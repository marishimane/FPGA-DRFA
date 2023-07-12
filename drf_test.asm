; cuenta la cantidad de apariciones de target en el rango de memoria dado


selmb 0
setr r0, 0xAA
setr r2, 0x00
writem r2

setr r2, 0x01
writem r2

setr r2, 0x03
writem r2

setr r0, 0xAB
setr r2, 0x02
writem r2

setr r2, 0x04
writem r2

init:
	setr r1, 0x00  ; contador
	setr r2, 0x00  ; rango inf memoria
	setr r3, 0x0F  ; rango sup memoria
	setr r4, 0xAA  ; target
	setr r5, 0x01  ; cte 1
	selmb 00b      ; asumo que esta en este memory bank (al menos para la ver 1)
loop:
	readm r2       ; lee en R0 lo que está en la dirección de memoria dada por R2
	cmp r0, r4     ; en r0 esta lo que lei de memoria
	jmpneq finloop ; si no es el target sigo loopeando
	add r1, r5     ; inc contador
finloop:
	add r2, r5     ; inc mem
	cmp r2, r3     ; me fijo si me pase del limite sup
	jmpneq loop
fin:
	selmb 3
	cpry r0, r1
	setr r0, 0xff
	writem 11111111b
ff:
	jmp ff