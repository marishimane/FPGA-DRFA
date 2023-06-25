module program_counter(
  clk, pc_load, pc_inc, pc_enOut,
  in_value, out_value,
);

  input clk, pc_load, pc_inc, pc_enOut;
  input [8:0] in_value;
  output [8:0] out_value;

  reg [8:0] pc;

  initial begin
    pc <= 'b0;
  end

  always @( posedge clk ) begin
    if ( pc_inc ) pc <= pc + 1;
    if ( pc_load ) pc <= in_value;
  end

  assign out_value = pc_enOut? pc : 'bz;
endmodule
