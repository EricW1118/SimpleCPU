// -----------------------------------ALU------------------------------------------
module ALU (
    input [7:0] ex_in,
    input [7:0] imm,
    input [7:0] s1, // first oprand
    input [7:0] s2,// second oprand
    input [3:0] mode, // depends on the opration code
    input clk,
    output [7:0] result, // the calculation output
    output reg [1:0] ZN
);

assign result = (mode == 4'h7) ? ex_in :
	            (mode == 4'he) ? s1 :
                (mode == 4'hf) ? imm :
                (mode == 4'h8) ? s2 : 
                (mode == 4'h1) ? s1 + s2 :
                (mode == 4'h2) ? s1 - s2 : 
                (mode == 4'h3) ? ~(s1 & s2) :
                (mode == 4'h4) ? {s1[6:0], 1'b0} :
                (mode == 4'h5) ? {1'b0, s1[7:1]} : 8'h0;
                
always @(negedge clk) begin
    case (mode)
        4'h1: begin // ADD
            ZN[1] <= (s1 + s2) ? 1'b1 : 1'b0;
            ZN[0] <= (s1 + s2) < 0 ? 1'b1 : 1'b0;
        end
        4'h2: begin // ADD
            ZN[1] <= (s1 == s2) ? 1'b1 : 1'b0;
            ZN[0] <= (s1 < s2) ? 1'b1 : 1'b0;
        end
        4'h3: begin // NAND
            ZN[1] <= (~(s1 & s2)) ? 1'b1 : 1'b0;
            ZN[0] <= ((~(s1 & s2)) < 0) ? 1'b1 : 1'b0;
        end
        4'h4: begin // SHL
            ZN[1] <= s1[7];
        end
        4'h5: begin // SHR
            ZN[1] <= s1[0];
        end
        default:;
    endcase
end

endmodule



