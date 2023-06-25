module test;
  localparam add = 3'b000;
  localparam sub = 3'b001;
  localparam or_ = 3'b010;
  localparam and_ = 3'b011;
  localparam not_ = 3'b100;
  localparam comp = 3'b101;
  localparam shr = 3'b110;
  localparam shl = 3'b111;

  `define assert(signal, value, testname) \
    if (signal !== value) begin \
      $display("!!!!! ASSERTION FAILED in %s !!!!!", testname); \
      $finish; \
    end else begin \
      $display("# TEST PASSED: %s #", testname); \
    end

  reg [7:0] r_a, r_b, out;
  reg [2:0] op;
  reg [3:0] flags;
  wire fO , fN , fZ , fC;
  reg clk = 0;

  alu ALU(
    .clk(clk),
    .in_A(r_a),
    .in_B(r_b),
    .out(out),
    .op(op),
    .flags(flags)
  );

  assign fC = flags[3];
  assign fN = flags[2];
  assign fO = flags[1];
  assign fZ = flags[0];

  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1);

    $display("########## TESTING ADD OP ##########");
    op <= add;
    
    $display("-----adding two positive numbers(without overflow)-----");
    r_a <= 8'b00000011;
    r_b <= 8'b00010001;

    toggle_clk;

    `assert(out, 8'b00010100, "add numbers")
    `assert(fC, 0, "fC is 0")
    `assert(fN, 0, "fN is 0")
    `assert(fO, 0, "fO is 0")
    `assert(fZ, 0, "fZ is 0")

    $display("-----adding two positive numbers(with overflow)-----");
    r_a <= 8'b01000000;
    r_b <= 8'b01000001;

    toggle_clk;

    `assert(out, 8'b10000001, "add numbers")
    `assert(fC, 0, "fC is 0")
    `assert(fN, 1, "fN is 1")
    `assert(fO, 1, "fO is 1")
    `assert(fZ, 0, "fZ is 0")
    
    $display("-----adding two negative numbers-----");
    r_a <= 8'b10000100;
    r_b <= 8'b10000001;

    toggle_clk;

    `assert(out, 8'b00000101, "add numbers")
    `assert(fC, 1, "fC is 1")
    `assert(fN, 0, "fN is 0")
    `assert(fO, 1, "fO is 1")
    `assert(fZ, 0, "fZ is 0")
    
    $display("-----adding positive and negative numbers-----");
    r_a <= 8'b00100011;
    r_b <= 8'b10001001;

    toggle_clk;

    `assert(out, 8'b10101100, "add numbers")
    `assert(fC, 0, "fC is 0")
    `assert(fN, 1, "fN is 1")
    `assert(fO, 0, "fO is 0")
    `assert(fZ, 0, "fZ is 0")
    
    $display("-----adding positive and negative numbers getting zero-----");
    r_a <= 8'b01000000;
    r_b <= 8'b11000000;

    toggle_clk;

    `assert(out, 8'b00000000, "add numbers")
    `assert(fC, 1, "fC is 1")
    `assert(fN, 0, "fN is 0")
    `assert(fO, 0, "fO is 0")
    `assert(fZ, 1, "fZ is 1")
    
    $display("########## TESTING SUB OP ##########");
    op <= sub;
    
    $display("-----subtracting two positive numbers and getting a positive-----");
    r_a <= 8'b00010011;
    r_b <= 8'b00000011;

    toggle_clk;

    `assert(out, 8'b00010000, "sub numbers")
    `assert(fC, 0, "fC is 0")
    `assert(fN, 0, "fN is 0")
    `assert(fO, 0, "fO is 0")
    `assert(fZ, 0, "fZ is 0")

    $display("-----subtracting two positive numbers and getting a negative-----");
    r_a <= 8'b00000001;
    r_b <= 8'b00000010;

    toggle_clk;
	// aca no deberia haber carry!!
    `assert(out, 8'b11111111, "sub numbers")
    `assert(fC, 1, "fC is 1")
    `assert(fN, 1, "fN is 1")
    `assert(fO, 0, "fO is 0")
    `assert(fZ, 0, "fZ is 0")
    
    $display("-----subtracting two negative numbers and getting a negative-----");
    r_a <= 8'b10000001;
    r_b <= 8'b10000011;

    toggle_clk;
	// aca no deberia haber carry!!
    `assert(out, 8'b11111110, "sub numbers")
    `assert(fC, 1, "fC is 1")
    `assert(fN, 1, "fN is 1")
    `assert(fO, 0, "fO is 0")
    `assert(fZ, 0, "fZ is 0")
    
    $display("-----subtracting two negative numbers and getting a positive-----");
    r_a <= 8'b10000011;
    r_b <= 8'b10000001;

    toggle_clk;
	// aca si deberia haber carry!!
    `assert(out, 8'b00000010, "sub numbers")
    `assert(fC, 0, "fC is 0")
    `assert(fN, 0, "fN is 0")
    `assert(fO, 0, "fO is 0")
    `assert(fZ, 0, "fZ is 0")
    
    $display("-----subtracting numbers and getting zero-----");
    r_a <= 8'b10000001;
    r_b <= 8'b10000001;

    toggle_clk;

    `assert(out, 8'b00000000, "sub numbers")
    `assert(fC, 0, "fC is 0")
    `assert(fN, 0, "fN is 0")
    `assert(fO, 0, "fO is 0")
    `assert(fZ, 1, "fZ is 1")
    
    $display("-----subtracting negative from a positive and getting a positive-----");
    r_a <= 8'b00000011;
    r_b <= 8'b11111111;
	// aca no deberia haber carry!!
    toggle_clk;
    `assert(out, 8'b00000100, "sub numbers")
    `assert(fC, 1, "fC is 1")
    `assert(fN, 0, "fN is 0")
    `assert(fO, 0, "fO is 0")
    `assert(fZ, 0, "fZ is 0")
    
    $display("-----subtracting negative from a positive and getting a negative-----");
    r_a <= 8'b00000001;
    r_b <= 8'b10000000;
	// aca no deberia haber carry!!
    toggle_clk;
    `assert(out, 8'b10000001, "sub numbers")
    `assert(fC, 1, "fC is 1")
    `assert(fN, 1, "fN is 1")
    `assert(fO, 1, "fO is 1")
    `assert(fZ, 0, "fZ is 0")
    
    $display("-----subtracting positive from a negative and getting a negative-----");
    r_a <= 8'b11111111;
    r_b <= 8'b00000001;
	// aca si deberia haber carry!!
    toggle_clk;
    `assert(out, 8'b11111110, "sub numbers")
    `assert(fC, 0, "fC is 0")
    `assert(fN, 1, "fN is 1")
    `assert(fO, 0, "fO is 0")
    `assert(fZ, 0, "fZ is 0")
    
    $display("-----subtracting positive from a negative and getting a positive-----");
    r_a <= 8'b10000000;
    r_b <= 8'b00000001;
	// aca si deberia haber carry!!
    toggle_clk;
    `assert(out, 8'b01111111, "sub numbers")
    `assert(fC, 0, "fC is 0")
    `assert(fN, 0, "fN is 0")
    `assert(fO, 1, "fO is 1")
    `assert(fZ, 0, "fZ is 0")
    
    $display("########## TESTING OR OP ##########");
    op <= or_;
    
    r_a <= 8'b00000011;
    r_b <= 8'b00010001;

    toggle_clk;

    `assert(out, 8'b00010011, "a or b")
    
    $display("########## TESTING AND OP ##########");
    op <= and_;
    
    r_a <= 8'b01010011;
    r_b <= 8'b00010001;

    toggle_clk;

    `assert(out, 8'b00010001, "a and b")
    
    $display("########## TESTING NOT OP ##########");
    op <= not_;
    
    r_a <= 8'b01010011;

    toggle_clk;

    `assert(out, 8'b10101100, "not a")
    
    $display("########## TESTING COMP OP ##########");
    op <= comp;
    
    $display("----- a != b -----");
    r_a <= 8'b01010011;
    r_b <= 8'b01010010;

    toggle_clk;

    `assert(out, 8'b00000000, "comp a b")
    
    $display("----- a == b -----");
    r_a <= 8'b01010011;
    r_b <= 8'b01010011;

    toggle_clk;

    `assert(out, 8'b00000001, "comp a b")
    
    $display("########## TESTING SHIFT RIGHT OP ##########");
    op <= shr;

    r_a <= 8'b01010011;

    toggle_clk;

    `assert(out, 8'b00101001, "shr a")
    
    $display("########## TESTING SHIFT LEFT OP ##########");
    op <= shl;

    r_a <= 8'b01010011;

    toggle_clk;

    `assert(out, 8'b10100110, "shl a")
  end


  task toggle_clk;
    begin
      #10 clk = ~clk;
      #10 clk = ~clk;
    end
  endtask
endmodule