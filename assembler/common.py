#!/usr/bin/python3
# MIT License
# Copyright (c) 2023 David Alejandro Gonzalez Marquez
# ----------------------------------------------------------------------------
# Trabajo Practico - Dise~o de procesadores
# Materia: Programacion de softcores en FPGAs
# Programa de Profesoras/es Visitantes
# ----------------------------------------------------------------------------
# Este codigo esta pensado para que lo utilicen como ejemplo para armar
# el ensamblador de su propia arquitectura.
# No es obligatorio utilizar este codigo como base.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
import sys
import os

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Tokenize function

def tokenizator(filename):
    tokens=[]
    newline=['\n']
    comment=[';']
    blank=[' ','\t']+newline+comment
    reserve=['[',']',',',':','|']

    with open(filename) as f:
        line=[]
        word=""
        isComment=False
        lastLine=False
        while True:
            c = f.read(1)

            if lastLine:
                break

            if not c:
                c=newline[0]
                lastLine=True
            
            if not isComment:
                
                if c in blank:
                    if len(word)>0:
                        line=line+[word]
                    word=""
                    if c in newline or c in comment:
                        if len(line)>0:
                            tokens=tokens+[line]
                        line=[]
                    if c in comment:
                        isComment=True
                        
                elif c in reserve:
                    if len(word)>0:
                        line=line+[word]
                    word=""
                    line=line+[c]
                    
                else:
                    word=word+c
                    
            else: # isComment
                if c in newline:
                    isComment=False
    return tokens

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Assembly code constants

# A
type_RR = [
    "ADD",
    "SUB",
    "OR",
    "AND",
    "COMPARE",
    "COPY_REG"
]
# B
type_R  = ["NOT","SHIFT_RIGHT","SHIFT_LEFT"]
# C
type_DM = ["JUMP","JUMP_EQ","JUMP_NEQ","CALL"]
# D
type_RI  = ["SET_REG"]
# E
type_NOPARAM  = ["RETURN"]
# F
type_MEMORY  = ["WRITE_TO_MEM", "READ_FROM_MEM"]

opcodes = {"ADD":           0b00000,
           "SUB":           0b00001,
           "OR":            0b00010,
           "AND":           0b00011,
           "NOT":           0b00100,
           "COMPARE":       0b00101,
           "SHIFT_RIGHT":   0b00110,
           "SHIFT_LEFT":    0b00111,

           "COPY_REG":      0b01000,
           "SET_REG":       0b01001,

           "JUMP":          0b10000,
           "JUMP_EQ":       0b10001,
           "JUMP_NEQ":      0b10010,

           "CALL":          0b10100,
           "RETURN":        0b10101,

           "WRITE_TO_MEM":  0b11100,
           "READ_FROM_MEM": 0b11101,

           "GET_FLAGS":     0b11000,
           "SEL_MEM_BANK":  0b11001
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Assembly code functions

def removeLabels(tokens,bits):
    if bits == 8:
        size = 2
    if bits == 16:
        size = 1
    instCount=0
    reserveLabel=':'
    instructions=[]
    labels={}
    for t in tokens:
        if len(t) > 1 and t[1]==reserveLabel: # Es label?
            label_name = t[0]
            labels[label_name] = instCount*size
            if len(t)>2: # Soportar cosas como loop: SHIFT_RIGHT R1, es decir, label e instruccion en misma linea
                print("Error: Expected new line, feature not supported by DRFA assembler" )
                raise ValueError()
                # instructions=instructions+[t[2:]]
                # if t[2] in def_DB: // Es codigo?
                #     instCount=instCount+1
                # else:
                #     instCount=instCount+size
        else:
            instructions = instructions + [t[0:]]
            instCount = instCount + size

    return instructions,labels

def reg2num(reg):
    if reg[0]=="R":
        try:
            val = int(reg[1:])
        except ValueError:
            print("Error: Can not convert \"" + reg + "\"")
            return None
        if 0 <= val and val <= 7:
            return val
        print("Error: \"" + reg + "\" out of range (0-7)" )
        raise ValueError()
    else:
        print("Error: \"" + reg + "\" is not a valid register" )
        raise ValueError()

def parseNum(num):
    try:
        if num[0:2] == "0x" or num[0:2] == "0X":
            val = int(num[2:],16)
        elif num[-1:] == "b":
            val = int(num[:-1],2)
        else:
            val = int(num,10)        
    except ValueError:
        print("Error: Can not convert \"" + num + "\"")
        return None
    if 0 <= val and val <= 255:
        return val
    print("Error: \"" + num + "\" out of range (0-255)" )
    raise ValueError()

def mem2num(mem,labels):
    if mem in labels.keys():
        return labels[mem]
    else:
        parseNum(mem)

def shf2num(num):
    val = parseNum(num)
    if 0 <= val and val <= 7:
        return val
    print("Error: \"" + num + "\" out of range (0-7)" )
    raise ValueError()
    
def buidInst(d):
    n = 0
    if "O" in d:
        n = n + (d["O"] << 11)
    if "X" in d:
        n = n + (d["X"] << 8)
    if "Y" in d:
        n = n + (d["Y"] << 5)
    if "CM" in d:
        n = n + (d["CM"] << 2)
    if "DM" in d:
        n = n + (d["DM"])
    if "MEM_OPCODE" in d:
        n = n + (d["MEM_OPCODE"] << 8)
    if "MEM_REG" in d:
        n = n + (d["MEM_REG"] << 5)
    if "M" in d:
        n = n + (d["M"])
    if "I" in d:
        n = n + (d["I"])
    return n

def appendParse8(parseBytes,parseHuman,i,n):
    addr=len(parseBytes)
    parseBytes.append(n >> 8)
    parseBytes.append(n & 0xFF)
    parseHuman.append([addr,i])
    
def appendParse16(parseBytes,parseHuman,i,n):
    addr=len(parseBytes)
    parseBytes.append(n)
    parseHuman.append([addr,i])

def parseInstructions(instructions,labels):
    parseBytes=[]
    parseHuman=[]
    for i in instructions:
        try:
            # type_RR : AAA Rx,Ry
            if i[0] in type_RR:
                if i[2] == ",":
                    n = buidInst({"O":opcodes[i[0]], "X":reg2num(i[1]), "Y":reg2num(i[3])})
                    appendParse16(parseBytes,parseHuman,i,n)
                else:
                    raise ValueError("Error: Invalid instruction \"" + i[0] + "\"")
                    break
                
            # type_R : AAA Rx
            elif i[0] in type_R:
                if len(i) > 1:
                    n = buidInst({"O":opcodes[i[0]], "X":reg2num(i[1])})
                    appendParse16(parseBytes,parseHuman,i,n)
                else:
                    raise ValueError("Error: Invalid instruction \"" + i[0] + "\"")
                    break

            # type_RI : AAA Rx, Imm
            elif i[0] in type_RI:
                if i[2] == ",":
                    n = buidInst({"O":opcodes[i[0]], "X":reg2num(i[1]), "I":parseNum(i[3])})
                    appendParse16(parseBytes,parseHuman,i,n)
                else:
                    raise ValueError("Error: Invalid instruction \"" + i[0] + "\"")
                    break

            # type_DM : AAA Imm (9 bits)
            elif i[0] in type_DM:
                if len(i) > 1:
                    n = buidInst({"O":opcodes[i[0]], "CM":mem2num(i[1], labels)})
                    appendParse16(parseBytes,parseHuman,i,n)
                else:
                    raise ValueError("Error: Invalid instruction \"" + i[0] + "\"")
                    break

            # type_NOPARAM : AAA xxxxxxx
            elif i[0] in type_NOPARAM:
                if len(i) > 0:
                    n = buidInst({"O":opcodes[i[0]]})
                    appendParse16(parseBytes,parseHuman,i,n)
                else:
                    raise ValueError("Error: Invalid instruction \"" + i[0] + "\"")
                    break

            # type_MEMORY : AAA Rx | [Rx] | M | [M]
            elif i[0] in type_MEMORY:
                if len(i) == 2:
                    operand = i[1]

                    # es un registro R0-R7
                    if(operand[0] == "R"):
                        n = buidInst({
                            "O":opcodes[i[0]],
                            "MEM_OPCODE": 0b010,
                            "MEM_REG": reg2num(operand)
                        })
                        appendParse16(parseBytes,parseHuman,i,n)

                    # es memoria directa
                    else:
                        n = buidInst({
                            "O":opcodes[i[0]],
                            "MEM_OPCODE": 0b000,
                            "DM": parseNum(operand)
                        })
                        appendParse16(parseBytes,parseHuman,i,n)
                elif (len(i) == 4 and i[1] == "[" and i[3] == "]"):
                    operand = i[2]

                    # es un registro indirecto [R0-R7]
                    if(operand[0] == "R"):
                        n = buidInst({
                            "O":opcodes[i[0]],
                            "MEM_OPCODE": 0b011,
                            "MEM_REG": reg2num(operand)
                        })
                        appendParse16(parseBytes,parseHuman,i,n)

                    # es memoria indirecta
                    else:
                        n = buidInst({
                            "O":opcodes[i[0]],
                            "MEM_OPCODE": 0b001,
                            "DM": parseNum(operand)
                        })
                        appendParse16(parseBytes,parseHuman,i,n)
                else:
                    raise ValueError("Error: Invalid instruction \"" + i[0] + "\"")
                    break



            # 
            # SET Rx, M
            # elif i[0] in type_RI:
            #     if i[2]==",":
            #         n = buidInst({"O":opcodes[i[0]], "X":reg2num(i[1]), "M":mem2num(i[3],labels)})
            #         appendParse16(parseBytes,parseHuman,i,n)
            #     else:
            #         raise ValueError("Error: Invalid instruction \"" + i[0] + "\"")
            #         break
                
            # DB M
            # elif i[0] in def_DB:
            #     parseHuman.append( [len(parseBytes),i] )
            #     parseBytes.append( mem2num(i[1],labels) )
                
            ##
            else:
                continue
                raise ValueError("Error: Unknown instruction \"" + i[0] + "\"")
                sys.exit(1)
                
        except ValueError as err:
            if len(err.args)>0:
                print(err.args[0])
            print("Error: Instruction: " +  " ".join(i))
            sys.exit(1)
            
    return parseBytes,parseHuman
    
def printCodeVerilog(output,parse,size):
    f = open(output,"w")
    for i in parse:
        if(size==1):
            f.write('%02x ' % (i >> 8) )
            f.write('%02x' % (i & 0xff) )
            f.write("\n")
        if(size==2):
            f.write('%04x ' % i )
            f.write("\n")
    if(size==1):
        for i in range(1024 - len(parse)):
            f.write('00 00\n')
    if(size==2):
        for i in range(512 - len(parse)):
            f.write('0000\n')
    f.close()

def printHuman(outputH,parseHuman,labels,filename):
    f = open(outputH,"w")
    
    inverseLabels = {}
    for name, addr in labels.items():
        if addr in inverseLabels:
            inverseLabels[addr].append(name)
        else:
            inverseLabels[addr] = [name]
            
    allNames = list(map(lambda x: ", ".join(x),  inverseLabels.values() ))
    if len(allNames)==0:
        maxName = 0
    else:
        maxName = max(map(len,allNames))
    
    for p in parseHuman:
        if p[0] in inverseLabels:
            f.write( (", ".join(inverseLabels[p[0]])).rjust(maxName) )
        else:
            f.write(" "*maxName)
        f.write(' |%02x| ' % p[0] )
        f.write(" ".join(p[1]) )
        f.write("\n")
    f.close()
