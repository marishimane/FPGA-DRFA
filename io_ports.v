module io_ports(
  clk, write_en, read_en,
  in_data, in_port, in_addr, out_data, out_port
);

  input clk, write_en, read_en;
  input [3:0] in_data, in_port;
  input [10:0] in_addr;
  output [3:0] out_data, out_port;

  reg [3:0] input_register;
  reg [3:0] output_register;

  initial begin
    input_register <= 0;
    output_register <= 0;
  end

  localparam in_port_addr = 8'b1111111110;
  localparam out_port_addr = 8'b1111111111;

  always @(posedge clk) begin
    if ( in_addr == out_port_addr && write_en ) output_register <= in_data;
    if ( in_addr == in_port_addr ) input_register <= in_port;
  end

  assign out_data = ( in_addr == in_port_addr && read_en)? input_register : 'bz;
  assign out_port = output_register;
endmodule