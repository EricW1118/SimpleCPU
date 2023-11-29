
// -----------------------------------ALU------------------------------------------
module ALU (
    input signed [7:0] ex_in,
    input signed [7:0] imm,
    input signed [7:0] s1, // first oprand
    input signed [7:0] s2,// second oprand
    input [3:0] op, // depends on the opration code
    input clk,
    output signed [7:0] result, // the calculation output
    output reg [1:0] ZN = 2'b00
);

wire signed [7:0] res;
assign result = (op == 4'h1) ? s1 + s2 : //ADD
                (op == 4'h2) ? s1 - s2: //MOVE
                (op == 4'h3) ? ~(s1 & s2) : //NAND
                (op == 4'h4) ? {s1[6:0], 1'b0} : //SHL
                (op == 4'h5) ? {1'b0, s1[7:1]} : //SHR
                (op == 4'h6) ? s1 : //OUT
                (op == 4'h7) ? ex_in : //IN
                (op == 4'he) ? s1 : //STORE
                (op == 4'hf) ? imm : //LOADIMM
                (op == 4'h8) ? s2 : 8'h0;//MOV

always @(negedge clk ) begin
    if (op == 4'h1 || op == 4'h2 || op === 4'h3) begin //ADD, SUB, NAND
        ZN[1] <= (result == 0) ? 1'b1 : 1'b0;
        ZN[0] <= (result < 0) ? 1'b1 : 1'b0;
    end
    else if (op === 4'h4) begin //SHL
        ZN[1] <= s1[7];
    end
    else if (op === 4'h5) begin //SHR
        ZN[1] <= s1[0];
    end
end

endmodule



