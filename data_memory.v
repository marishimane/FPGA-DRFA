module data_memory(
    clk,
    in_addr, in_write_en,
    in_data, out_data, 
);
  input clk;

  input [9:0] in_addr;
  input in_write_en;
  input in_read_en;

  input [7:0] in_data;
  output [7:0] out_data;

  reg [7:0] mem [0:1023];

  initial begin
  end

  always @(posedge clk) begin
      if (in_write_en == 1'b1) mem[in_addr] <= in_data;
  end

  assign out_data = mem[in_addr];
endmodule
