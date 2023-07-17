module code_memory_test;
  reg [8:0] in_addr;
  wire [15:0] out_data;

  code_memory CODE_MEMORY(
    .in_addr(in_addr),
    .out_data(out_data)
  );

  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1);

    // read first value
    in_addr <= 9'b0_0000_0000;
    #10

    if(out_data !== 16'b1111_0000_1111_0000) begin
      $display("[TEST FAILED] 1");
      $finish;
    end

    // read second value
    in_addr <= 9'b0_0000_0001;
    #10

    if(out_data !== 16'b0000_1111_0000_1111) begin
      $display("[TEST FAILED] 2");
      $finish;
    end
  end
endmodule
