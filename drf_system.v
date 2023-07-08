`include "alu.v"
`include "program_counter.v"
`include "code_memory.v"
`include "memory_bank_selector.v"
`include "data_memory_manager.v"
`include "register_bank.v"
`include "control_unit.v"
`include "stack.v"

module drf_system(
  clk, port_input, port_output
);

  input clk;
  input [3:0] port_input;
  output [3:0] port_output;

  wire [7:0] BUS;
  // Registers
  wire [7:0] REG_rx, REG_ry;
  wire REG_write_en, REG_read_en;
  // ALU
  wire [7:0] ALU_out;
  wire [2:0] ALU_op;
  wire ALU_enable_out;
  wire [3:0] ALU_flags;
  // Memory Bank Selector (MBS)
  wire [1:0] MBS_input = IR_out[10:9];
  wire [1:0] MBS_output;
  wire MBS_wr_enable;
  // Data Memory
  wire [9:0] data_mem_address;
  assign data_mem_address = { MBS_output, BUS };
  wire data_memory_read_enable, data_memory_wr_enable, data_memory_addr_wr_enable;
  // Code Memory
  wire [15:0] code_memory_out;
  // PC
  wire PC_load, PC_inc, PC_enOut;
  wire [8:0] PC_out;
  wire [15:0] IR_out;
  // Stack
  wire stack_push_en;
  wire stack_pop_en;
  wire [3:0] CU_out_flags;
  wire [8:0] stack_out_pc;
  wire [3:0] stack_out_flags;

  program_counter PC(
    .clk(clk),
    .pc_load(PC_load),
    .pc_inc(PC_inc),
    .pc_enOut(PC_enOut),
    .in_value(
      (IR_out[15:11] == 5'b10101) ? stack_out_pc : // Es un retSubrutine
      IR_out[10:2] // Sale del inmediato del IR
    ),
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

  data_memory_manager data_memory_manager(
    .clk(clk),
    .in_write_en(data_memory_wr_enable),
    .in_read_en(data_memory_read_enable),
    .in_addr_write_en(data_memory_addr_wr_enable),
    .in_data(BUS),
    .in_addr(data_mem_address),
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
    .in_rx_selector(IR_out[10:8]),
    .in_ry_selector(IR_out[7:5]),
    .in_data(BUS),
    .out_bus_data(BUS),
    .out_rx_data(REG_rx),
    .out_ry_data(REG_ry)
  );

  control_unit control_unit(
    // AJUSTAR CUANDO LA ARMEMOS
    .clk(clk),
    .in_alu_flags(ALU_flags),
    .in_ir(code_memory_out),
    .in_stack_flags(stack_out_flags),
    .out_ir(IR_out),
    .out_flags(CU_out_flags),
    .out_cu_out(BUS),
    .out_alu_enable_out(ALU_enable_out),
    .out_pc_load(PC_load),
    .out_pc_inc(PC_inc),
    .out_pc_enable_out(PC_enOut),
    .out_mbs_wr_enable(MBS_wr_enable),
    .out_data_memory_read_enable(data_memory_read_enable),
    .out_data_memory_wr_enable(data_memory_wr_enable),
    .out_data_memory_addr_wr_enable(data_memory_addr_wr_enable),
    .out_reg_write_en(REG_write_en),
    .out_reg_read_en(REG_read_en),
    .out_stack_push_en(stack_push_en),
    .out_stack_pop_en(stack_pop_en)
  );

  // TODO: chequear
  stack stack(
    .clk(clk),
    .push_en(stack_push_en),
    .pop_en(stack_pop_en),
    .in_pc(PC_out),
    .in_flags(CU_out_flags),
    .out_pc(stack_out_pc),
    .out_flags(stack_out_flags)
  );

endmodule
