// Code your design here
// ---------------------------------Main Register------------------------------------------
module MainRegister (
    input we,
    input [1:0] rd1,
    input [1:0] rd2,
    input [1:0] wd,
    input [7:0] din,
    output [7:0] dout1,
    output [7:0] dout2
);

reg [7:0] regis [0:3]; // Array of 4 registers, each 8 bits wide

always @ (*) begin
    if (we) begin
        regis[wd] <= din;
    end
end
assign dout1 = regis[rd1];
assign dout2 = regis[rd2];
endmodule


// ---------------------------------IF/ID------------------------------------------
module RfIfId (
    input [15:0] insi,
    input clk,
    input we,
    output reg [15:0] inso
);

reg[15:0] inner_reg;

always @(posedge clk) begin
    if (we) begin
        inner_reg <= insi;
    end
end

always @(negedge clk) begin
    if (we) begin
        inso <= inner_reg;
    end
end
endmodule


// ---------------------------------ID/EXE-----------------------------------------
module RfIdExe (
    input [15:0] insi,//original instruction
    input [15:0] din,
    input clk, // write enable bite
    
    // output when negedge comes
    output reg [15:0] inso,  
    output reg [15:0] dout
);

// For data holding inside of the stage register
  reg [15:0] inst;
  reg [15:0] dt;

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
module RfExeDm (
    input [15:0] insi,//original instruction
    input [15:0] din,
    input [7:0] alui,
    input clk, // write enable bite

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


module RfDmWb (
    input [15:0] insi,//original instruction
    input [15:0] din,
    input [7:0] alui,
    input [7:0] memi,
    input clk, // write enable bite

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