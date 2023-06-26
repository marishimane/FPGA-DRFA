module drf_system(
  clk, port_input, port_output
);

  input clk;
  input [3:0] port_input;
  output [3:0] port_output;

  wire [7:0] BUS;
  // Registers
  wire [7:0] REG_rx, REG_ry;
  wire [2:0] REG_rx_selector, REG_ry_selector;
  wire REG_write_en, REG_read_en;
  // ALU
  wire [7:0] ALU_out;
  wire [2:0] ALU_op;
  wire ALU_enable_out;
  wire [3:0] ALU_flags;
  // Memory Bank Selector (MBS)
  wire [1:0] MBS_input, MBS_output;
  wire MBS_wr_enable;
  // Data Memory
  wire [7:0] data_mem_address;
  assign data_mem_address = { MBS_output, BUS }
  wire data_memory_read_enable, data_memory_wr_enable;
  // Ports

  // Code Memory
  wire [15:0] code_memory_out;
  // PC
  wire PC_load, PC_inc, PC_enOut;
  wire [8:0] PC_out;
  // IR
  wire IR_load, IR_enOut;
  wire [15:0] IR_out;


  instruction_register IR(
    .clk(clk),
    .ir_load(IR_load),
    .ir_enOut(IR_enOut),
    .in_value(code_memory_out),
    .out_value(IR_out)
    // POR DEFINIR
    // .out_opcode(IR_opcode),
    // .out_rx(IR_rx_selector),
    // .out_ry(IR_ry_selector),
    // .out_code_address(IR_code_address),
    // .out_immediate(IR_immediate),
    // .out_bank_selector(MBS_input),
    // ...
  );

  program_counter PC(
    .clk(clk),
    .PC_load(PC_load),
    .PC_inc(PC_inc),
    .PC_enOut(PC_enOut),
    .in_value(IR_code_address),
    .out_value(PC_out)
  );

  code_memory code_memory(
    .clk(clk),
    .in_addr(PC_out),
    .out_data(code_memory_out)
  );

  memory_bank_selector memory_bank_selector(
    .write_en(MBS_wr_enable),
    .in_data(MBS_input),
    .out_data(MBS_output)
  );

  data_memory data_memory(
    .clk(clk),
    .in_addr(data_mem_address),
    .in_write_en(data_memory_wr_enable),
    .in_read_en(data_memory_read_enable),
    .in_data(BUS),
    .out_data(BUS)
  );

  io_ports ports(
    .clk(clk),
    .in_addr(data_mem_address),
    .in_write_en(data_memory_wr_enable),
    .in_read_en(data_memory_read_enable),
    .in_data(BUS),
    .out_data(BUS),
    .in_port(port_input),
    .out_port(port_output)
  );

  alu ALU(
    .clk(clk),
    .in_A(REG_rx),
    .in_B(REG_ry),
    .out(ALU_out),
    .op(ALU_op),
    .flags(ALU_flags),
    .in_enable_out(ALU_enable_out)
  );

  register_bank registers(
    .clk(clk),
    .read_en(REG_read_en),
    .write_en(REG_write_en),
    .in_rx_selector(REG_rx_selector),
    .in_ry_selector(REG_ry_selector),
    .in_data(BUS),
    .out_r0_data(BUS),
    .out_rx_data(REG_rx),
    .out_ry_data(REG_ry)
  );

  control_unit control_unit(
    // AJUSTAR CUANDO LA ARMEMOS
    .in_ALU_flags(ALU_flags),
    .in_IR(IR_out),
    .out_ALU_enable_out(ALU_enable_out)
    .out_PC_load(PC_load),
    .out_PC_inc(PC_inc),
    .out_PC_enable_out(PC_enOut),
    .out_IR_enable_read(IR_enable_read),
    .out_MBS_wr_enable(MBS_wr_enable),
    .out_data_memory_read_enable(data_memory_read_enable),
    .out_data_memory_wr_enable(data_memory_wr_enable),
    .out_REG_write_en(REG_write_en),
    .out_REG_read_en(REG_read_en)
  );

endmodule