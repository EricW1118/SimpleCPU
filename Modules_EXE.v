// -----------------------------------ALU------------------------------------------
module ALU (
    input signed [7:0] ex_in,
    input signed [7:0] imm,
    input signed [7:0] s1, // first oprand
    input signed [7:0] s2,// second oprand
    input [3:0] mode, // depends on the opration code
    input clk,
    output reg signed [7:0] result, // the calculation output
    output reg [1:0] ZN
);
always @(negedge clk ) begin
    $display("current mode: %d", mode);
    if (mode === 4'h7) begin //IN
        result <= ex_in;
    end
    else if (mode === 4'h6) begin //OUT 
        result <= s1;
    end
    else if (mode === 4'he)  begin //STORE
        result <= s1;
    end
    else if (mode === 4'hf) begin //LOADIMM
        result <= imm;
    end
    else if (mode === 4'he) begin //STORE
        result <= s1;
    end
    else if (mode === 4'h1) begin
        result = s1 + s2;
        ZN[1] <= result ? 1'b1 : 1'b0;
        ZN[0] <= result < 0 ? 1'b1 : 1'b0;
    end
    else if (mode === 4'h2) begin
        result = s1 - s2;
        ZN[1] <= result ? 1'b1 : 1'b0;
        ZN[0] <= result < 0 ? 1'b1 : 1'b0;
    end
    else if (mode === 4'h3) begin
        result = ~(s1 & s2);
        ZN[1] <= result ? 1'b1 : 1'b0;
        ZN[0] <= result < 0 ? 1'b1 : 1'b0;
    end
    else if (mode === 4'h4) begin
        result <= {s1[6:0], 1'b0} ;
        ZN[1] <= s1[7];
    end
    else if (mode === 4'h5) begin
        result <= {1'b0, s1[7:1]};
        ZN[1] <= s1[0];
    end
    else begin
        result <= 8'h0;
    end
end
endmodule



