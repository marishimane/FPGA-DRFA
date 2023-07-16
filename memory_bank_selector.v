module memory_bank_selector(
  clk, write_en, in_data, out_data
);
  input clk;
  input write_en;
  input [1:0] in_data;
  output [1:0] out_data;

  reg [1:0] memory_bank;

  always @(posedge clk) begin
    if(write_en) begin
      memory_bank <= in_data;
    end
  end
  
  assign out_data = memory_bank;
endmodule
