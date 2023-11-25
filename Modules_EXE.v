// -----------------------------------ALU------------------------------------------
module ALU (
    input [7:0] ex_in,
    input [7:0] imm,
    input [7:0] s1, // first oprand
    input [7:0] s2,// second oprand
    input [3:0] mode, // depends on the opration code
    output reg [7:0] result, // the calculation output
    output reg [1:0] ZN
);

always @(mode) begin
    case (mode)
        4'h7: result <= ex_in; //  IN
        4'he: result <= s1;    //  STORE result = ra
        4'hf: result <= imm;   //  LOADIMM
        4'h8: result <= s2;    //  MOVE
        4'h1: begin // ADD
            result <= s1 + s2;
            ZN[1] <= (s1 + s2) ? 1'b1 : 1'b0;
            ZN[0] <= (s1 + s2) < 0 ? 1'b1 : 1'b0;
        end
        4'h2: begin // ADD
            result <= s1 - s2;
            ZN[1] <= (s1 == s2) ? 1'b1 : 1'b0;
            ZN[0] <= (s1 < s2) ? 1'b1 : 1'b0;
        end
        4'h3: begin // NAND
            result <= ~(s1 & s2);
            ZN[1] <= (~(s1 & s2)) ? 1'b1 : 1'b0;
            ZN[0] <= ((~(s1 & s2)) < 0) ? 1'b1 : 1'b0;
        end
        4'h4: begin // SHL
            result <= {s1[6:0], 1'b0};
            ZN[1] <= s1[7];
        end
        4'h5: begin // SHR
            result <= {1'b0, s1[7:1]};
            ZN[1] <= s1[0];
        end
        default:;
    endcase
end

endmodule



