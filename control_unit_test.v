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
  // Stack
  reg stack_push_en, stack_pop_en;
  reg [3:0] stack_flags, out_flags;

  control_unit CONTROL_UNIT(
    .clk(clk),
    .in_alu_flags(ALU_flags),
    .in_ir(IR_out),
    .in_stack_flags(stack_flags),
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
    .out_reg_read_en(REG_read_en),
    .out_cu_out(BUS),
    .out_stack_push_en(stack_push_en),
    .out_stack_pop_en(stack_pop_en),
    .out_flags(out_flags)
  );

  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1);

    // TODO agregar asserts y testear
    // todas las operaciones de la alu
    // o solamente que arranque en

    // Op ALU
    // add 000, 001
    // IR_out = 16'b0;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // // Copy register
    // IR_out = 16'b01000_010_001_00000;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // // Set register
    // IR_out = 16'b01001_011_11110000;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // // Jump incondicional
    // IR_out = 16'b10000_111110000_00;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // // Jmpeq
    // ALU_flags = 4'b0001;
    // IR_out = 16'b0;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // IR_out = 16'b10001_111110000_00;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // // Jmpneq
    // IR_out = 16'b10010_111110000_00;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // // getflags
    // ALU_flags = 4'b1001;
    // IR_out = 16'b0;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // IR_out = 16'b11000_100_00000000;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // // selectMemoryBank
    // IR_out = 16'b11001_10_000000000;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // // callSubrutine
    // ALU_flags = 4'b1001;
    // IR_out = 16'b0;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // IR_out = 16'b10100_111100001_00;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // // ReturnSubrutine
    // stack_flags = 4'b0101;
    // IR_out = 16'b10101_00000100000;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // // readFromMemory
    // IR_out = 16'b11101_101_11110000;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // writeToMemory
    // // Directo a memoria
    // IR_out = 16'b11100_000_11110000;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // // Indirecto a memoria
    // IR_out = 16'b11100_001_11110000;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // // Directo a registro
    // IR_out = 16'b11100_010_11110000;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // Indirecto a registro
    IR_out = 16'b11100_011_11110000;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
  end


  task toggle_clk;
    begin
      #10 clk = ~clk;
      #10 clk = ~clk;
    end
  endtask
endmodule
