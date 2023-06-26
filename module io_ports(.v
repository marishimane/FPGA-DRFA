module io_ports(
  clk, write_en, read_en,
  in_data, out_data, in_port, out_port
);

  input clk, write_en, read_en;
  input [3:0] in_data, in_port;
  output [3:0] out_data, out_port;

  reg [3:0] input_register;
  reg [3:0] output_register;

  initial begin
    input_register <= 0;
    output_register <= 0;
  end

  always @(posedge clk) begin
    if ( write_en ) begin
      output_register <= in_data;
    end

    input_register <= in_port;
  end

  assign out_data = read_en? input_register : 'bz;
  assign out_port = output_register;
endmodule