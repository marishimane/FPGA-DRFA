`define assert(signal, value) \
    if (signal !== value) begin \
        $display("ASSERTION FAILED in %m: signal != value"); \
        $finish; \
    end

localparam INPUT_PORT = 10'b1111111110;
localparam OUTPUT_PORT = 10'b1111111111;

module test;
  reg clk = 0, in_write_en = 0, in_read_en = 0;
  reg [3:0] in_data, out_data, in_port, out_port;
  reg [9:0] in_addr;

  io_ports ports(
    .clk(clk),
    .in_write_en(in_write_en),
    .in_read_en(in_read_en),
    .in_data(in_data),
    .in_addr(in_addr),
    .out_data(out_data),
    .in_port(in_port),
    .out_port(out_port)
  );

  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1);

    // Write to Input Port and read that value in the bus
    in_read_en <= 1;
    in_port <= 4'b1100;
    // with the incorrect port address
    in_addr <= 8'b01010101;
    toggle_clk;
    `assert( out_data, 4'bz );
    toggle_clk;

    // with the correct port address
    in_addr <= INPUT_PORT;
    toggle_clk;
    `assert( out_data, 4'b1100 );
    toggle_clk;
    in_port <= 4'b0001;
    `assert( out_data, 4'b1100 );
    toggle_clk;
    `assert( out_data, 4'b0001 );
    toggle_clk;

    // Write from bus to port and read from port
    in_read_en <= 0;
    in_write_en <= 1;
    in_data <= 4'b1100;
    // with the incorrect port address
    in_addr <= 8'b01010101;
    toggle_clk;
    `assert( out_port, 4'b0000 );

    // with the correct port address
    in_addr <= OUTPUT_PORT;
    toggle_clk;
    `assert( out_port, 4'b1100 );
  end

  task toggle_clk;
    begin
      #10 clk = ~clk;
      #10 clk = ~clk;
    end
  endtask
endmodule