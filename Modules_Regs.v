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
    input [1:0] rdi,
    input [1:0] rd,
    input [7:0] din1,
    input [7:0] din2,
    input clk, // write enable bite
    output reg[7:0] dout1,
    output reg[7:0] dout2
);

// For data holding inside of the stage register
reg [1:0] rd, rs;
reg [7:0] rd1, rd2;

always @(posedge clk) begin
    rd <= ss1;
    rs <= ss2;
    rd1 <= din1;
    rd2 <= din2;
end

always @(negedge clk) begin
    if (we) begin
        dout1 <= din1;
        dout2 <= din2;
    end
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