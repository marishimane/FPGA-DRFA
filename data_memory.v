module data_memory(
    clk, in_addr, in_write_en, in_read_en,
    in_data, out_data,
);
  input clk;

  input [9:0] in_addr;
  // Hacer esto un registro en algo por fuera y agregar una señal para escribirlo
  // Sería para la data memory y para el io ports
  input in_write_en, in_read_en;

  input [7:0] in_data;
  output [7:0] out_data;

  reg [7:0] mem [0:1023];
  reg [7:0] read_data;

  initial begin
    read_data <= 8'h00;
  end

  localparam in_port_addr = 10'b1111111110;
  localparam out_port_addr = 10'b1111111111;

  // NOTA: secuencial y read_data disponible en mismo clock
  // o combinacional y read_data disponible en siguiente clock
  always @(posedge clk) begin
    if (in_addr != in_port_addr && in_addr != out_port_addr) begin
      if ( in_write_en == 1 ) mem[in_addr] = in_data;

      // if ( in_read_en == 1 ) read_data = mem[in_addr];
    end
  end

  assign out_data = (in_addr != in_port_addr && in_addr != out_port_addr && in_read_en)? mem[in_addr] : 'bz;
endmodule
