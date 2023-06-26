module instruction_register(
  clk, ir_load, ir_enOut,
  in_value, out_value,
);

  input clk, ir_load, ir_enOut;
  input [15:0] in_value;
  output [15:0] out_value;

  reg [15:0] ir;

  initial begin
    ir <= 'b0;
  end

  always @( posedge clk ) begin
    if ( ir_load ) ir <= in_value;
  end

  assign out_value = ir_enOut? ir : 'bz;
endmodule