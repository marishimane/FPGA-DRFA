module register_bank(
  clk, in_selector, in_data,
  write_en, read_en, out_data
);
  input clk, write_en, read_en;
  input [2:0] in_selector;
  input [7:0] in_data;

  output [7:0] out_data;

  reg [7:0] registers [0:7];

  initial begin
    registers[0] <= 0; registers[1] <= 0; registers[2] <= 0;
    registers[3] <= 0; registers[4] <= 0; registers[5] <= 0;
    registers[6] <= 0; registers[7] <= 0;
  end

  always @(posedge clk) begin
    if ( write_en ) begin
      registers[ in_selector ] <= in_data;
    end
  end

  assign out_data = read_en? registers[ in_selector ] : 'bz;
endmodule