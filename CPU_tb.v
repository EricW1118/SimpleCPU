`timescale 1 ps/ 1 ps

module scpu_tb();
  reg  [7:0] in;  
  wire [7:0] out;
  reg rst;
  reg clk;

  SCPU mycpu(.ext_in(in), .clk(clk), .rst(rst), .ext_out(out));

  initial begin
    clk = 1'b0;
    in <= 8'h0f;
    rst <= 1'b1;
    #5 rst <= 1'b0;
    #20 $stop;
  end

  always begin
    #1 clk <= ~clk;
    #1 clk <= ~clk;
    $display("Final output = %d",out );
  end

endmodule