
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


// Two to One Multiplexor
module TwoToOneMux(
    input sel, // Selection input
    input [7:0] din0, // Input 0
    input [7:0] din1, // Input 1
    output reg [7:0] dout // Output
);
always @(sel,din0,din1) begin
    dout <= (sel == 1'b0 ? din0 : din1);
end

endmodule