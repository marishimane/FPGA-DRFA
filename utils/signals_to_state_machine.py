#!/usr/bin/python3
import math

def flag_for_index(i):
    return 1 << i

signals = { 
    "alu_enable_out": flag_for_index(0),
    "pc_load": flag_for_index(1),
    "pc_inc": flag_for_index(2),
    "pc_enable_out": flag_for_index(3),
    "ir_enable_write": flag_for_index(4),
    "mbs_wr_enable": flag_for_index(5),
    "data_memory_read_enable": flag_for_index(6),
    "data_memory_wr_enable": flag_for_index(7),
    "reg_write_en": flag_for_index(8),
    "reg_read_en": flag_for_index(9),
    "reset_micro_pc": flag_for_index(10),
    "imm_en_out": flag_for_index(11),
    "data_memory_addr_wr_enable": flag_for_index(12),
    "decode": flag_for_index(13),
    "flags_en_out": flag_for_index(14),
    "push_stack": flag_for_index(15),
    "pop_stack": flag_for_index(16),
}

state_machine = [
    # Fetch
    ["pc_enable_out", "ir_enable_write"],

    # Decode
    ["decode"],

    # Execute
    #2  Op en la ALU
    ["alu_enable_out", "reg_write_en"],
    ["reset_micro_pc", "pc_inc"],

    # Copy reg
    ["reg_write_en", "reg_read_en"],
    ["reset_micro_pc", "pc_inc"],

    # Jumps
    ["pc_load"],
    ["reset_micro_pc"],

    # NotJump
    ["reset_micro_pc", "pc_inc"],

    #9 Get flags
    ["flags_en_out", "reg_write_en"],
    ["reset_micro_pc", "pc_inc"],

    #11 Select Mem Bank
    ["mbs_wr_enable"],
    ["reset_micro_pc", "pc_inc"],

    #13 Setr
    ["reg_write_en", "imm_en_out"],
    ["reset_micro_pc", "pc_inc"],

    #15 callSubrutine
    ["push_stack", "pc_enable_out"],
    ["pc_load"],
    ["reset_micro_pc"],

    #18 returnSubrutine
    ["pop_stack", "pc_load"],
    ["reset_micro_pc"],

    #20 readFromMemory
    ["imm_en_out", "data_memory_addr_wr_enable"],
    ["data_memory_read_enable", "reg_write_en"], #Usar R0
    ["reset_micro_pc", "pc_inc"],

    # Write to memory
    #23 Inmediato - write M => M <= R0
    ["imm_en_out", "data_memory_addr_wr_enable"],
    ["reg_read_en", "data_memory_wr_enable"], #Usar R0
    ["reset_micro_pc", "pc_inc"],

    #26 Indirecto a memoria - write [M] => [M] <= R0
    ["imm_en_out", "data_memory_addr_wr_enable"],
    ["data_memory_read_enable", "data_memory_addr_wr_enable"],
    ["reg_read_en", "data_memory_wr_enable"], #Usar R0
    ["reset_micro_pc", "pc_inc"],

    #30 Directo a registro - write Ry => [Ry] <= R0
    ["reg_read_en", "data_memory_addr_wr_enable"],
    ["reg_read_en", "data_memory_wr_enable"], #Usar R0
    ["reset_micro_pc", "pc_inc"],

    #33 Indirecto a registro - write [Ry] => [registros[Ry]] <= R0
    # Se resuelve con el bankRegister. Toma del IR que el direccionamiento es indirecto
    ["reg_read_en", "data_memory_addr_wr_enable"],
    ["reg_read_en", "data_memory_wr_enable"], #Usar R0
    ["reset_micro_pc", "pc_inc"],
]


def generate_memory_row(row):
    result = 0
    for signal in row:
        result = result | signals[signal]

    return result

def generate_state_machine(show_address):
    width = len(signals)
    f = '{0:0' + str(width) + 'b}'
    for i, row in enumerate(state_machine):
        instruction = f.format(generate_memory_row(row))
        if(show_address):
            print(i, end=" - ")
        print(instruction)

generate_state_machine(False)
amount_of_signals = len(signals)
amount_of_instr = len(state_machine)
bits_of_micro_pc = math.ceil(math.log(len(state_machine), 2))
print("reg [" + str(amount_of_signals-1) + ":0] mem [0:" + str(amount_of_instr-1) + "];")
print("reg [" + str(bits_of_micro_pc-1) + ":0] micro_pc;")
