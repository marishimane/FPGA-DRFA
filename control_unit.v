// control signals
localparam out_alu_enable_out = 0;
localparam out_pc_load = 1;
localparam out_pc_inc = 2;
localparam out_pc_enable_out = 3;
localparam out_ir_enable_read = 4;
localparam out_mbs_wr_enable = 5;
localparam out_data_memory_read_enable = 6;
localparam out_data_memory_wr_enable = 7;
localparam out_reg_write_en = 8;
localparam out_reg_read_en = 9;
localparam out_reset_micro_pc = 10;
localparam out_cu_out = 11;
localparam out_mem_addr_write_en = 12;
localparam out_decode = 13; //TODO: RENOMBRAR TODOS Y USARLOS

// state machine addresses
localparam ALU_EXECUTE = 2;
localparam COPY_REG_EXECUTE = 4;

module control_unit(
  clk,
  in_alu_flags, in_ir, out_alu_enable_out, out_pc_load,
  out_pc_inc, out_pc_enable_out, out_ir_enable_read,
  out_mbs_wr_enable, out_data_memory_read_enable, out_data_memory_wr_enable,
  out_data_memory_addr_wr_enable, out_reg_write_en, out_reg_read_en,
  out_reset_micro_pc, out_cu_out, out_mem_addr_write_en, out_decode
);

  input clk;
  input [3:0] in_alu_flags;
  input [15:0] in_ir;

  output out_alu_enable_out, out_pc_load, out_pc_inc, out_pc_enable_out,
    out_ir_enable_read, out_mbs_wr_enable, out_data_memory_read_enable,
    out_data_memory_wr_enable, out_data_memory_addr_wr_enable, out_reg_write_en, out_reg_read_en,
    out_reset_micro_pc, out_cu_out, out_mem_addr_write_en, out_decode;

  reg [13:0] mem [0:23];
  reg [23:0] micro_pc;
  wire [4:0] op_code = in_ir[15:11];

  initial begin
      // load code
      $readmemb("state_machine.mem", mem);
      micro_pc <= 0;
  end

  always @(posedge clk) begin
    $display(micro_pc);
    $display(mem[micro_pc]);
    if(mem[micro_pc][13] == 1'b1) begin
      if(op_code[4:2] == 3'b000 || op_code[4:2] == 3'b001) begin
        micro_pc <= ALU_EXECUTE;
      end
      if(op_code[4:0] == 5'b01000) begin
        micro_pc <= COPY_REG_EXECUTE;
      end
    end
    if(mem[micro_pc][13] != 1'b1 && mem[micro_pc][10] == 1'b1) begin
      micro_pc <= 0;
    end
    if(mem[micro_pc][13] != 1'b1 && mem[micro_pc][10] != 1'b1) begin
      micro_pc <= micro_pc + 1;
    end
  end

  assign out_alu_enable_out = mem[micro_pc][0];
  assign out_pc_load = mem[micro_pc][1];
  assign out_pc_inc = mem[micro_pc][2];
  assign out_pc_enable_out = mem[micro_pc][3];
  assign out_ir_enable_read = mem[micro_pc][4];
  assign out_mbs_wr_enable = mem[micro_pc][5];
  assign out_data_memory_read_enable = mem[micro_pc][6];
  assign out_data_memory_wr_enable = mem[micro_pc][7];
  assign out_reg_write_en = mem[micro_pc][8];
  assign out_reg_read_en = mem[micro_pc][9];
  assign out_reset_micro_pc = mem[micro_pc][10];
  assign out_cu_out = mem[micro_pc][11];
  assign out_mem_addr_write_en = mem[micro_pc][12];
  assign out_decode = mem[micro_pc][13];
endmodule
