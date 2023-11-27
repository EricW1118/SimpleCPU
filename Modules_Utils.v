// PC
module ProgramCounter (
  input [7:0] addi,
  input clk,
  input rst,
  input we,
  output reg [7:0] addo
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
       addo <= 8'h0;
    end
    else if(we) begin
      addo <= addi;
    end
end
endmodule

// Branch control
module BranchCntrl (
  input [1:0] ZN,
  input [3:0] op,
  input brx,
  input clk,
  output reg [1:0] pc_sec = 2'b00,
  output reg lr_we = 1'b0
);

always @(negedge clk) begin
    lr_we <= (op == 4'hb) ? 1'b1 : 1'b0;
    if (op == 4'b1101) begin  //RETURN
      pc_sec <= 2'b10;
      $display("return branch jump");
    end
    else if (op == 4'h9) begin
      pc_sec <= 2'b01;
      $display("branch jump");
    end
    else if ({op, brx, ZN[1]} == 6'b101001) begin
      pc_sec <= 2'b01;
      $display("branch Z jump");
    end
    else if ({op, brx, ZN[0]} == 6'b101011) begin
      pc_sec <= 2'b01;
      $display("branch N jump");
    end
    else begin
      pc_sec <= 2'b00;
    end
end

endmodule

module ExtOutCntrl (
    input [7:0] ra, 
    input [3:0] op,
    input we,
    output reg[7:0] out
);

always @(posedge we) begin 
  if (op == 4'b0110) begin
    out <= ra;
  end
end

endmodule


// Write back control
module WBCntrl (
  input [7:0] alu,
  input [7:0] mem,
  input [7:4] op,
  output [7:0] wbdata,
  output rfwe
);
assign rfwe = ( (op ==  4'h1) || // ADD
                (op ==  4'h2) || // SUB
                (op ==  4'h3) || // NAND
                (op ==  4'h4) || // SHL
                (op ==  4'h5) || // SHR
                (op ==  4'h7) || // IN
                (op ==  4'h8) || // MOV
                (op ==  4'hd) || // LOAD
                (op ==  4'hf) ) ? 1'b1 : 1'b0; // LOADIMM
// LOAD
assign wbdata = (op == 4'hd) ? mem : alu;
endmodule


module BubbleCntrl (
   input [7:0] ins_ahead,
   input [7:0] ins_follow,
   input clk,
   output reg pc_en
);
always @(negedge clk) begin 
  if (ins_ahead[7:4] === 4'hd  && 
      (ins_follow[7:4] == 4'h1 || 
       ins_follow[7:4] == 4'h2 || 
       ins_follow[7:4] == 4'h3 || 
       ins_follow[7:4] == 4'h4 || 
       ins_follow[7:4] == 4'h5 )  && 
      ((ins_ahead[3:2] == ins_follow[3:2]) ||  
       (ins_ahead[3:2] == ins_follow[1:0]))) begin
          pc_en <= 1'b0; // Bubble detected, PC stall
          $display("bubble check ------");
        end
  else begin
    pc_en <= 1'b1;
  end
end
endmodule


module WB_DM_ForwardCntrl (

);
  
endmodule

module EXE_ForwardCntrl (

);
  
endmodule

// Multiplexor of 3 -> 1
module Mux_3_to_1 (
  input [7:0] in0,
  input [7:0] in1,
  input [7:0] in2, 
  input [1:0] sel,
  output [7:0] dout
);

assign dout = (sel == 2'b00) ? in0 : 
              (sel == 2'b01) ? in1 : in2;       
endmodule

// Two to One Multiplexor
module Mux_2_to_1(
  input sel, // Selection input
  input [7:0] din0, // Input 0
  input [7:0] din1, // Input 1
  output [7:0] dout // Output
);
assign dout = sel ? din1 : din0;
endmodule