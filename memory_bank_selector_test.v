`define assert(signal, value) \
    if (signal !== value) begin \
        $display("ASSERTION FAILED in %m: signal != value"); \
        $finish; \
    end

module test;
  reg write_en = 0;
  reg [1:0] in_data, out_data;

  memory_bank_selector memory_bank_selector(
    .write_en(write_en),
    .in_data(in_data),
    .out_data(out_data)
  );

  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1);

    wait_10ns;
    in_data <= 2'b00;
    wait_10ns;

    write_en = 1;
    wait_10ns;
    `assert( out_data, 2'b00 );

    write_en = 0;
    wait_10ns;
    `assert( out_data, 2'b00 );

    in_data <= 2'b10;
    write_en = 1;
    wait_10ns;
    `assert( out_data, 2'b10 );
  end

  task wait_10ns;
    begin
      #10;
    end
  endtask
endmodule