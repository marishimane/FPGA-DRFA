module data_memory(
    clk,
    in_addr, in_write_en,
    in_data, out_data,
);
  input clk;

  input [9:0] in_addr;
  input in_write_en;

  input [7:0] in_data;
  output [7:0] out_data;

  reg [7:0] mem [0:1023];
  reg [7:0] read_data;

  initial begin
      read_data <= 8'h00;
  end

  localparam in_port_addr = 8'b1111111110;
  localparam out_port_addr = 8'b1111111111;

  // NOTA: secuencial y read_data disponible en mismo clock
  // o combinacional y read_data disponible en siguiente clock
  always @(posedge clk) begin
    if (in_addr != in_port_addr && in_addr != out_port_addr) begin
      if (in_write_en == 1'b1) mem[in_addr] = in_data;
      read_data = mem[in_addr];
    end else begin
      read_data = 'bz;
    end
  end

  assign out_data = read_data;
endmodule
