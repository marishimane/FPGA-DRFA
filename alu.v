module alu ( clk, in_A, in_B, out, op, flags  ) ;
  input clk;
  input [7:0] in_A, in_B;
  input [2:0] op;
  
  output [7:0] out;
  output [3:0] flags;

  wire [8:0] r_a, r_b;
  reg [8:0] r_out;
  wire [2:0] op_w;
  wire fO , fN , fZ , fC;
  
  initial begin
	r_out <= 0 ;
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
    case ( op )
      add : begin r_out <= r_a + r_b; end
      sub : begin r_out <= r_a - r_b; end
      or_ : begin r_out <= r_a | r_b; end
      and_ : begin r_out <= r_a & r_b; end
      not_ : begin r_out <= !r_a; end
      comp : begin r_out <= r_a == r_b; end
      shr : begin r_out <= r_a >> 1; end
      shl : begin r_out <= r_a << 1; end
    endcase
  end

  assign fN = r_out[7];
  assign fZ = (r_out[7:0] == 8'h0)? 1 : 0;
  assign fC = ( op_w == add | op_w == sub )? r_out[8] : 0;
  assign fO = ( op_w == add | op_w == sub )? ((r_out[8:7] == 2'b01 || r_out[8:7] == 2'b10)? 1 : 0) : 0;
  assign flags = { fC, fN, fO, fZ };
  assign out = r_out[7:0];

endmodule

