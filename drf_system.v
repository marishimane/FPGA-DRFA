/*
          DRF  System
           .--._.--.
          ( O     O )
          /   . .   \
         .`._______.'.
        /(           )\
      _/  \  \   /  /  \_
   .~   `  \  \ /  /  '   ~.
  {    -.   \  V  /   .-    }
_ _`.    \  |  |  |  /    .'_ _
>_       _} |  |  | {_       _<
 /. - ~ ,_-'  .^.  `-_, ~ - .\
         '-'|/   \|`-`
*/



`include "alu.v"
`include "code_memory.v"
`include "memory_bank_selector.v"
`include "data_memory_manager.v"
`include "register_bank.v"
`include "control_unit.v"

module drf_system(
  clk, port_input, port_output
);

  input clk;
  input [3:0] port_input;
  output [3:0] port_output;

  wire [7:0] BUS = 'bz;
  // PC
  wire [10:0] IR_reduced;

  // Registers
  wire [7:0] REG_rx, REG_ry;
  wire REG_write_en, REG_read_en;
  // ALU
  wire [2:0] ALU_op = IR_reduced[8:6];
  wire ALU_enable_out;
  wire [3:0] ALU_flags;
  // Memory Bank Selector (MBS)
  wire [1:0] MBS_input = IR_reduced[5:4];
  wire [1:0] MBS_output;
  wire MBS_wr_enable;
  // Data Memory
  wire [9:0] data_mem_address;
  assign data_mem_address = { MBS_output, BUS };
  wire data_memory_read_enable, data_memory_wr_enable, data_memory_addr_wr_enable;
  // Code Memory
  wire [15:0] code_memory_out;
  wire [8:0] code_memory_addr_in;

  code_memory code_memory(
    .in_addr(code_memory_addr_in),
    .out_data(code_memory_out)
  );

  memory_bank_selector memory_bank_selector(
    .clk(clk),
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
    .out(BUS),
    .op(ALU_op),
    .flags(ALU_flags),
    .in_enable_out(ALU_enable_out)
  );

  register_bank registers(
    .clk(clk),
    .read_en(REG_read_en),
    .write_en(REG_write_en),
    .in_rx_selector(
      // IR_reduced[10:8]
      (IR_reduced[10:6] == 5'b11101)?  // readm?
        3'b000 :                    // escribo en el registro 0
        IR_reduced[5:3]                // escribo en el registro indicado
    ),
    .in_ry_selector( // TODO: Revisar si esto anda para el writem
      (IR_reduced[10:6] == 5'b11100)?  // writem?
          ((IR_reduced[5:3] == 3'b010 && data_memory_addr_wr_enable == 1)? // writem Ry y además se está escribiendo la address
              IR_reduced[2:0] :             // El Ry de la instrucción
              3'b000                    // leo el registro 0
          ) :
          IR_reduced[2:0]                 // El Ry de la instrucción
    ),
    .in_indirect_mode_en((IR_reduced[10:3] == 8'b11100_011)? 1'b1 : 1'b0),
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
    .out_ir(IR_reduced),
    .out_cu_out(BUS),
    .out_pc(code_memory_addr_in),
    .out_alu_enable_out(ALU_enable_out),
    .out_mbs_wr_enable(MBS_wr_enable),
    .out_data_memory_read_enable(data_memory_read_enable),
    .out_data_memory_wr_enable(data_memory_wr_enable),
    .out_data_memory_addr_wr_enable(data_memory_addr_wr_enable),
    .out_reg_write_en(REG_write_en),
    .out_reg_read_en(REG_read_en)
  );

endmodule
