// ---------------------------------Instruction memory------------------------------------------
module InstructionMemory(
    input [7:0] addr, // Address input (8 bits)
    input rst,
    output [15:0] ins // Instruction output (16 bits)
);
// Array of 256 memory locations
reg [7:0] memory[0:255];

integer i;
initial begin
    for (i = 0; i < 256; i = i + 1) begin
        memory[i] <= 8'h0;
    end
end

always @(negedge rst) begin
    if (~rst) begin
        memory[0] <= 8'b00000000;  //nop
        memory[1] <= 8'b00000000;
        memory[2] <= 8'b00000000;	 //nop
        memory[3] <= 8'b00000000;
        memory[4] <= 8'b01110000;  // in		r0   //set the switches on the bord to 4'hF
        memory[5] <= 8'b00000000;
        memory[6] <= 8'b11100000;	 //store		r0,add_nand
        memory[7] <= 8'b11111111;  
        memory[8] <= 8'b11110000;	 // loadimm		r0,7
        memory[9] <= 8'b00000111;
        memory[10] <= 8'b11100000; // store		r0,counter
        memory[11] <= 8'b00011111;
        memory[12] <= 8'b11110000; // loadimm 	r0,FF
        memory[13] <= 8'b11111111;
        memory[14] <= 8'b11110100;  //loadimm		r1,FF
        memory[15] <= 8'b11111111;
        memory[16] <= 8'b01010000;  //shr		r0  loop
        memory[17] <= 8'b00000000;
        memory[18] <= 8'b01000100;  //shl		r1
        memory[19] <= 8'b00000000;
        memory[20] <= 8'b10001100;  //mov		r3,r0 		
        memory[21] <= 8'b00000000;
        memory[22] <= 8'b11010000;   //load		r0,add_nand
        memory[23] <= 8'b11111111;
        memory[24] <= 8'b01010000;	//shr		r0
        memory[25] <= 8'b00000000;
        memory[26] <= 8'b11100000;	//store		r0,add_nand
        memory[27] <= 8'b11111111;
        memory[28] <= 8'b10000011;	//mov		r0,r3		
        memory[29] <= 8'b00000000;
        memory[30] <= 8'b10100000;	//brz		nand: 
        memory[31] <= 8'b00100100;
        memory[32] <= 8'b00010001;	//add		r0,r1        
        memory[33] <= 8'b00000000;
        memory[34] <= 8'b10010000;	//br		out_add_nand	    
        memory[35] <= 8'b00100110;
        memory[36] <= 8'b00110001;	//nand		r0,r1	nand:
        memory[37] <= 8'b00000000;
        memory[38] <= 8'b01100000;	//out		r0  out_add_nand:
        memory[39] <= 8'b00000000;
        memory[40] <= 8'b10110000;	//br.sub          count_decrement_subroutine
        memory[41] <= 8'b00110100;
        memory[42] <= 8'b10000011;	//mov		r0,r3		
        memory[43] <= 8'b00000000;
        memory[44] <= 8'b10100100;	//brn		out
        memory[45] <= 8'b00110000;
        memory[46] <= 8'b10010000;	//br		loop      
        memory[47] <= 8'b00010000;
        memory[48] <= 8'b10010000;	//br		start  out:
        memory[49] <= 8'b00000100;
        memory[50] <= 8'b00000000;	//noop
        memory[51] <= 8'b00000000;
        memory[52] <= 8'b11010000;	//load		r0,counter  count_decrement_subroutine:
        memory[53] <= 8'b00011111;
        memory[54] <= 8'b10001001;	//mov		r2,r1		
        memory[55] <= 8'b00000000;
        memory[56] <= 8'b11110100;	//loadimm		r1,1
        memory[57] <= 8'b00000001;
        memory[58] <= 8'b00100001;	//sub		r0,r1
        memory[59] <= 8'b00000000;
        memory[60] <= 8'b11100000;	//store		r0,counter
        memory[61] <= 8'b00011111;
        memory[62] <= 8'b10000110;	//mov		r1,r2		
        memory[63] <= 8'b00000000;
        memory[64] <= 8'b11000000;   // return
        memory[65] <= 8'b00000000;
    end
end

assign ins = {memory[addr + 1], memory[addr]};
endmodule

// ---------------------------------Data memory-------------------------------------------------
module DataMemory(
    input [7:0] raddr, // Address input (8 bits)
    input [7:0] waddr,
    input we, // Write enable signal
    input clk,
    input [7:0] din, // Data input (8 bits)
    output [7:0] dout // Data output (8 bits)
);
// Data memory should be used after being allocated and initialized, therefore, we do not need initial values.
reg [7:0] memory[0:255];

integer  i;
initial begin
    for (i = 0; i < 256; i = i + 1) begin
        memory[i] <= 8'h0;
    end
end

always @ (negedge clk) begin
    if (we) begin
        memory[waddr] <= din;
    end
end
assign dout = memory[raddr];
endmodule