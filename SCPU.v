
`timescale 1 ps/ 1 ps

module TestSCPU();
  reg signed [7:0] in;  
  wire [7:0] out;
  reg clk;
  
  reg signed [15:0] sample_inss; 
  reg ins_write_enable; 
  SCPU scpy1(.clk(clk), .ins_index(in), .ins_we(ins_write_enable), .instructs(sample_inss), .res(out));

  // Total simulation time is 300
  initial begin
    in <= 8'b0;
    clk <= 1'b0;
    ins_write_enable <= 1'b1;
    sample_inss <= 16'h0000;
    #1000 $stop;
  end
  
  integer i;
  // write some instructions into instruction memeory
  initial begin
    for (i = 0; i < 128; i = i + 1) begin
      #1 clk = ~clk;
      #1 clk = ~clk;
      sample_inss <= sample_inss + 1;
      in <= in + 2;
    end
  end

  // initial begin
  //   forever begin
  //     #2 in = in+1;
  //     #1 clk = ~clk;
  //     #1 clk = ~clk;
  //   end
  // $finish;
// end  
endmodule

