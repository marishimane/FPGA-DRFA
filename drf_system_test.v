`define assert(signal, value) \
    if (signal !== value) begin \
        $display("ASSERTION FAILED in %m: signal != value"); \
        $finish; \
    end



module test;
  reg clk = 0;
  reg [3:0] port_input, port_output;

  wire [2:0] in_rx_selector;
  wire [2:0] in_ry_selector;
  wire reg_write_en;
  wire [7:0] reg_in_data;

  drf_system drf_system(
    .clk(clk),
    .port_input(port_input),
    .port_output(port_output)
  );

  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1);

    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
    toggle_clk;
  end

  task toggle_clk;
    begin
      #10 clk = ~clk;
      #10 clk = ~clk;
    end
  endtask
endmodule
