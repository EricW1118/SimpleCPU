`timescale 1 ps/ 1 ps

module scpu_board_tb();
  reg  [7:0] in;  
  wire [7:0] out;
  reg clk;
  reg rst;

  CPUB mycpu(.rst(rst), .in(in), .clk(clk), .out(out));

  initial begin
    clk = 1'b0;
    in <= 8'h0f;
    rst <= 1'b0;
    #1 rst <= ~rst;
    #1 rst <= ~rst;
  end

  always begin
    #1 clk <= ~clk;
    #1 clk <= ~clk;
  end

endmodule