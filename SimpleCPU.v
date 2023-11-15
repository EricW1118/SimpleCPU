// This is final block
module SCPU ( input [7:0] ins_index, input clk, output [7:0] res );

// wire between instruction memory and IF/ID stage register
wire [15:0] w_ins0;
// access instruction memory
InstructionMemory ins_mem(.addr(ins_index), .ins(w_ins0));
wire [15:0] w_ins1;
// IF/ID stage register
RfIfId ifid(.insi(w_ins0), .inso(w_ins1), .clk(clk), .we(1'b1));
// values of ra and rb
wire [15:0] vfr1;
// Main register
MainRegister mrf(.we(1'b1), .rd1(w_ins1[11:10]), .rd2(w_ins1[9:8]), .wd(0), .din(0), .dout1(vfr1[15:8]), .dout2(vfr1[7:0])); 

wire [15:0] w_ins2;
wire [15:0] vfr2;

// ID/EXE register
RfIdExe idExe(.insi(w_ins1),.din(vfr1), .clk(clk), .inso(w_ins2), .dout(vfr2));

wire [7:0] alu_o1;
// ALU
ALU alu( .s1(vfr2[15:8]), .s2(vfr2[7:0]), .mode(w_ins2[15:12]), .result(alu_o1));

wire [15:0] w_ins3;
wire [15:0] vfr3;
wire [7:0] alu_o2;

RfExeDm ms( .insi(w_ins2), .din(vfr2), .alui(alu_o1), .clk(clk), 
    .inso(w_ins3),  .dout(vfr3), .aluo(alu_o2));

wire [7:0] mem_o;
// Data memory
DataMemory dm(.addr(w_ins3[7:0]), .we(2'b01), .din(alu_o2), .dout(mem_o));

// DM/WB register
RfDmWb dwb(.insi(w_ins3), .din(vfr3), .alui(alu_o2), .memi(mem_o), .clk(clk), .inso(), .dout(), .aluo(res), .memo());
endmodule