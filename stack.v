module stack(
  clk, push_en, pop_en,
  in_pc, in_flags,
  out_pc, out_flags
);

  input clk, push_en, pop_en;

  input [8:0] in_pc;
  input [3:0] in_flags;

  output [8:0] out_pc;
  output [3:0] out_flags;

  reg [2:0] index;
  reg [8:0] pc_stack    [0:4];
  reg [3:0] flags_stack [0:4];

  reg empty;

  initial begin
    empty <= 1'b1;
    index <= 0;
  end

  always @(posedge clk) begin
    if ( push_en == 1'b1 && pop_en == 1'b0 ) begin
        if ( empty == 1'b0 && index < 4 ) begin
            index = index + 1;
        end

        empty = 1'b0;
        pc_stack[index]    = in_pc + 1;
        flags_stack[index] = in_flags;
    end

    if ( pop_en == 1'b1 && push_en == 1'b0 ) begin
        if ( index > 0 ) begin
            index = index - 1;
        end
        if ( index == 0 ) begin
            empty = 1'b1;
        end
    end
  end

  assign out_pc    = pc_stack[index];
  assign out_flags = flags_stack[index];
endmodule
