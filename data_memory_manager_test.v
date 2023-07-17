`define assert(signal, value) \
    if (signal !== value) begin \
        $display("ASSERTION FAILED in %m: signal != value"); \
        $finish; \
    end

module data_memory_manager_test;
  localparam INPUT_PORT = 10'b1111111110;
  localparam OUTPUT_PORT = 10'b1111111111;

  reg clk = 0, in_write_en = 0, in_read_en = 0, in_addr_write_en = 0;
  reg [7:0] in_data;
  reg [9:0] in_addr;
  reg [3:0] in_port;
  wire [7:0] out_data;
  wire [3:0] out_port;

  data_memory_manager data_memory_manager(
    .clk(clk),
    .in_write_en(in_write_en),
    .in_read_en(in_read_en),
    .in_addr_write_en(in_addr_write_en),
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

    in_read_en <= 1;
    in_write_en <= 1;
    in_addr_write_en <= 1;

    // WRITE
    in_data <= 8'b10011001;
    // with the address of the input port
    in_addr <= INPUT_PORT;
    in_write_en <= 1;
    toggle_clk;
    `assert( out_data, 8'bx );
    toggle_clk;

    // with a different address
    in_addr <= 8'b00001111;
    // with in_write_en = 0
    in_write_en <= 0;
    toggle_clk;
    `assert( out_data, 8'bx );
    toggle_clk;

    // with in_write_en = 1
    in_write_en <= 1;
    toggle_clk;
    `assert( out_data, 8'b10011001 );
    toggle_clk;
    in_write_en <= 0;

    // READ
    in_read_en <= 1;
    // with the address of the input port
    in_addr <= INPUT_PORT;
    toggle_clk;
    `assert( out_data, 8'bx );
    toggle_clk;

    // with the address of the output port
    in_addr <= OUTPUT_PORT;
    toggle_clk;
    `assert( out_data, 8'bz );
    toggle_clk;

    // with a different address
    in_addr <= 8'b00001111;
    // with in_read_en = 0
    in_read_en <= 0;
    toggle_clk;
    `assert( out_data, 8'bz );
    toggle_clk;

    // with in_read_en = 1
    in_read_en <= 1;
    toggle_clk;
    `assert( out_data, 8'b10011001 );
    toggle_clk;
    in_read_en <= 0;

    // PORTS
    // Write to Input Port and read that value in the bus
    in_read_en <= 1;
    in_port <= 4'b1100;
    // with the incorrect port address
    in_addr <= 8'b01010101;
    toggle_clk;
    `assert( out_data, 8'bx );
    toggle_clk;

    // with the correct port address
    in_addr <= INPUT_PORT;
    toggle_clk;
    `assert( out_data, 8'b11111100 );
    toggle_clk;
    in_port <= 4'b0001;
    `assert( out_data, 8'b11111100 );
    toggle_clk;
    `assert( out_data, 8'b00000001 );
    toggle_clk;

    // Write from bus to port and read from port
    in_read_en <= 0;
    in_write_en <= 1;
    in_data <= 8'b10001100;
    // with the incorrect port address
    in_addr <= 8'b01010101;
    toggle_clk;
    `assert( out_port, 4'b0000 );

    // with the correct port address
    in_addr <= OUTPUT_PORT;
    toggle_clk;
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
