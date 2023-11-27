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

always @ ( posedge we or posedge rst ) begin
    if (rst) begin
        regis[0] <= 8'h00;
        regis[1] <= 8'h01;
        regis[2] <= 8'h02;
        regis[3] <= 8'h03;
    end 
    else if (we) begin
        regis[wd] <= din;
    end
end

assign dout1 = regis[rd1];
assign dout2 = regis[rd2];

endmodule

//  LR register for CALL and RETURN
module LR (
    input [7:0] in,
    input we,
    input rst,
    output reg[7:0] out
);

always @(posedge we or posedge rst ) begin
    if (rst) begin
        out <= 8'h00;
    end
    else if (we) begin
        out <= in;
        $display("LR instruction in :%b", in);
    end
end
endmodule

// ---------------------------------IF/ID------------------------------------------
module IF_ID (
    input [15:0] insi,
    input clk,
    input rst,
    input bubble_en,
    output reg [15:0] inso
);
always @(posedge clk or posedge rst) begin
    if (rst) begin
        inso <= 16'h0; // reset value
    end
    else if (bubble_en)begin
        inso <= 16'h0; // insert bubble
        $display("Bubble insert between %b and %b", insi, inso);
    end
    else begin
        inso <= insi;  // regular
    end
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

always @(posedge clk or posedge rst) begin
    if (rst) begin
        inso <= 16'h0;
        dout <= 16'h0;
    end
    else begin
        inso <= insi;
        dout <= din;
    end
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
always @(posedge clk or posedge rst) begin
    if (rst) begin
        inso <= 16'h0;
        dout <= 16'h0;
        aluo <= 8'h0;
    end 
    else begin
        inso <= insi;
        dout <= din;
        aluo <= alui;
    end
end
endmodule



// ----------------------------------DM/WB-----------------------------------------
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
always @(posedge clk or posedge rst) begin
    if (rst) begin
        inso <= 16'h0;
        dout <= 16'h0;
        aluo <= 8'h0;
        memo <= 8'h0;
    end
    else begin
        inso <= insi;
        dout <= din;
        aluo <= alui;
        memo <= memi;
    end
end
endmodule