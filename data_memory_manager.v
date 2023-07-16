`include "data_memory.v"
`include "io_ports.v"

module data_memory_manager(
    clk, in_write_en, in_read_en, in_addr_write_en, in_addr,
    in_data, in_port, out_data, out_port
);
  input clk, in_write_en, in_read_en, in_addr_write_en;
  input [9:0] in_addr;
  input [7:0] in_data;
  input [3:0] in_port;
  output [7:0] out_data;
  output [3:0] out_port;

  reg [9:0] address_register;

  always @(in_addr) begin
    if ( in_addr_write_en ) address_register <= in_addr;
  end

  // always @(posedge clk) begin
  //   $display("address_register: %b", address_register);
  //   $display("in_data: %b", in_data);
  //   $display("out_data: %b", out_data);
  //   $display("in_read_en: %b", in_read_en);
  //   $display("in_write_en: %b", in_write_en);
  //   $display("in_addr_write_en: %b", in_addr_write_en);
  // end

  data_memory data_memory(
    .clk(clk),
    .in_addr(address_register),
    .in_write_en(in_write_en),
    .in_read_en(in_read_en),
    .in_data(in_data),
    .out_data(out_data)
  );

  io_ports ports(
    .clk(clk),
    .in_write_en(in_write_en),
    .in_read_en(in_read_en),
    .in_data(in_data),
    .in_addr(address_register),
    .out_data(out_data),
    .in_port(in_port),
    .out_port(out_port)
  );
endmodule
