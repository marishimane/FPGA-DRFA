`include "data_memory.v"
`include "io_ports.v"

module data_memory_manager(
    clk, in_write_en, in_read_en, in_addr_write_en, in_addr,
    in_data, in_port, out_data, out_port
);
  localparam in_port_addr = 10'b1111111110;
  localparam out_port_addr = 10'b1111111111;

  input clk, in_write_en, in_read_en, in_addr_write_en;
  input [9:0] in_addr;
  input [7:0] in_data;
  input [3:0] in_port;
  output [7:0] out_data;
  output [3:0] out_port;

  reg [9:0] address_register;
  wire [7:0] out_d = 'bz;

  always @(posedge clk) begin
    if ( in_addr_write_en ) begin
      address_register <= in_addr;
    end
  end

  data_memory data_memory(
    .clk(clk),
    .in_addr(address_register),
    .in_write_en(in_write_en),
    .in_read_en(in_read_en),
    .in_data(in_data),
    .out_data(out_d)
  );

  io_ports ports(
    .clk(clk),
    .in_write_en(in_write_en),
    .in_read_en(in_read_en),
    .in_data(in_data[3:0]),
    .in_addr(address_register),
    .out_data(out_d),
    .in_port(in_port),
    .out_port(out_port)
  );

  assign out_data = out_d;
endmodule
