module control_unit_test;
  reg clk = 0;
  reg [8:0] in_addr;
  reg [15:0] out_data;

  reg [7:0] BUS;
  // Registers
  reg [7:0] REG_rx, REG_ry;
  reg [2:0] REG_rx_selector, REG_ry_selector;
  reg REG_write_en, REG_read_en;
  // ALU
  reg [7:0] ALU_out;
  reg [2:0] ALU_op;
  reg ALU_enable_out;
  reg [3:0] ALU_flags;
  // Memory Bank Selector (MBS)
  reg [1:0] MBS_input, MBS_output;
  reg MBS_wr_enable;
  // Data Memory
  reg [9:0] data_mem_address;
  assign data_mem_address = { MBS_output, BUS };
  reg data_memory_read_enable, data_memory_wr_enable, data_memory_addr_wr_enable;
  // Code Memory
  reg [15:0] code_memory_out;
  // PC
  reg PC_load, PC_inc, PC_enOut;
  reg [8:0] PC_out, PC_in_value;
  // IR
  reg IR_load, IR_enOut;
  reg [15:0] IR_out;

  control_unit CONTROL_UNIT(
    .in_alu_flags(ALU_flags),
    .in_ir(IR_out),
    .out_alu_enable_out(ALU_enable_out),
    .out_pc_load(PC_load),
    .out_pc_inc(PC_inc),
    .out_pc_enable_out(PC_enOut),
    .out_ir_enable_read(IR_enOut),
    .out_mbs_wr_enable(MBS_wr_enable),
    .out_data_memory_read_enable(data_memory_read_enable),
    .out_data_memory_wr_enable(data_memory_wr_enable),
    .out_data_memory_addr_wr_enable(data_memory_addr_wr_enable),
    .out_reg_write_en(REG_write_en),
    .out_reg_read_en(REG_read_en)
  );

  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1);

    toggle_clk;
  end


  task toggle_clk;
    begin
      #10 clk = ~clk;
      #10 clk = ~clk;
    end
  endtask
endmodule
