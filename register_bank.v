module register_bank(
  clk, read_en, write_en, in_rx_selector, in_ry_selector,
  in_data, out_r0_data, out_rx_data, out_ry_data
);

  input clk, read_en, write_en;
  input [2:0] in_rx_selector, in_ry_selector;
  input [7:0] in_data;

  output [7:0] out_r0_data, out_rx_data, out_ry_data;

  reg [7:0] registers [0:7];

  initial begin
    registers[0] <= 0; registers[1] <= 0; registers[2] <= 0;
    registers[3] <= 0; registers[4] <= 0; registers[5] <= 0;
    registers[6] <= 0; registers[7] <= 0;
  end

  always @(posedge clk) begin
    if ( write_en ) begin
      // Only one register can be written at a time
      registers[in_rx_selector] <= in_data;
    end
  end

  assign out_r0_data = read_en? registers[0] : 'bz;
  assign out_rx_data = registers[in_rx_selector];
  assign out_ry_data = registers[in_ry_selector];
endmodule