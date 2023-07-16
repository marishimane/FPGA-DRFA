`define assert(signal, value) \
    if (signal !== value) begin \
        $display("ASSERTION FAILED in %m: signal != value"); \
        $finish; \
    end

module test;
  reg clk = 0, push_en = 0, pop_en = 0;

  reg [8:0] in_pc;
  reg [3:0] in_flags;

  wire [8:0] out_pc;
  wire [3:0] out_flags;

  stack stack(
    .clk(clk),
    .push_en(push_en),
    .pop_en(pop_en),
    .in_pc(in_pc),
    .in_flags(in_flags),
    .out_pc(out_pc),
    .out_flags(out_flags)
  );

  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1);

    // set in pc and flags and push when empty
    in_pc <= 9'b000000010;
    in_flags <= 4'b1100;
    push_en <= 1'b1;
    pop_en <= 1'b0;
    toggle_clk;

    `assert( out_pc, 9'b000000010 );
    `assert( out_flags, 4'b1100 );

    // push 4 more different addresses and flags
    // 2
    in_pc <= 9'b000000100;
    in_flags <= 4'b1101;
    push_en <= 1'b1;
    pop_en <= 1'b0;
    toggle_clk;

    `assert( out_pc, 9'b000000100 );
    `assert( out_flags, 4'b1101 );

    // 3
    in_pc <= 9'b000001000;
    in_flags <= 4'b1110;
    push_en <= 1'b1;
    pop_en <= 1'b0;
    toggle_clk;

    `assert( out_pc, 9'b000001000 );
    `assert( out_flags, 4'b1110 );

    // 4
    in_pc <= 9'b000010000;
    in_flags <= 4'b1111;
    push_en <= 1'b1;
    pop_en <= 1'b0;
    toggle_clk;

    `assert( out_pc, 9'b000010000 );
    `assert( out_flags, 4'b1111 );

    // 5
    in_pc <= 9'b111111111;
    in_flags <= 4'b0001;
    push_en <= 1'b1;
    pop_en <= 1'b0;
    toggle_clk;

    `assert( out_pc, 9'b111111111 );
    `assert( out_flags, 4'b0001 );

    // push another value and erase last place in stack
    // new 5
    in_pc <= 9'b001000000;
    in_flags <= 4'b0010;
    push_en <= 1'b1;
    pop_en <= 1'b0;
    toggle_clk;

    `assert( out_pc, 9'b001000000 );
    `assert( out_flags, 4'b0010 );

    // pop and verify that previous last
    // value were lost but not the previous 4
    // 4
    in_pc <= 9'bz;
    in_flags <= 4'bz;
    push_en <= 1'b0;
    pop_en <= 1'b1;
    toggle_clk;

    `assert( out_pc, 9'b000010000 );
    `assert( out_flags, 4'b1111 );

    // 3
    in_pc <= 9'bz;
    in_flags <= 4'bz;
    push_en <= 1'b0;
    pop_en <= 1'b1;
    toggle_clk;

    `assert( out_pc, 9'b000001000 );
    `assert( out_flags, 4'b1110 );

    // 2
    in_pc <= 9'bz;
    in_flags <= 4'bz;
    push_en <= 1'b0;
    pop_en <= 1'b1;
    toggle_clk;

    `assert( out_pc, 9'b000000100 );
    `assert( out_flags, 4'b1101 );

    // 1
    in_pc <= 9'bz;
    in_flags <= 4'bz;
    push_en <= 1'b0;
    pop_en <= 1'b1;
    toggle_clk;

    `assert( out_pc, 9'b000000010 );
    `assert( out_flags, 4'b1100 );

    // empty 
    in_pc <= 9'bz;
    in_flags <= 4'bz;
    push_en <= 1'b0;
    pop_en <= 1'b1;
    toggle_clk;
  end

  task toggle_clk;
    begin
      #10 clk = ~clk;
      #10 clk = ~clk;
    end
  endtask
endmodule
