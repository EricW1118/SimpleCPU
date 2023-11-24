// -----------------------------------ALU------------------------------------------
module ALU (
    input [7:0] ex_in,
    input signed [7:0] s1, // first oprand
    input signed [7:0] s2,// second oprand
    input [3:0] mode, // depends on the opration code
    output reg signed [7:0] result, // the calculation output
    output reg [1:0] ZN
);

always @(mode, s1, s2) begin
    case (mode)
    // Nothing
    4'h0: ;
    // Add
    4'h1: begin
        result = s1 + s2;
        ZN = (result == 0 ? {1'b1, ZN[0] } : {1'b0, ZN[0]});
        ZN = (result <= 0 ? {ZN[1], 1'b1 } : {ZN[1], 1'b0});
    end
    // Sub
    4'h2: begin
        result = s1 - s2;
        ZN = (result == 0 ? {1'b1, ZN[0] } : {1'b0, ZN[0]});
        ZN = (result <= 0 ? {ZN[1], 1'b1 } : {ZN[1], 1'b0});
    end
    //NAND
    4'h3: begin
        result = ~(s1 & s2);
        ZN = (result == 0 ? {1'b1, ZN[0]} : {1'b0, ZN[0]});
        ZN = (result <= 0 ? {ZN[1], 1'b1} : {ZN[1], 1'b0});
    end
    // SHL
    4'h4: begin
        ZN = {s1[7], ZN[0]};
        result = {s1[6:0], 1'b0};
    end
    // SHR
    4'h5: begin
        ZN = {s1[0], ZN[0]};
        result = {1'b0, s1[7:1]};
    end
    // OUT
    4'h6: begin
        result <= s1;
    end
    // IN
    4'h7: begin
        result <= s1;
    end
    // Move
    4'h8: begin
        result <= s2;
    end
    // BR
    4'h9: ;
    // BR.Z/N
    4'ha: ;
    // BR.SUB
    4'hb: ;
    // RETURN
    4'hc: ;
    // Load
    4'hd: ;
    // Store
    4'he: ;
    // LoadIMM
    4'hf: ;
    default: ;
endcase
end

endmodule



