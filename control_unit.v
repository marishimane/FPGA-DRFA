`include "instruction_register.v"
`include "stack.v"
`include "program_counter.v"

module control_unit(
  clk,
  in_alu_flags, in_ir, out_alu_enable_out,
 
  // Values
  out_cu_out, out_ir, out_pc,

  // Control signals
  out_mbs_wr_enable, out_data_memory_read_enable, out_data_memory_wr_enable,
  out_data_memory_addr_wr_enable, out_reg_write_en, out_reg_read_en
);

  // control signals
  localparam alu_enable_out = 0;
  localparam pc_load = 1;
  localparam pc_inc = 2;
  localparam pc_enable_out = 3;
  localparam ir_enable_write = 4;
  localparam mbs_wr_enable = 5;
  localparam data_memory_read_enable = 6;
  localparam data_memory_wr_enable = 7;
  localparam data_memory_addr_wr_enable = 12;
  localparam reg_write_en = 8;
  localparam reg_read_en = 9;
  localparam reset_micro_pc = 10;
  localparam imm_en_out = 11;
  localparam decode = 13;
  localparam flags_en_out = 14;
  localparam push_stack = 15;
  localparam pop_stack = 16;

  // state machine addresses
  localparam ALU_EXECUTE = 2;
  localparam COPY_REG_EXECUTE = 4;
  localparam JUMP_EXECUTE = 6;
  localparam NOT_JUMP = 8;
  localparam GET_FLAGS_EXECUTE = 9;
  localparam SELECT_MEM_BANK_EXECUTE = 11;
  localparam SET_REG_EXECUTE = 13;
  localparam CALL_SUBRUTINE_EXECUTE = 15;
  localparam RETURN_SUBRUTINE_EXECUTE = 18;
  localparam READ_MEMORY_IMM_EXECUTE = 20;
  localparam WRITE_MEMORY_DIRECT_EXECUTE = 23;
  localparam WRITE_MEMORY_INDIRECT_EXECUTE = 26;
  localparam WRITE_MEMORY_DIRECT_REGISTER_EXECUTE = 30;
  localparam WRITE_MEMORY_INDIRECT_REGISTER_EXECUTE = 33;
  localparam READ_MEMORY_REGISTER_EXECUTE = 36;

  input clk;
  input [3:0] in_alu_flags;
  input [15:0] in_ir;

  output [10:0] out_ir;
  output [7:0] out_cu_out;
  output [8:0] out_pc;

  output out_alu_enable_out,
    out_mbs_wr_enable, out_data_memory_read_enable,
    out_data_memory_wr_enable, out_data_memory_addr_wr_enable, out_reg_write_en, out_reg_read_en;

  // State machine
  reg [16:0] mem [0:38];  // TODO: read from a file as variables
  reg [5:0] micro_pc;
  reg [3:0] flags;
  wire [15:0] internal_out_ir;
  wire [4:0] op_code = internal_out_ir[15:11];

  // Internal control signals
  wire cs_ir_enable_write = mem[micro_pc][ir_enable_write];
  wire cs_stack_push_en = mem[micro_pc][push_stack];
  wire cs_stack_pop_en = mem[micro_pc][pop_stack];
  wire cs_pc_load = mem[micro_pc][pc_load];
  wire cs_pc_inc = mem[micro_pc][pc_inc];
  wire cs_pc_en_out = mem[micro_pc][pc_enable_out];

  // Internal values 

  wire [8:0] PC_out;
  wire [8:0] stack_out_pc;
  wire [3:0] stack_out_flags;

  instruction_register IR(
    .clk(clk),
    .ir_load(cs_ir_enable_write),
    .in_value(in_ir),
    .out_value(internal_out_ir)
  );

  program_counter PC(
    .clk(clk),
    .pc_load(cs_pc_load),
    .pc_inc(cs_pc_inc),
    .pc_enOut(cs_pc_en_out),
    .in_value(
      (internal_out_ir[15:11] == 5'b10101) ? // Es un retSubrutine
        stack_out_pc :        // Sale del stack
        internal_out_ir[10:2] // Sale del inmediato del IR
    ),
    .out_value(PC_out)
  );

  stack stack(
    .clk(clk),
    .push_en(cs_stack_push_en),
    .pop_en(cs_stack_pop_en),
    .in_pc(PC_out),
    .in_flags(flags),
    .out_pc(stack_out_pc),
    .out_flags(stack_out_flags)
  );

  initial begin
      // load code
      $readmemb("state_machine.mem", mem);
      micro_pc <= 0;
      flags <= 0;
  end

  always @(posedge clk) begin
    // Pisar flags cuando se ejecuta una operacion de ALU
    if(mem[micro_pc][alu_enable_out] == 1'b1) begin
      flags <= in_alu_flags;
    end

    // Pisar flags si el stack hace pop
    if(mem[micro_pc][pop_stack] == 1'b1) begin
      flags <= stack_out_flags;
    end

    // Decode
    if(mem[micro_pc][decode] == 1'b1) begin
      // Operación de ALU
      if(op_code[4:2] == 3'b000 || op_code[4:2] == 3'b001) begin
        micro_pc <= ALU_EXECUTE;
      end
      // CopyRegister
      if(op_code == 5'b01000) begin
        micro_pc <= COPY_REG_EXECUTE;
      end

      // SetRegister
      if(op_code == 5'b01001) begin
        micro_pc <= SET_REG_EXECUTE;
      end
      // Saltos
      if(op_code[4:2] == 3'b100) begin
        if(op_code[1:0] == 2'b00) begin // Salto incondicional
          micro_pc <= JUMP_EXECUTE;
        end else begin
          if(op_code[1:0] == 2'b01) begin // Jmpeq
            micro_pc <= (flags[0] == 1'b1) ? JUMP_EXECUTE : NOT_JUMP;
          end
          if(op_code[1:0] == 2'b10) begin // Jmpneq
            micro_pc <= (flags[0] == 1'b0) ? JUMP_EXECUTE : NOT_JUMP;
          end
        end
      end

      // callSubrutine
      if(op_code == 5'b10100) begin
        micro_pc <= CALL_SUBRUTINE_EXECUTE;
      end

      // returnSubrutine
      if(op_code == 5'b10101) begin
        micro_pc <= RETURN_SUBRUTINE_EXECUTE;
      end

      // writeToMemory
      // Inmediato
      if(internal_out_ir[15:8] == 8'b11100_000 ) begin
        micro_pc <= WRITE_MEMORY_DIRECT_EXECUTE;
      end

      // Indirecto
      if(internal_out_ir[15:8] == 8'b11100_001 ) begin
        micro_pc <= WRITE_MEMORY_INDIRECT_EXECUTE;
      end

      // Registro
      if(internal_out_ir[15:8] == 8'b11100_010 ) begin
        micro_pc <= WRITE_MEMORY_DIRECT_REGISTER_EXECUTE;
      end

      // Indirecto a registro
      if(internal_out_ir[15:8] == 8'b11100_011 ) begin
        micro_pc <= WRITE_MEMORY_INDIRECT_REGISTER_EXECUTE;
      end

      // readFromMemory
      // Inmediato
      if(internal_out_ir[15:8] == 8'b11101_000 ) begin
        micro_pc <= READ_MEMORY_IMM_EXECUTE;
      end

      // Registro
      if(internal_out_ir[15:8] == 8'b11101_010 ) begin
        micro_pc <= READ_MEMORY_REGISTER_EXECUTE;
      end

      // getflags
      if(op_code == 5'b11000) begin
        micro_pc <= GET_FLAGS_EXECUTE;
      end

      // selectMemoryBank
      if(op_code == 5'b11001) begin
        micro_pc <= SELECT_MEM_BANK_EXECUTE;
      end
    end

    // Reset
    if(mem[micro_pc][decode] != 1'b1 && mem[micro_pc][reset_micro_pc] == 1'b1) begin
      micro_pc <= 0;
    end

    if(mem[micro_pc][decode] != 1'b1 && mem[micro_pc][reset_micro_pc] != 1'b1) begin
      micro_pc <= micro_pc + 1;
    end

  end

  assign out_alu_enable_out = mem[micro_pc][alu_enable_out];
  assign out_mbs_wr_enable = mem[micro_pc][mbs_wr_enable];
  assign out_data_memory_addr_wr_enable = mem[micro_pc][data_memory_addr_wr_enable];
  assign out_data_memory_read_enable = mem[micro_pc][data_memory_read_enable];
  assign out_data_memory_wr_enable = mem[micro_pc][data_memory_wr_enable];
  assign out_reg_write_en = mem[micro_pc][reg_write_en];
  assign out_reg_read_en = mem[micro_pc][reg_read_en];

  assign out_cu_out = (mem[micro_pc][flags_en_out]) ? {4'b0000, flags} :
                      mem[micro_pc][imm_en_out]     ? internal_out_ir[7:0] :
                      8'bz ;

  assign out_ir = internal_out_ir[15:5];

  assign out_pc = PC_out;
endmodule
