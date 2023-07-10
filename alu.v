module alu (
  clk, in_A, in_B, out, op, flags, in_enable_out
) ;
  input clk, in_enable_out;
  input [7:0] in_A, in_B;
  input [2:0] op;

  output [7:0] out;
  output [3:0] flags;

  wire [8:0] r_a, r_b;
  wire [8:0] r_out;
  wire [2:0] op_w;
  wire fO , fN , fZ , fC;

  initial begin
  end

  assign r_a = { 1'b0, in_A };
  assign r_b = { 1'b0, in_B };
  assign op_w = op;

  localparam add = 3'b000;
  localparam sub = 3'b001;
  localparam or_ = 3'b010;
  localparam and_ = 3'b011;
  localparam not_ = 3'b100;
  localparam comp = 3'b101;
  localparam shr = 3'b110;
  localparam shl = 3'b111;

  always @(posedge clk) begin
    $display("alu_out: ", out);
    $display("alu r_a: ", r_a);
    $display("alu_r_b: ", r_b);
    $display("op: ", op);
  end

  assign r_out =
    (op == add) ? r_a + r_b : (
    (op == sub) ? r_a - r_b : (
    (op == or_) ? r_a | r_b : (
    (op == and_) ? r_a & r_b : (
    (op == not_) ? ~r_a : (
    (op == comp) ? r_a == r_b : (
    (op == shr) ? r_a >> 1 : (
    (op == shl) ? r_a << 1 : 'bz )))))));

  assign fN = r_out[7];
  assign fZ = (r_out[7:0] == 8'h0)? 1 : 0;
  assign fC = ( op_w == add | op_w == sub )? r_out[8] : 0;
  assign fO = ( op_w == add )? ((r_a[7] == 0 && r_b[7] == 0 && r_out[7] == 1) | (r_a[7] == 1 && r_b[7] == 1 && r_out[7] == 0)? 1 : 0) : ( op_w == sub )? (r_a[7] == 0 && r_b[7] == 1 && r_out[7] == 1) | (r_a[7] == 1 && r_b[7] == 0 && r_out[7] == 0) : 0;
  assign flags = { fC, fN, fO, fZ };
  assign out = in_enable_out? r_out[7:0] : 'bz;
endmodule
