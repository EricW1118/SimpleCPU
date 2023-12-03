
//Only for board testing. Make the clock slower.
module CPUB(input rst, input clk, input [7:0] in, output [7:0] out);
  reg slow_clk;
  SCPU inner_cpu(.ext_in(in), .clk(slow_clk), .rst(rst), .ext_out(out));
  reg [16:0] counter;

  initial begin
    counter <= 16'd0;
    slow_clk <= 1'b0;
  end

  always @(posedge clk) begin
      
      counter = counter + 16'd1; 
      if (counter >= 100000) begin
        slow_clk  <= ~slow_clk;
        counter <= 0;
      end
  end

endmodule

