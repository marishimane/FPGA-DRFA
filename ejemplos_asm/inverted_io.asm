; invierte lo que esta en el puerto de entrada y lo escribe en el de salida

init:
	setr r2, 0x01 ; cte 1
	selmb 11b     ; seteo el memory bank
prog:
	readm 0xFFFE  ; leo del puerto de entrada
	not r1        ; calculo el inverso aditivo
	add r1, r2
	writem 0xFFFF ; escribo en el puerto de salida
