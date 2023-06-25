module memory_bank_selector(
  write_en, in_data, out_data
);

  input write_en;
  input [1:0] in_data;
  output [1:0] out_data;

  reg [1:0] memory_bank;

  assign memory_bank = write_en? in_data : memory_bank;
  assign out_data = memory_bank;
endmodule