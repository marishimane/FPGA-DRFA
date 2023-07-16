`define assert(signal, value) \
    if (signal !== value) begin \
        $display("ASSERTION FAILED in %m: signal != value"); \
        $finish; \
    end

module test;
  reg clk = 0, pc_load = 0, pc_inc = 0, pc_enOut = 0;
  reg [8:0] in_value;
  
  wire [8:0] out_value;

  program_counter program_counter(
    .clk(clk),
    .pc_load(pc_load),
    .pc_inc(pc_inc),
    .pc_enOut(pc_enOut),
    .in_value(in_value),
    .out_value(out_value)
  );

  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1);

    pc_enOut = 1;

    // Load the PC
    in_value <= 9'b111001100;
    pc_load = 1;
    toggle_clk;
    pc_load = 0;
    toggle_clk;
    `assert( out_value, 9'b111001100 );

    // Increment the PC
    pc_inc = 1;
    toggle_clk;
    pc_inc = 0;
    toggle_clk;
    `assert( out_value, 9'b111001101 );
  end

  task toggle_clk;
    begin
      #10 clk = ~clk;
      #10 clk = ~clk;
    end
  endtask
endmodule