`define assert(signal, value) \
    if (signal !== value) begin \
        $display("ASSERTION FAILED in %m: signal != value"); \
        $finish; \
    end

module test;
  reg clk = 0, write_en = 0, read_en = 0;
  reg [7:0] in_data, out_data;
  reg [2:0] in_selector;

  register_bank registers(
    .clk(clk),
    .in_selector(in_selector),
    .in_data(in_data),
    .write_en(write_en),
    .read_en(read_en),
    .out_data(out_data)
  );

  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1);

    write_en <= 1;
    in_data <= 8'b10101010;
    in_selector <= 3'b100;
    toggle_clk;

    in_data <= 8'b00001111;
    in_selector <= 3'b000;
    toggle_clk;

    write_en <= 0;
    read_en <= 1;
    toggle_clk;
    `assert( out_data, 8'b00001111 );

    in_selector <= 3'b100;
    toggle_clk;
    `assert( out_data, 8'b10101010 );

    toggle_clk;
  end

  task toggle_clk;
    begin
      #10 clk = ~clk;
      #10 clk = ~clk;
    end
  endtask
endmodule