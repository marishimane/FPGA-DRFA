module control_unit(
  in_alu_flags, in_ir, out_alu_enable_out, out_pc_load,
  out_pc_inc, out_pc_enable_out, out_ir_enable_read,
  out_mbs_wr_enable, out_data_memory_read_enable,
  out_data_memory_wr_enable, out_reg_write_en, out_reg_read_en
);

  input [3:0] in_alu_flags;
  input [15:0] in_ir;
  output out_alu_enable_out, out_pc_load, out_pc_inc, out_pc_enable_out,
    out_ir_enable_read, out_mbs_wr_enable, out_data_memory_read_enable,
    out_data_memory_wr_enable, out_reg_write_en, out_reg_read_en;

endmodule