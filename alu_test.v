module test;
  localparam add = 3'b000;
  localparam sub = 3'b001;
  localparam or_ = 3'b010;
  localparam and_ = 3'b011;
  localparam not_ = 3'b100;
  localparam comp = 3'b101;
  localparam shr = 3'b110;
  localparam shl = 3'b111;

  reg [7:0] r_a, r_b, out;
  reg [2:0] op;
  reg [3:0] flags;
  reg clk = 0;

  alu ALU(
    .clk(clk),
    .in_A(r_a),
    .in_B(r_b),
    .out(out),
    .op(op),
    .flags(flags)
  );

  // add
  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1);

    op <= add;
    r_a <= 8'b00000011;
    r_b <= 8'b00010001;

    toggle_clk;
  end



  task toggle_clk;
    begin
      #10 clk = ~clk;
      #10 clk = ~clk;
    end
  endtask
endmodule