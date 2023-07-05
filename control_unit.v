// control signals
localparam alu_enable_out = 0;
localparam pc_load = 1;
localparam pc_inc = 2;
localparam pc_enable_out = 3;
localparam ir_enable_read = 4;
localparam mbs_wr_enable = 5;
localparam data_memory_read_enable = 6;
localparam data_memory_wr_enable = 7;
localparam reg_write_en = 8;
localparam reg_read_en = 9;
localparam reset_micro_pc = 10;
localparam cu_out = 11;
localparam mem_addr_write_en = 12;
localparam decode = 13;
localparam flags_en_out = 14;

// state machine addresses
localparam ALU_EXECUTE = 2;
localparam COPY_REG_EXECUTE = 4;
localparam JUMP_EXECUTE = 6;
localparam NOT_JUMP = 8;
localparam GET_FLAGS_EXECUTE = 9;

module control_unit(
  clk,
  in_alu_flags, in_ir, out_alu_enable_out, out_pc_load,
  out_pc_inc, out_pc_enable_out, out_ir_enable_read,
  out_mbs_wr_enable, out_data_memory_read_enable, out_data_memory_wr_enable,
  out_data_memory_addr_wr_enable, out_reg_write_en, out_reg_read_en,
  out_reset_micro_pc, out_mem_addr_write_en, out_cu_out
);

  input clk;
  input [3:0] in_alu_flags;
  input [15:0] in_ir;

  output out_alu_enable_out, out_pc_load, out_pc_inc, out_pc_enable_out,
    out_ir_enable_read, out_mbs_wr_enable, out_data_memory_read_enable,
    out_data_memory_wr_enable, out_data_memory_addr_wr_enable, out_reg_write_en, out_reg_read_en,
    out_reset_micro_pc, out_mem_addr_write_en;
  output [7:0] out_cu_out;

  reg [14:0] mem [0:28];
  reg [23:0] micro_pc; // Arreglar luego. Son menos bits
  reg [3:0] flags;
  wire [4:0] op_code = in_ir[15:11];

  initial begin
      // load code
      $readmemb("state_machine.mem", mem);
      micro_pc <= 0;
      flags <= 0;
  end

  always @(posedge clk) begin
    $display(micro_pc);
    $display(mem[micro_pc]);

    // Pisar flags cuando se ejecuta una operacion de ALU
    if(mem[micro_pc][alu_enable_out] == 1'b1) begin
      flags <= in_alu_flags;
    end

    // Decode
    if(mem[micro_pc][decode] == 1'b1) begin
      // Operación de ALU
      if(op_code[4:2] == 3'b000 || op_code[4:2] == 3'b001) begin
        micro_pc <= ALU_EXECUTE;
      end
      // Operación de copia de registros
      if(op_code[4:0] == 5'b01000) begin
        micro_pc <= COPY_REG_EXECUTE;
      end
      // Saltos
      if(op_code[4:2] == 3'b100) begin
        if(op_code[1:0] == 2'b00) begin // Salto incondicional
          micro_pc <= JUMP_EXECUTE;
        end else begin
          if(op_code[1:0] == 2'b01) begin // Jmpeq
            micro_pc <= flags[0] == 1'b1 ? JUMP_EXECUTE : NOT_JUMP;
          end
          if(op_code[1:0] == 2'b10) begin // Jmpeq
            micro_pc <= flags[0] == 1'b0 ? JUMP_EXECUTE : NOT_JUMP;
          end
        end
      end

      // getflags
      if(op_code[4:0] == 5'b11000) begin
        micro_pc <= GET_FLAGS_EXECUTE;
      end
    end

    if(mem[micro_pc][decode] != 1'b1 && mem[micro_pc][reset_micro_pc] == 1'b1) begin
      micro_pc <= 0;
    end

    if(mem[micro_pc][decode] != 1'b1 && mem[micro_pc][reset_micro_pc] != 1'b1) begin
      micro_pc <= micro_pc + 1;
    end

  end

  assign out_alu_enable_out = mem[micro_pc][alu_enable_out];
  assign out_pc_load = mem[micro_pc][pc_load];
  assign out_pc_inc = mem[micro_pc][pc_inc];
  assign out_pc_enable_out = mem[micro_pc][pc_enable_out];
  assign out_ir_enable_read = mem[micro_pc][ir_enable_read];
  assign out_mbs_wr_enable = mem[micro_pc][mbs_wr_enable];
  assign out_data_memory_read_enable = mem[micro_pc][data_memory_read_enable];
  assign out_data_memory_wr_enable = mem[micro_pc][data_memory_wr_enable];
  assign out_reg_write_en = mem[micro_pc][reg_write_en];
  assign out_reg_read_en = mem[micro_pc][reg_read_en];
  assign out_reset_micro_pc = mem[micro_pc][reset_micro_pc];
  assign out_mem_addr_write_en = mem[micro_pc][mem_addr_write_en];

  assign out_cu_out = mem[micro_pc][flags_en_out] ? {4'b0000, flags} : 8'bz;


endmodule
