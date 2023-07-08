#!/usr/bin/python3

def flag_for_index(i):
    return 1 << i

signals = { 
   "alu_enable_out": flag_for_index(0),
   "pc_load": flag_for_index(1),
   "pc_inc": flag_for_index(2),
   "pc_enable_out": flag_for_index(3),
   "ir_enable_read": flag_for_index(4),
   "mbs_wr_enable": flag_for_index(5),
   "data_memory_read_enable": flag_for_index(6),
   "data_memory_wr_enable": flag_for_index(7),
   "reg_write_en": flag_for_index(8),
   "reg_read_en": flag_for_index(9),
   "reset_micro_pc": flag_for_index(10),
   "cu_out": flag_for_index(11),
   "mem_addr_write_en": flag_for_index(12),
   "decode": flag_for_index(13),
   "flags_en_out": flag_for_index(14),
   "imm_en_out": flag_for_index(15),
   "push_stack": flag_for_index(16),
   "pop_stack": flag_for_index(17),

}

state_machine = [
    # Fetch
    ["pc_enable_out", "ir_enable_read"],

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

    # Write to memory
    # Inmediato - write M => M <= R0
    ["cu_out", "mem_addr_write_en"],
    ["reg_read_en", "data_memory_wr_enable"],
    ["reset_micro_pc", "pc_inc"],

    # Indirecto a memoria - write [M] => [M] <= R0
    ["cu_out", "mem_addr_write_en"],
    ["data_memory_read_enable", "mem_addr_write_en"],
    ["reg_read_en", "data_memory_wr_enable"],
    ["reset_micro_pc", "pc_inc"],

    # Indirecto a memoria - write [M] => [M] <= R0
    # Directo a registro - write Ry => [Ry] <= R0
    ["reg_read_en", "mem_addr_write_en"],
    ["data_memory_read_enable", "mem_addr_write_en"],
    ["reg_read_en", "data_memory_wr_enable"],
    ["reset_micro_pc", "pc_inc"],


    # Indirecto a registro - write [Ry] => [registros[Ry]] <= R0
    ["reg_read_en"],
    ["reg_read_en", "data_memory_wr_enable"],
    ["reg_read_en", "data_memory_wr_enable"],
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
print(len(signals))
print(len(state_machine))
