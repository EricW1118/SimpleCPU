// Code your design here
// ---------------------------------Main Register------------------------------------------
module MainRegister (
    input we,
    input rst,
    input [1:0] rd1,
    input [1:0] rd2,
    input [1:0] wd,
    input [7:0] din,
    output [7:0] dout1,
    output [7:0] dout2
);

reg [7:0] regis [0:3]; // Array of 4 registers, each 8 bits wide

always @ (posedge rst or posedge we) begin
    if (rst) begin
        regis[0] <= 8'h00;
		  regis[1] <= 8'h00;
		  regis[2] <= 8'h00;
		  regis[3] <= 8'h00;
    end
    else if (we) begin
        regis[wd] <= din;
    end
end

assign dout1 = regis[rd1];
assign dout2 = regis[rd2];

endmodule


module LR (
    input [7:0] in,
    input we,
    input rst,
    output reg[7:0] out
);

always @(posedge we or posedge rst) begin
    if (rst) begin
        out <= 8'h00;
    end
    else if (we) begin
        out <= in;
    end
end
endmodule


// ---------------------------------IF/ID------------------------------------------
module IF_ID (
    input [15:0] insi,
    input clk,
    input rst,
    output reg [15:0] inso
);

reg[15:0] inner_reg;

always @(posedge clk) begin
    inner_reg <= insi;
end

always @(negedge clk) begin
    inso <= inner_reg;
end

endmodule

// ---------------------------------ID/EXE-----------------------------------------
module ID_EXE (
    input [15:0] insi,//original instruction
    input [15:0] din,
    input clk, 
    input rst,
    
    // output when negedge comes
    output reg [15:0] inso,  
    output reg [15:0] dout
);

// For data holding inside of the stage register
reg [15:0] inst, dt;

always @(posedge clk) begin
    inst <= insi;
    dt <= din;
end

always @(negedge clk) begin
    inso <= inst;
    dout <= dt;
end
endmodule

// ---------------------------------EXE/DM-----------------------------------------
module EXE_DM (
    input [15:0] insi,//original instruction
    input [15:0] din,
    input [7:0] alui,
    input clk, // write enable bite
    input rst,
    // output when negedge comes
    output reg [15:0] inso,  
    output reg [15:0] dout,
    output reg [7:0] aluo
);

    reg [15:0] inst;
    reg [15:0] dt;
    reg [7:0] alut;

    always @(posedge clk) begin
        inst <= insi;
        dt <= din;
        alut <= alui;
    end

    always @(negedge clk) begin
        inso <= inst;
        dout <= dt;
        aluo <= alut;
    end
    
endmodule


module DM_WB (
    input [15:0] insi,//original instruction
    input [15:0] din,
    input [7:0] alui,
    input [7:0] memi,
    input clk, // write enable bite
    input rst,

    output reg [15:0] inso,//original instruction
    output reg [15:0] dout,
    output reg [7:0] aluo,
    output reg [7:0] memo
);

    reg [15:0] inst;
    reg [15:0] dt;
    reg [7:0] alut;
    reg [7:0] memt;

    always @(posedge clk) begin
        inst <= insi;
        dt <= din;
        alut <= alui;
        memt <= memi;
    end

    always @(negedge clk) begin
        inso <= inst;//original instruction
        dout <= dt;
        aluo <= alut;
        memo <= memt;
    end
    
endmodule