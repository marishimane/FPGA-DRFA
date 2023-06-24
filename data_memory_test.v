module data_memory_test;
  reg clk = 0;
  reg [9:0] in_addr;
  reg in_write_en = 0;
  reg [7:0] in_data;
  reg [7:0] out_data;

  data_memory DATA_MEMORY(
    .clk(clk),
    .in_addr(in_addr),
    .in_write_en(in_write_en),
    .in_data(in_data),
    .out_data(out_data)
  );

  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1);

    // write some value
    in_write_en <= 1;
    in_data <= 8'b0101_0101;
    in_addr <= 10'b00_0000_0000;

    toggle_clk;
    if(out_data !== 8'b0101_0101) begin
      $display("[TEST FAILED] 1");
      $finish;
    end

    // disable write
    in_write_en <= 0;
    in_data <= 8'b1111_1111;

    toggle_clk;

    if(out_data !== 8'b0101_0101) begin
      $display("[TEST FAILED] 2");
      $finish;
    end

    // change address and write
    in_write_en <= 1;
    in_data <= 8'b0000_0010;
    in_addr <= 10'b00_0000_0001;
    toggle_clk;

    in_data <= 8'b0000_0100;
    in_addr <= 10'b00_0000_0010;
    toggle_clk;

    in_data <= 8'b0000_1000;
    in_addr <= 10'b00_0000_0011;
    toggle_clk;

    in_write_en <= 0;
    in_data <= 8'bZZZZ_ZZZZ;

    in_addr <= 10'b00_0000_0001;
    toggle_clk;
    if(out_data !== 8'b0000_0010) begin
      $display("[TEST FAILED] 3");
      $finish;
    end

    in_addr <= 10'b00_0000_0010;
    toggle_clk;
    if(out_data !== 8'b0000_0100) begin
      $display("[TEST FAILED] 4");
      $finish;
    end

    in_addr <= 10'b00_0000_0011;
    toggle_clk;
    if(out_data !== 8'b0000_1000) begin
      $display("[TEST FAILED] 5");
      $finish;
    end
  end



  task toggle_clk;
    begin
      #10 clk = ~clk;
      #10 clk = ~clk;
    end
  endtask
endmodule
