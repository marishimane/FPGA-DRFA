`define assert(signal, value) \
    if (signal !== value) begin \
        $display("ASSERTION FAILED in %m: signal != value"); \
        $finish; \
    end

module test;
  reg clk = 0, write_en = 0;
  reg [7:0] in_data, out_rx_data, out_ry_data;
  reg [2:0] in_rx_selector, in_ry_selector;

  register_bank registers(
    .clk(clk),
    .write_en(write_en),
    .in_rx_selector(in_rx_selector),
    .in_ry_selector(in_ry_selector),
    .in_data(in_data),
    .out_rx_data(out_rx_data),
    .out_ry_data(out_ry_data)
  );

  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1);

    // Write in Rx
    write_en <= 1;
    in_data <= 8'b10101010;
    in_rx_selector <= 3'b100;
    toggle_clk;
    `assert( out_rx_data, 8'b10101010 );

    in_data <= 8'b11111111;
    in_rx_selector <= 3'b001;
    toggle_clk;
    `assert( out_rx_data, 8'b11111111 );

    in_ry_selector <= 3'b001;
    `assert( out_ry_data, 8'b11111111 );

    toggle_clk;
  end

  task toggle_clk;
    begin
      #10 clk = ~clk;
      #10 clk = ~clk;
    end
  endtask
endmodule