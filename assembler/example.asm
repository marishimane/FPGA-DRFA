start:
add r1, r2       ; (0140) 0b00000 001 010 00000
sub R1, R3       ; (0960) 0b00001 001 011 00000
or R2, R3        ; (1260) 0b00010 010 011 00000
and R2, R7       ; (1ae0) 0b00011 010 111 00000
not R3           ; (2300) 0b00100 011 000 00000
cmp R3, R4   ; (2b80) 0b00101 011 100 00000
shr R3   ; (3300) 0b00110 011 000 00000
shl R3    ; (3b00) 0b00111 011 000 00000

cpyr R1, R2  ; (4140) 0b01000 001 010 00000
setr R1, 0xFF ; (49ff) 0b01001 001 11111111

jmp data        ; (8058) 0b10000 000010101 00
jmpeq data     ; (8858) 0b10001 000010101 00
jmpneq data    ; (9058) 0b10010 000010101 00

call data        ; (a058) 0b10100 000010101 00
ret           ; (a800) 0b10101 00000000000

writem 0xFF   ; (e0ff) 0b11100 000 1111 1111
writem [0xFF] ; (e1ff) 0b11100 001 1111 1111
writem R1     ; (e220) 0b11100 010 0010 0000
writem [R1]   ; (e320) 0b11100 011 0010 0000
readm 0xFF  ; (e8ff) 0b11101 000 1111 1111

gflags R2        ; (c200) 0b11000 010 0000 0000
selmb 0x03   ; (ca00) 0b11001 01 0 0000 0000

data:
add R1, R2       ; (0140) 0b00000 001 010 00000
