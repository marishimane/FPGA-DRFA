`define assert(signal, value, testname) \
  if (signal !== value) begin \
    $display("!!!!! ASSERTION FAILED in %s !!!!!", testname); \
    $finish; \
  end else begin \
    $display("# TEST PASSED: %s #", testname); \
  end

module control_unit_test;
  reg clk = 0;
  reg [8:0] in_addr;
  reg [15:0] out_data;

  wire [7:0] BUS;
  // Registers
  reg [7:0] REG_rx, REG_ry;
  reg [2:0] REG_rx_selector, REG_ry_selector;
  wire REG_write_en, REG_read_en;
  // ALU
  reg [7:0] ALU_out;
  reg [2:0] ALU_op;
  wire ALU_enable_out;
  reg [3:0] ALU_flags;
  // Memory Bank Selector (MBS)
  reg [1:0] MBS_input, MBS_output;
  wire MBS_wr_enable;
  
  // Data Memory
  wire [9:0] data_mem_address;
  assign data_mem_address = { MBS_output, BUS };
  wire data_memory_read_enable, data_memory_wr_enable, data_memory_addr_wr_enable;

  // Code Memory
  reg [15:0] in_ir;
  wire [15:0] out_ir;

  // PC
  reg PC_load, PC_inc, PC_enOut;
  reg [8:0] PC_in_value;
  wire [8:0] PC_out;
  // IR
  reg IR_load, IR_enOut;
  // Stack
  reg stack_push_en, stack_pop_en;
  reg [3:0] stack_flags;
  wire [3:0] out_flags;

  control_unit CONTROL_UNIT(
    .clk(clk),
    .in_alu_flags(ALU_flags),
    .in_ir(in_ir),
    .out_ir(out_ir),
    .out_flags(out_flags),
    .out_cu_out(BUS),
    .out_pc(PC_out),
    .out_alu_enable_out(ALU_enable_out),
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

    // TODO agregar asserts y testear
    // todas las operaciones de la alu
    // o solamente que arranque en

    // Op ALU
    // add 000, 001
    /* in_ir = 16'b0; */
    /* toggle_clk; */
    /* toggle_clk; */
    /* toggle_clk; */
    /* toggle_clk; */

    // // Copy register
    // in_ir = 16'b01000_010_001_00000;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // // Set register
    // in_ir = 16'b01001_011_11110000;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // // Jump incondicional
    // in_ir = 16'b10000_111110000_00;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // // Jmpeq
    // ALU_flags = 4'b0001;
    // in_ir = 16'b0;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // in_ir = 16'b10001_111110000_00;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // // Jmpneq
    // in_ir = 16'b10010_111110000_00;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // // getflags
    // ALU_flags = 4'b1001;
    // in_ir = 16'b0;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // in_ir = 16'b11000_100_00000000;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // // selectMemoryBank
    // in_ir = 16'b11001_10_000000000;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // // callSubrutine
    // ALU_flags = 4'b1001;
    // in_ir = 16'b0;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // in_ir = 16'b10100_111100001_00;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // // ReturnSubrutine
    // stack_flags = 4'b0101;
    // in_ir = 16'b10101_00000100000;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // readFromMemory
    // Inmediato
    // in_ir = 16'b11101_000_11110000;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // // Registro
    // in_ir = 16'b11101_010_11110000;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // // writeToMemory
    // // Directo a memoria
    // in_ir = 16'b11100_000_11110000;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // // Indirecto a memoria
    // in_ir = 16'b11100_001_11110000;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // // Directo a registro
    // in_ir = 16'b11100_010_11110000;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // // Indirecto a registro
    // in_ir = 16'b0;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;

    // in_ir = 16'b11100_011_11110000;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
    // toggle_clk;
  end


  task toggle_clk;
    begin
      #10 clk = ~clk;
      #10 clk = ~clk;
    end
  endtask
endmodule
