`define assert(signal, value) \
    if (signal !== value) begin \
        $display("ASSERTION FAILED in %m: signal != value"); \
        $finish; \
    end



module drf_system_test;
  reg clk = 0;
  reg [3:0] port_input = 'b0;
  wire [3:0] port_output;
  integer test = 2000;

  wire [2:0] in_rx_selector;
  wire [2:0] in_ry_selector;
  wire reg_write_en;
  wire [7:0] reg_in_data;
  integer contador = 1;
  integer ns = 0;

  drf_system drf_system(
    .clk(clk),
    .port_input(port_input),
    .port_output(port_output)
  );

  always begin
    #10 clk=~clk;
    ns = ns + 10;
  end

  always begin
    forever begin
      @(posedge clk);
      // Primer patrón
      if ( ns > 6000 && ns < 7000 ) begin
        port_input <= 4'b0010;
      end
      if ( ns > 9000 && ns < 10000 ) begin
        port_input <= 4'b0000;
      end

      // Segundo patrón
      if ( ns > 15000 && ns < 16000 ) begin
        port_input <= 4'b0010;
      end
      if ( ns > 18000 && ns < 19000 ) begin
        port_input <= 4'b0000;
      end
      if ( ns > 21000 && ns < 22000 ) begin
        port_input <= 4'b0100;
      end
      if ( ns > 23000 && ns < 24000 ) begin
        port_input <= 4'b0000;
      end

      // Tercer patrón
      if ( ns > 34000 && ns < 35000 ) begin
        port_input <= 4'b1000; // Para que falle
      end
    end
  end

  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1);

    while ( test > 0 ) begin
      @(posedge clk);
      test = test - 1;
    end

    $finish;
  end

  task toggle_clk;
    begin
      #10 clk = ~clk;
      #10 clk = ~clk;
    end
  endtask
endmodule
