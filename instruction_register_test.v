`define assert(signal, value) \
    if (signal !== value) begin \
        $display("ASSERTION FAILED in %m: signal != value"); \
        $finish; \
    end

module test;
  reg clk = 0, ir_load = 0;
  reg [15:0] in_value, out_value;

  instruction_register instruction_register(
    .clk(clk),
    .ir_load(ir_load),
    .in_value(in_value),
    .out_value(out_value)
  );

  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1);

    // Load the IR
    in_value <= 16'hFDFD;
    ir_load = 1;
    toggle_clk;
    ir_load = 0;
    toggle_clk;
    `assert( out_value, 16'hFDFD );

    // Load de IR without enabling the write
    in_value <= 16'hFDFD;
    ir_load = 1;
    toggle_clk;
    ir_load = 0;
    in_value <= 16'hBABA;
    toggle_clk;
    `assert( out_value, 16'hFDFD );
  end

  task toggle_clk;
    begin
      #10 clk = ~clk;
      #10 clk = ~clk;
    end
  endtask
endmodule
