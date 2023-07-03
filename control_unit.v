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

  // Por agregar:
  - Hay que guardar en algún registro o lo que haya en el BUS
    o los 3 bits menos significativos del Rout de los registros
  - Hacer la pila en la UC
    - 5 registros para los PCs y 5 para los flags
    - Guardar el índice del stack pointer

  // Fetch
  - Enable out del PC
  - Enable write del IR
  - Incrementar el PC => out_pc_inc = 1

  // Decode
  - Saltar a la parte correcta de la memoria dependiendo del opcode

  // Execute
  // Op en la ALU
  - En un clock:
    - Mandarle los selectores correctos Rx y Ry a la ALU
    - Mandarle el Alu op
  - En otro clock:
    - Alu en_out
    - Registros write enable
    - Guardar los flags de la ALU en la UC

  // Jumps
  - Pasarle la dirección de memoria del salto al PC
  - pc load (dependiendo de los flags)

  // Cpyr
  - Rx selector ponemos el registro destino
  - Ry selector ponemos el registro fuente
  - read_en y write_en de los registros
  // Setr
  - CU out
  - Rx selector ponemos el registro destino
  - write_en de los registros

  // Write to memory
  // Inmediato - write M => M <= R0
  - En un ciclo
    - CU out para escribir el inmediato
    - Memory address write enable
  - En otro ciclo
    - Ry selector ponemos R0
    - Read enable de los registros
    - Mem in enable del data memory
  // Indirecto a memoria - write [M] => [M] <= R0
  - En un ciclo
    - CU out para escribir el inmediato
    - Memory address write enable
  - En otro ciclo
    - Mem out enable del data memory
    - Memory address write enable
  - En otro ciclo
    - Ry selector ponemos R0
    - Read enable de los registros
    - Mem in enable del data memory
  // Directo a registro - write Ry => [Ry] <= R0
  - En un ciclo
    - Ry selector ponemos el registro fuente dado por el IR
    - Read enable de los registros
    - Memory address write enable
  - En otro ciclo
    - Ry selector ponemos R0
    - Read enable de los registros
    - Mem in enable del data memory
  // Indirecto a registro - write [Ry] => [registros[Ry]] <= R0
  - En un ciclo
    - Ry selector ponemos el registro fuente dado por el IR
    - Read enable de los registros
    - Escribimos en el registro de la UC lo que salga de Rout
  - En otro ciclo
    - Ry selector ponemos el registro de la UC
    - Read enable de los registros
    - Mem in enable del data memory
  - En otro ciclo
    - Ry selector ponemos R0
    - Read enable de los registros
    - Mem in enable del data memory

  // call m
  - Push del PC y de los flags a la pila
  - Setear el PC con el inmediato del IR

  // ret m
  - Pop de los flags y del PC de la pila
    - Pisar el registro de flags del CU
    - Pisar el PC

  // gflags
  - CU out ponemos los flags
  - Rx selector ponemos el registro destino
  - Read enable de los registros

  // selmb
  - Mandarle al bank selector los 2 bits más significativos del inmediato
  - Bank selector enable write
endmodule