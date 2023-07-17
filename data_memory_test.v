`define assert(signal, value) \
    if (signal !== value) begin \
        $display("ASSERTION FAILED in %m: signal != value"); \
        $finish; \
    end

module data_memory_test;
  localparam INPUT_PORT = 10'b1111111110;
  localparam OUTPUT_PORT = 10'b1111111111;

  reg clk = 0, in_write_en = 0, in_read_en = 0;
  reg [7:0] in_data;
  reg [9:0] in_addr;

  wire [7:0] out_data;

  data_memory DATA_MEMORY(
    .clk(clk),
    .in_addr(in_addr),
    .in_write_en(in_write_en),
    .in_read_en(in_read_en),
    .in_data(in_data),
    .out_data(out_data)
  );

  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1);

    in_read_en <= 1;

    // WRITE
    in_data <= 8'b10011001;
    // with the addres of the input port
    in_addr <= INPUT_PORT;
    in_write_en <= 1;
    toggle_clk;
    `assert( out_data, 8'bz );
    toggle_clk;

    // with the addres of the output port
    in_addr <= OUTPUT_PORT;
    toggle_clk;
    `assert( out_data, 8'bz );
    toggle_clk;

    // with a valid address
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
    // with the addres of the input port
    in_addr <= INPUT_PORT;
    toggle_clk;
    `assert( out_data, 8'bz );
    toggle_clk;

    // with the addres of the output port
    in_addr <= OUTPUT_PORT;
    toggle_clk;
    `assert( out_data, 8'bz );
    toggle_clk;

    // with a valid address
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
  end

  task toggle_clk;
    begin
      #10 clk = ~clk;
      #10 clk = ~clk;
    end
  endtask
endmodule
