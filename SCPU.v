// The original CPU design
module SCPU (
    input [7:0] ext_in,
    input clk,
    input rst,
    output [7:0] ext_out
);
    wire [7:0] pc_out_wire;
    wire [7:0] pc_in;
    wire pc_en;

    ProgramCounter pc(.addi(pc_in), .clk(clk), .rst(rst), .we(pc_en), .addo(pc_out_wire));

    wire [7:0] adder_out_wire;
    assign adder_out_wire = pc_out_wire + 8'h02; // address increment +2
    wire lr_en;
    wire [7:0] lr_out_wire;
    LR ilocker(.sub_addi(pc_out_wire), .we(lr_en), .sub_addo(lr_out_wire));

    // selection signal for pc input
    wire[1:0] pc_mux_sel;

    // Wires between stage registers
    wire [15:0] w_ins0, w_ins1, w_ins2, w_ins3, w_ins4;

    // 00: pc + 2, 01: immediate, 10: LR
    Mux_3_to_1 pc_mux(.in0(adder_out_wire), .in1(w_ins1[15:8]), .in2(lr_out_wire), 
                      .sel(pc_mux_sel), .dout(pc_in));

    // access instruction memory
    InstructionMemory im(.addr(pc_out_wire), .rst(rst), .ins(w_ins0));

    //bubble enable is the opposite of pc enable
    wire bubble_en;
    assign bubble_en = ~pc_en;
    wire brach_wire;

    //IF/ID stage register
    IF_ID sreg0(.insi(w_ins0), .inso(w_ins1), .rst(rst), .bubble_en(bubble_en), .branch_en(brach_wire), .clk(clk));

    //Bubble Cntrl
    BubbleCntrl bbcntrl(.ins_ahead(w_ins1[7:0]), .ins_follow(w_ins0[7:0]), .clk(clk), .pc_en(pc_en));

    //Branch control unit
    wire [1:0] zn_wire;
    BranchCntrl bcntrl(.ZN(zn_wire), .op(w_ins1[7:4]), .brx(w_ins1[3]), .lr_we(lr_en), .pc_sec(pc_mux_sel), .is_branch(brach_wire));

    // values of ra and rb between stages
    wire [15:0] vfr0, vfr1, vfr2;
    wire [7:0] main_rf_data_in;
    wire main_rf_we;

    // Main register
    MainRegister mrf(.rst(rst), .clk(clk), .we(main_rf_we), .rd1(w_ins1[3:2]), .rd2(w_ins1[1:0]), .wd(w_ins4[3:2]), 
                     .din(main_rf_data_in),.ra(vfr0[15:8]), .rb(vfr0[7:0]));

    // ID/EXE register
    ID_EXE sreg1(.insi(w_ins1), .regDi(vfr0), .clk(clk), .rst(rst), .inso(w_ins2),  .regDo(vfr1));

    wire [7:0] aluo0, aluo1, aluo2;
    wire [7:0] fw_ra, fw_rb;
    ALU alu(.ex_in(ext_in), .imm(w_ins2[15:8]), .s1(fw_ra),  .s2(fw_rb), 
            .op(w_ins2[7:4]), .clk(clk), .result(aluo0), .ZN(zn_wire));

    EXE_DM sreg2(.insi(w_ins2), .regDi(vfr1), .alui(aluo0), .clk(clk), 
                 .rst(rst), .inso(w_ins3), .regDo(vfr2), .aluo(aluo1));

    wire [7:0] memo0, memo1;
    wire dm_en;
    DMWriteCntrl dmcnt(.op(w_ins3[7:4]), .dm_en(dm_en));
    DataMemory dm(.raddr(w_ins3[15:8]), .waddr(w_ins3[15:8]), 
                  .we(dm_en), .din(aluo1), .clk(clk), .dout(memo0));

    // DM/WB register
    DM_WB sreg3(.insi(w_ins3), .alui(aluo1), .memi(memo0), 
                .clk(clk), .rst(rst), .inso(w_ins4), .aluo(aluo2), .memo(memo1));

    // Forwarding control for DM to EXE, EXE to EXE
    ForwardCntrl fcntrl(.exeout_ahead(w_ins3), .dmout_ahead(w_ins4), .ins_follow(w_ins2), 
                        .ra(vfr1[15:8]), .rb(vfr1[7:0]), .alu_result(aluo1), .dm_alu_out(aluo2), .dm_mem_out(memo1), .rao(fw_ra), .rbo(fw_rb));

    ExtOutCntrl extrl(.ra(aluo2), .op(w_ins4[7:4]), .clk(clk), .out(ext_out));
    
    WBCntrl wbcntr(.alu(aluo2), .mem(memo1), .op(w_ins4[7:4]), 
                   .wbdata(main_rf_data_in), .rfwe(main_rf_we));
endmodule

 

