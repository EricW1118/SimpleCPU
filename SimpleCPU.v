// This is final block
module SCPU ( input [7:0] ins, input clk, input rst, output [7:0] res );

wire [7:0] pc_to_im;
wire [15:0] im_to_id;
ProgramCounter pc(.addi(ins), .addo(pc_to_im) );
InstructionMemory ins_mem(.addr(pc_to_im), .ins(im_to_id));

wire[3:0] w_op;
wire[1:0] w_ra, w_rb;
wire[7:0] imme;

RF_IF_ID if_id(.insi(im_to_id), .inso({w_op,w_ra,w_rb,imme}), .clk(clk), .we(1'b1));
MainRegister mrf(.re(), .rd1(w_ra), .rd2(w_rb), .wd(), .din(), .dout1(), .dout2()); 

endmodule