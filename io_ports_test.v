`define assert(signal, value) \
    if (signal !== value) begin \
        $display("ASSERTION FAILED in %m: signal != value"); \
        $finish; \
    end

module test;
  reg clk = 0, write_en = 0, read_en = 0;
  reg [3:0] in_data, out_data, in_port, out_port;
  reg [10:0] in_addr;

  io_ports ports(
    .clk(clk),
    .write_en(write_en),
    .read_en(read_en),
    .in_data(in_data),
    .out_data(out_data),
    .in_port(in_port),
    .out_port(out_port),
    .in_addr(in_addr)
  );

  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1);

    // Write to Input Port and read that value in the bus
    in_addr <= 8'b1111111110;
    in_port <= 4'b1100;
    read_en <= 1;
    toggle_clk;
    `assert( out_data, 4'b1100 );
    in_port <= 4'b0001;
    `assert( out_data, 4'b1100 );
    toggle_clk;
    `assert( out_data, 4'b0001 );

    // Write from bus to port and read from port
    in_addr <= 8'b1111111111;
    toggle_clk;
    read_en <= 0;
    write_en <= 1;
    in_data <= 4'b1100;
    `assert( out_port, 4'b0000 );
    toggle_clk;
    `assert( out_port, 4'b1100 );
    
    // Write to Input Port and read that value in the bus with wrong address
    in_addr <= 8'b1111111000;
    in_port <= 4'b1100;
    read_en <= 1;
    toggle_clk;
    `assert( out_data, 4'bz );
    
    // Write from bus to port and read from port with wrong address
    in_addr <= 8'b1110111111;
    toggle_clk;
    read_en <= 0;
    write_en <= 1;
    in_data <= 4'b1111;
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