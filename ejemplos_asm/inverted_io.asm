; invierte lo que esta en el puerto de entrada y lo escribe en el de salida

init:
	setr r1, 0x01 ; cte 1
	selmb 11b     ; seteo el memory bank
prog:
	readm 0xFE    ; leo del puerto de entrada y lo guardo en R0
	not r0        ;
	add r0, r1    ; calculo el inverso aditivo y se guarda en R0
	writem 0xFF   ; escribo en el puerto de salida
