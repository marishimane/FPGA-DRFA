// Code gets loaded at synth time
module code_memory(
    clk, in_addr, out_data,
);
  input clk;

  input [8:0] in_addr;

  output [15:0] out_data;

  reg [15:0] mem [0:511];
  reg [15:0] read_data;

  initial begin
      // load code
      $readmemh("code_memory_example.mem", mem);
  end

  always @(posedge clk) begin
      read_data <= mem[in_addr];
  end

  assign out_data = mem[in_addr];
endmodule

