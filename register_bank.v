module register_bank(
  clk, read_en, write_en, in_rx_selector, in_ry_selector,
  in_indirect_mode_en,
  in_data, out_bus_data, out_rx_data, out_ry_data
);

  input clk, read_en, write_en;
  input [2:0] in_rx_selector, in_ry_selector;
  input in_indirect_mode_en;
  input [7:0] in_data;

  output [7:0] out_bus_data, out_rx_data, out_ry_data;

  reg [7:0] registers [0:7];

  initial begin
    registers[0] <= 0; registers[1] <= 0; registers[2] <= 0;
    registers[3] <= 0; registers[4] <= 0; registers[5] <= 0;
    registers[6] <= 0; registers[7] <= 0;
  end

  always @(posedge clk) begin
    $display("register_read_en: ", read_en);
    $display("register_out_bus_data: ", out_bus_data);
    $display("register_in_ry_selector: ", in_ry_selector);

    $display("register_in_rx_selector: ", in_rx_selector);

    $display("registers[ry_sel]: ", registers[in_ry_selector]);
    $display("registers[rx_sel]: ", registers[in_rx_selector]);
    $display("registers_indirect_mode: ", in_indirect_mode_en);
    $display("out_rx_data", out_rx_data);
    $display("out_ry_data", out_ry_data);
  end

  always @(negedge clk) begin
    $display("negedge");
    $display("registers[ry_sel]: ", registers[in_ry_selector]);
    $display("registers[rx_sel]: ", registers[in_rx_selector]);
    $display("registers_indirect_mode: ", in_indirect_mode_en);
    $display("out_rx_data", out_rx_data);
    $display("out_ry_data", out_ry_data);
    if ( write_en ) begin
      // Only one register can be written at a time
      registers[in_rx_selector] <= in_data;
    end
  end

  assign out_bus_data = read_en
    ? (in_indirect_mode_en? registers[registers[in_ry_selector]] : registers[in_ry_selector])
    : 'bz;
  assign out_rx_data = registers[in_rx_selector];
  assign out_ry_data = registers[in_ry_selector];
endmodule
