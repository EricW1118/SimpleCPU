//-------------------------One bit adder---------------------
module OneBitAdder( input a, input b, input cin, output sum, output cout);
  wire c1,c2,c3;
  assign sum = a ^ b ^ cin;
  assign cout = (a & cin) | (b & cin) | (a & b);
endmodule

//-------------------------Eight bit adder------------------------------
module EightBitAdder(input [7:0] a, input [7:0] b, output [7:0] sum);
  //Middle wires for connection between cout and cin of neighber onebitadders
  wire [6:0] c;
  OneBitAdder adder0 (.a(a[0]), .b(b[0]), .cin(1'b0), .sum(sum[0]), .cout(c[0]));
  OneBitAdder adder1 (.a(a[1]), .b(b[1]), .cin(c[0]), .sum(sum[1]), .cout(c[1]));
  OneBitAdder adder2 (.a(a[2]), .b(b[2]), .cin(c[1]), .sum(sum[2]), .cout(c[2]));
  OneBitAdder adder3 (.a(a[3]), .b(b[3]), .cin(c[2]), .sum(sum[3]), .cout(c[3]));
  OneBitAdder adder4 (.a(a[4]), .b(b[4]), .cin(c[3]), .sum(sum[4]), .cout(c[4]));
  OneBitAdder adder5 (.a(a[5]), .b(b[5]), .cin(c[4]), .sum(sum[5]), .cout(c[5]));
  OneBitAdder adder6 (.a(a[6]), .b(b[6]), .cin(c[5]), .sum(sum[6]), .cout(c[6]));
  OneBitAdder adder7 (.a(a[7]), .b(b[7]), .cin(c[6]), .sum(sum[7]), .cout());
endmodule

// PC
module ProgramCounter (
  input [7:0] addi,
  input clk,
  input rst,
  output reg [7:0] addo
);

always @(posedge clk or posedge rst) begin
  if (rst) begin
    addo <= 8'h00;
  end
  else begin
    addo <= addi;
  end
end
endmodule

// Branch control
module BranchCntrl (
  input [1:0] ZN,
  input [3:0] op,
  input brx,
  output pc_sec,
  output lr_we,
  output pc_en
);

assign pc_sec = ((op == 4'b1001) || 
                 ({op, brx, ZN[1]} == 6'b101001) || 
                 ({op, brx, ZN[0]} == 6'b101011)) ? 2'b01 : 
                (op == 4'b1100) ? 2'b11 : 2'b00;

//BR.SUB
assign lr_we = (op == 4'b1011) ? 1'b1 : 1'b0;

assign pc_en = 1'b1;

endmodule


module ExternalOutCntrl (
    input [7:0] ra, 
    input [3:0] op,
    output reg[7:0] out
);

always @(ra) begin
  if  (op == 4'b0110) begin
    out <= ra;
  end
end

endmodule

module AluInputCntrl (
  input [15:0] cur_ins,
  input [15:0] pre_ins,
  output reg [1:0] sel
);

always @(*) begin

end
  
endmodule

module Mux_3_to_1 (
  input [7:0] in0,
  input [7:0] in1,
  input [7:0] in2, 
  input [1:0] sel,
  output [7:0] dout
);
assign dout = (sel == 2'b00) ? in0 : 
              (sel == 2'b01) ? in1 : in2;       
endmodule

// Two to One Multiplexor
module Mux_2_to_1(
  input sel, // Selection input
  input [7:0] din0, // Input 0
  input [7:0] din1, // Input 1
  output [7:0] dout // Output
);
assign dout = sel ? din1 : din0;
endmodule