// Code your design here
// ---------------------------------Main Register------------------------------------------
module MainRegister (
    input re,
    input [1:0] rd1,
    input [1:0] rd2,
    input [0:1] wd,
    input [7:0] din,
    output [7:0] dout1,
    output [7:0] dout2
);

reg [7:0] regis [0:3]; // Array of 4 registers, each 8 bits wide

always @ (*) begin
    if (re) begin
        regis[wd] <= din;
    end
end
assign dout1 = regis[rd1];
assign dout2 = regis[rd2];
endmodule


// ---------------------------------Stage Register-----------------------------------------
module StageRegister (
    input [3:0] opi,  //operation code
    input [1:0] rai, 
    input [1:0] rbi,
    input [7:0] din1,
    input [7:0] din2,
    input [7:0] immedi,
    input [1:0] ZNi,
    input clk, // write enable bite
    
    // output when negedge comes
    output reg [3:0] opo,  
    output reg [1:0] rao, 
    output reg [1:0] rbo,
    output reg [7:0] dout1,
    output reg [7:0] dout2,
    output reg [7:0] immedo,
    output reg [1:0] ZNo
);

// For data holding inside of the stage register
  reg [3:0] opt;
  reg [1:0] rat;
  reg [1:0] rbt;
  reg [7:0] dt1;
  reg [7:0] dt2;
  reg [7:0] immedt;
  reg [1:0] ZNt;

always @(posedge clk) begin
    opt <= opi;
    rat <= rai;
    rbt <= rbi;
    dt1 <= din1;
    dt2 <= din2;
    immedt <= immedi;
    ZNt <= ZNi;
end

always @(negedge clk) begin
    opo <= opt;
    rao <= rat;
    rbo <= rbt;
    dout1 <= dt1;
    dout2 <= dt2;
    immedo <= immedt;
    ZNo <= ZNt;
end

endmodule


module RF_IF_ID (
    input [15:0] insi,
    output reg [15:0] inso,
    input clk,
    input we
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