`define assert(signal, value) \
    if (signal !== value) begin \
        $display("ASSERTION FAILED in %m: signal != value"); \
        $finish; \
    end

module test;
  reg clk = 0;
  reg write_en = 0;
  reg [1:0] in_data;
  wire [1:0] out_data;

  memory_bank_selector memory_bank_selector(
    .clk(clk),
    .write_en(write_en),
    .in_data(in_data),
    .out_data(out_data)
  );

  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1);

    toggle_clk;
    in_data <= 2'b00;
    toggle_clk;

    write_en = 1;
    toggle_clk;
    `assert( out_data, 2'b00 );

    write_en = 0;
    toggle_clk;
    `assert( out_data, 2'b00 );

    in_data <= 2'b10;
    write_en = 1;
    toggle_clk;
    `assert( out_data, 2'b10 );
  end

  task toggle_clk;
    begin
      #10 clk = ~clk;
      #10 clk = ~clk;
    end
  endtask
endmodule
