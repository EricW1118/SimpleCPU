module SCPU (
    input [7:0] ext_in,
    input clk,
    input rst,
    input [7:0] ext_out
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

endmodule
 
    // // values of ra and rb between stages
    // wire [15:0] vfr1, vfr2, vfr3;
    // wire [7:0] main_rf_data_in;
    // wire main_rf_we;
    // wire [1:0] rf_write_destination;

    // // Main register
    // MainRegister mrf(.rst(rst), .we(main_rf_we), .rd1(w_ins1[3:2]), .rd2(w_ins1[1:0]), .wd(rf_write_destination), 
    //                  .din(main_rf_data_in),.dout1(vfr1[15:8]), .dout2(vfr1[7:0]));

    // // ID/EXE register
    // RfIdExe sreg1(.insi(w_ins1), .din(vfr1), .clk(clk), .rst(rst), .inso(w_ins2),  .dout(vfr2));

    // wire [7:0] alu_o1, alu_o2, alu_o3;

    // ALU alu( .ex_in(ex_in), .s1(vfr2[15:8]),  .s2(vfr2[7:0]), .mode(w_ins2[7:4]), .result(alu_o1), .ZN(zn_wire));

    // RfExeDm sreg2( .insi(w_ins2), .din(vfr2), .alui(alu_o1), .clk(clk), .rst(rst), .inso(w_ins3), .dout(vfr3), .aluo(alu_o2));

    // wire [7:0] mem_o1;
    
    // // Data memory
    // DataMemory dm(.addr(w_ins3[15:8]), .we(1'b0), .din(alu_o2), .rst(rst), .dout(mem_o1));

    // wire [7:0] mem_o2;

    // // DM/WB register
    // RfDmWb sreg3(
    //     .insi(w_ins3),
    //     .din(vfr3), 
    //     .alui(alu_o2), 
    //     .memi(mem_o1),
    //     .clk(clk), 
    //     .inso(w_ins4), 
    //     .dout(), 
    //     .aluo(res), 
    //     .memo(mem_o2));


    // wire [7:0] alu_o1, alu_o2;
    // wire [7:0] alu_mux_out;
    // wire [1:0] alu_mux_sel;

    // AluInputCntrl alcn(
    //     .cur_ins(w_ins2),
    //     .pre_ins(w_ins3),
    //     .sel(alu_mux_sel));

    // Mux_3_to_1 alu_in_mux(
    //     .in0(vfr2[15:8]), // original input
    //     .in1(alu_o2),     // dataforwarding
    //     .in2(ex_in),      // external input
    //     .sel(alu_mux_sel), 
    //     .dout(alu_mux_out));



    // Mux_2_to_1 wb_mux(
    //     .sel(), 
    //     .din0(mem_out_wire), 
    //     .din1(res), 
    //     .dout(main_rf_data_in));


    // ExternalOutCntrl eo(
    //     .ra(vfr1[15:8]),
    //     .op(w_ins4[7:4]), 
    //     .out(ext_out));

