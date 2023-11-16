// ---------------------------------Data memory-------------------------------------------------
module DataMemory(
    input wire [7:0] addr, // Address input (8 bits)
    input wire we, // Write enable signal
    input wire [7:0] din, // Data input (8 bits)
    output [7:0] dout // Data output (8 bits)
);
reg [7:0] memory[0:255]; // Array of 256 memory locations, each 8 bits wide
always @ (*) begin
    if (we) begin
        memory[addr] <= din;
    end
end
assign dout = memory[addr];
endmodule


// ---------------------------------Instruction memory------------------------------------------
module InstructionMemory(
    input [7:0] addr, // Address input (8 bits)
    output reg [15:0] ins, // Instruction output (16 bits)

    // This is for testing
    input [15:0] wd,
    input we,
    input clk
);

// Array of 256 memory locations, each 8 bits wide
reg [7:0] memory[0:255]; 

// Memory
always @ (addr) begin
    ins <= {memory[addr], memory[addr + 1'b1]};
end

// Only for test
always @(posedge clk) begin
    if (we) begin
        memory[addr] <= wd[15:8];
        memory[addr + 1'b1] <= wd[7:0];
    end
end

endmodule