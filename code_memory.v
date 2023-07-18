// Code gets loaded at synth time
module code_memory(
    in_addr, out_data
);
  input [8:0] in_addr;

  output [15:0] out_data;

  reg [15:0] mem [0:511];

  initial begin
      // load code
      $readmemh("code_memory_example.mem", mem);
  end

  assign out_data = mem[in_addr];
endmodule

