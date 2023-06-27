module io_ports(
  clk, in_write_en, in_read_en, in_addr,
  in_data, in_port, out_data, out_port
);

  input clk, in_write_en, in_read_en;
  input [3:0] in_port;
  input [9:0] in_addr;
  input [7:0] in_data;
  output [3:0] out_port;
  output [7:0] out_data;

  reg [3:0] input_register;
  reg [3:0] output_register;

  initial begin
    input_register <= 0;
    output_register <= 0;
  end

  localparam in_port_addr = 10'b1111111110;
  localparam out_port_addr = 10'b1111111111;

  always @(posedge clk) begin
    if ( in_addr == out_port_addr && in_write_en ) output_register <= in_data[3:0];

    input_register <= in_port;
  end

  assign out_data = (in_addr == in_port_addr && in_read_en)? { {4{input_register[3]}}, input_register[3:0] } : 'bz;
  assign out_port = output_register;
endmodule