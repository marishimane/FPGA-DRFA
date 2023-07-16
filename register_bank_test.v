`define assert(signal, value) \
    if (signal !== value) begin \
        $display("ASSERTION FAILED in %m: signal != value"); \
        $finish; \
    end

module test;
  reg clk = 0, read_en = 0, write_en = 0;
  reg [7:0] in_data;
  reg [2:0] in_rx_selector, in_ry_selector;
  reg in_indirect_mode_en = 0;
  
  wire [7:0] out_bus_data, out_rx_data, out_ry_data;

  register_bank registers(
    .clk(clk),
    .read_en(read_en),
    .write_en(write_en),
    .in_rx_selector(in_rx_selector),
    .in_ry_selector(in_ry_selector),
    .in_indirect_mode_en(in_indirect_mode_en),
    .in_data(in_data),
    .out_bus_data(bus_o),
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

    // write to R3
    write_en <= 1;
    in_data <= 8'b00000001;
    in_rx_selector <= 3'b011;
    toggle_clk;
    // read R3 from the bus
    write_en <= 0;
    read_en <= 1;
    in_ry_selector <= 3'b011;
    toggle_clk;
    `assert( out_bus_data, 8'b00000001 );
    read_en <= 0;


    // R0 <- 4
    write_en <= 1;
    read_en <= 0;
    in_data <= 8'b00000100;
    in_rx_selector <= 3'b000;
    toggle_clk;
    // R4 <- 8 
    write_en <= 1;
    read_en <= 0;
    in_data <= 8'b00001000;
    in_rx_selector <= 3'b100;
    toggle_clk;

    // without indirect mode
    write_en <= 0;
    read_en <= 1;
    in_indirect_mode_en <= 0;
    in_ry_selector <= 3'b000;
    toggle_clk;
    `assert( out_bus_data, 8'b00000100 );
    read_en <= 0;

    // with indirect mode
    write_en <= 0;
    read_en <= 1;
    in_indirect_mode_en <= 1;
    in_ry_selector <= 3'b000;
    toggle_clk;
    `assert( out_bus_data, 8'b00001000 );
    read_en <= 0;
  end

  task toggle_clk;
    begin
      #10 clk = ~clk;
      #10 clk = ~clk;
    end
  endtask
endmodule
