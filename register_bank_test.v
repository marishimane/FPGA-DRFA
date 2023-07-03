`define assert(signal, value) \
    if (signal !== value) begin \
        $display("ASSERTION FAILED in %m: signal != value"); \
        $finish; \
    end

module test;
  reg clk = 0, read_en = 0, write_en = 0;
  reg [7:0] in_data, out_bus_data, out_rx_data, out_ry_data;
  reg [2:0] in_rx_selector, in_ry_selector;

  register_bank registers(
    .clk(clk),
    .read_en(read_en),
    .write_en(write_en),
    .in_rx_selector(in_rx_selector),
    .in_ry_selector(in_ry_selector),
    .in_data(in_data),
    .out_bus_data(out_bus_data),
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
    in_rx_selector <= 3'b000;
    toggle_clk;
    `assert( out_rx_data, 8'b11111111 );

    in_ry_selector <= 3'b000;
    toggle_clk;
    `assert( out_ry_data, 8'b11111111 );

    toggle_clk;
    write_en <= 0;

    // Read from Ry selector in the bus
    `assert( out_bus_data, 8'bz );

    read_en <= 1;
    toggle_clk;
    // Ry selector points to R0
    `assert( out_bus_data, 8'b11111111 );
    read_en <= 0;
  end

  task toggle_clk;
    begin
      #10 clk = ~clk;
      #10 clk = ~clk;
    end
  endtask
endmodule