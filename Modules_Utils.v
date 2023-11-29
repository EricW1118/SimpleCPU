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
    lr_we <= (op == 4'hb) ? 1'b1 : 1'b0; //BR.SUB
    if (op == 4'hc) begin  //RETURN
      pc_sec <= 2'b10;
      $display("return branch jump");
    end
    else if (op == 4'h9) begin //BR
      pc_sec <= 2'b01;
      $display("branch jump");
    end
    else if ({op, brx, ZN[1]} == 6'b101001) begin //BR.Z
      pc_sec <= 2'b01;
      $display("branch Z jump");
    end
    else if ({op, brx, ZN[0]} == 6'b101011) begin //BR.N
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
    input clk,
    output reg [7:0] out = 8'h0
);

always @(negedge clk) begin 
  if (op == 4'b0110) begin
    out <= ra;
  end
end
endmodule

// Write back control
module WBCntrl (
  input [7:0] alu,
  input [7:0] mem,
  input [3:0] op,
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
assign wbdata = (op == 4'hd) ? mem : alu; // LOAD
endmodule

module BubbleCntrl (
   input [7:0] ins_ahead,
   input [7:0] ins_follow,
   input clk,
   output reg pc_en
);

function is_read_ra(input [3:0] op);
  begin
    is_read_ra = (op == 4'h1 || //ADD
                  op == 4'h2 || //SUB
                  op == 4'h3 || //NAND
                  op == 4'h4 || //SHL
                  op == 4'h5 || //SHR
                  op == 4'h6 || //OUT
                  op == 4'he) ? 1'b1 : 1'b0;   //STORE
  end
endfunction 

function is_read_rb (input [3:0] op);
  begin
    is_read_rb = (op == 4'h1 || //ADD
                  op == 4'h2 || //SUB
                  op == 4'h3 || //NAND
                  op == 4'h8) ? 1'b1 : 1'b0; //MOV
  end
endfunction

// Load followed by another instruction
always @(negedge clk) begin 
  if ( ins_ahead[7:4] == 4'hd && 
       (is_read_ra(ins_follow[7:4]) && ins_ahead[3:2] == ins_follow[3:2])) begin
        pc_en <= 1'b0; // Bubble inserted, PC stall
  end
  else if (ins_ahead[7:4] == 4'hd && 
           (is_read_rb(ins_follow[7:4]) && ins_ahead[3:2] == ins_follow[1:0])) begin
        pc_en <= 1'b0; // Bubble inserted, PC stall
  end
  else begin
    pc_en <= 1'b1;
  end
end
endmodule

module DMWriteCntrl ( 
  input [3:0] op,
  output dm_en
);
assign dm_en = (op === 4'he) ? 1'b1 : 1'b0; // STORE
endmodule

// Handle EXE to EXE forwarding
module ForwardCntrl (
  input [15:0] exeout_ahead,
  input [15:0] dmout_ahead,
  input [15:0] ins_follow,
  input [7:0] ra,
  input [7:0] rb,
  input [7:0] alu_result,
  input [7:0] mem_out,
  output [7:0] rao,
  output [7:0] rbo
);

function  is_write_ra (input [3:0] op); 
  is_write_ra =  (op == 4'h1 ||
                  op == 4'h2 ||
                  op == 4'h3 ||
                  op == 4'h4 ||
                  op == 4'h5 ||
                  op == 4'h7 ||
                  op == 4'h8 ||
                  op == 4'hf) ? 1'b1 : 1'b0;
endfunction

function  is_read_ra (input [3:0] op); 
  is_read_ra = (op == 4'h1 ||
                op == 4'h2 ||
                op == 4'h3 ||
                op == 4'h4 ||
                op == 4'h5 ||
                op == 4'h6 || 
                op == 4'he) ? 1'b1 : 1'b0;
endfunction

function  is_read_rb (input [3:0] op); 
  is_read_rb = (op == 4'h1 ||
                op == 4'h2 ||
                op == 4'h3 ||
                op == 4'h8) ? 1'b1 : 1'b0;
endfunction

function is_load (input [3:0] op );
  is_load = (op == 4'hd) ? 1'b1 : 1'b0;
endfunction

assign rao = (is_load(dmout_ahead[7:4]) && is_read_ra(ins_follow[7:4]) && (dmout_ahead[3:2] == ins_follow[3:2])) ? mem_out : 
             (is_write_ra(exeout_ahead[7:4]) && is_read_ra(ins_follow[7:4]) && (exeout_ahead[3:2] == ins_follow[3:2])) ? alu_result : ra;

assign rbo = (is_load(dmout_ahead[7:4]) && is_read_rb(ins_follow[7:4]) && (dmout_ahead[3:2] == ins_follow[1:0])) ? mem_out :
             (is_write_ra(exeout_ahead[7:4]) && is_read_rb(ins_follow[7:4]) && (exeout_ahead[3:2] == ins_follow[1:0])) ? alu_result : rb;
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