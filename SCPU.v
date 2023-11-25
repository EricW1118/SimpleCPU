module SCPU (
    input [7:0] ext_in,
    input clk,
    input rst,
    output [7:0] ext_out
);
    wire [7:0] pc_out_wire;
    wire [7:0] pc_in;
    wire pc_en;

    ProgramCounter pc(.addi(pc_in), .clk(clk), .rst(rst), .addo(pc_out_wire));

    wire [7:0] adder_out_wire;
    EightBitAdder adder2(.a(8'h02), .b(pc_out_wire), .sum(adder_out_wire));

    wire lr_en;
    wire [7:0] lr_out_wire;
    LR ilocker(.in(adder_out_wire), .we(lr_en), .rst(rst), .out(lr_out_wire));

    // selection signal for pc input
    wire[1:0] pc_mux_sel;

    // Wires between stage registers
    wire [15:0] w_ins0, w_ins1, w_ins2, w_ins3, w_ins4;

    // 00: pc + 2, 01: immediate, 10: LR
    Mux_3_to_1 pc_mux(.in0(adder_out_wire), .in1(w_ins1[15:8]), .in2(lr_out_wire), .sel(pc_mux_sel), .dout(pc_in));

    // access instruction memory
    InstructionMemory im(.addr(pc_out_wire), .rst(rst), .ins(w_ins0));

    //IF/ID stage register
    IF_ID sreg0(.insi(w_ins0), .inso(w_ins1), .rst(rst), .clk(clk));

    //Branch control unit
    wire [1:0] zn_wire;
    BranchCntrl bcntrl(.ZN(zn_wire), .op(w_ins1[7:4]), .brx(w_ins1[3]), .pc_sec(pc_mux_sel), .lr_we(lr_en), .pc_en(pc_en));

    // values of ra and rb between stages
    wire [15:0] vfr0, vfr1, vfr2;
    wire [7:0] main_rf_data_in;
    wire main_rf_we;

    // Main register
    MainRegister mrf(.rst(rst), .we(main_rf_we), .rd1(w_ins1[3:2]), .rd2(w_ins1[1:0]), .wd(w_ins4[3:2]), 
                     .din(main_rf_data_in),.dout1(vfr0[15:8]), .dout2(vfr0[7:0]));

    // ID/EXE register
    ID_EXE sreg1(.insi(w_ins1), .din(vfr0), .clk(clk), .rst(rst), .inso(w_ins2),  .dout(vfr1));

    wire [7:0] aluo0, aluo1, aluo2;
    ALU alu(.ex_in(ext_in), .imm(w_ins2[15:8]), .s1(vfr1[15:8]),  .s2(vfr1[7:0]), .mode(w_ins2[7:4]), .result(aluo0), .ZN(zn_wire));
    EXE_DM sreg2( .insi(w_ins2), .din(vfr1), .alui(aluo0), .clk(clk), .rst(rst), .inso(w_ins3), .dout(vfr2), .aluo(aluo1));

    wire [7:0] memo0, memo1;
    wire dm_en;
    DataMemory dm(.addr(w_ins3[15:8]), .we(dm_en), .din(aluo1), .rst(rst), .dout(memo0));

    // DM/WB register
    DM_WB sreg3(.insi(w_ins3), .din(vfr2), .alui(aluo1), .memi(memo0), .clk(clk), .inso(w_ins4), .aluo(aluo2), .memo(memo1));
    ExtOutCntrl extrl(.ra(aluo2), .op(w_ins4[7:4]), .out(ext_out));

    WBCntrl wbcntr(.alu(aluo2), .mem(memo1), .op(w_ins4[7:4]), .wbdata(main_rf_data_in), .rfwe(main_rf_we));

endmodule

 

