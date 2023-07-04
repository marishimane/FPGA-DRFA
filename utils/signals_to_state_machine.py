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
}

state_machine = [
    # Fetch
    ["pc_enable_out", "ir_enable_read", "pc_inc"],

    # Decode

    # Execute
    # Op en la ALU
    ["alu_enable_out", "reg_write_en"],
    ["reset_micro_pc"],

    # Jumps
    ["pc_load"],
    ["reset_micro_pc"],

    # Setr
    ["reg_write_en"],
    ["reset_micro_pc"],

    # Write to memory
    # Inmediato - write M => M <= R0
    ["cu_out", "mem_addr_write_en"],
    ["reg_read_en", "data_memory_wr_enable"],
    ["reset_micro_pc"],

    # Indirecto a memoria - write [M] => [M] <= R0
    ["cu_out", "mem_addr_write_en"],
    ["data_memory_read_enable", "mem_addr_write_en"],
    ["reg_read_en", "data_memory_wr_enable"],
    ["reset_micro_pc"],

    # Indirecto a memoria - write [M] => [M] <= R0
    # Directo a registro - write Ry => [Ry] <= R0
    ["reg_read_en", "mem_addr_write_en"],
    ["data_memory_read_enable", "mem_addr_write_en"],
    ["reg_read_en", "data_memory_wr_enable"],
    ["reset_micro_pc"],


    # Indirecto a registro - write [Ry] => [registros[Ry]] <= R0
    ["reg_read_en"],
    ["reg_read_en", "data_memory_wr_enable"],
    ["reg_read_en", "data_memory_wr_enable"],
    ["reset_micro_pc"],


    # call m

    # ret m

    # gflags
    ["cu_out", "reg_read_en"],
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
        instruction = f.format(generate_memory_row(row))  + "b"
        if(show_address):
            print(i, end=" - ")
        print(instruction)

generate_state_machine(False)
