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
    input wire [7:0] addr, // Address input (8 bits)
    output reg [15:0] ins // Instruction output (16 bits)
);

// Array of 256 memory locations, each 8 bits wide
reg [7:0] memory[0:255]; 

// Initializing the first row of memory with zero instruction, doing nothing
initial begin
    memory[0:255] = 8'h00; // Default instruction is 00, nothing
end

// Memory
always @ (addr) begin
    ins <= {memory[addr], memory[addr + 1'b1]};
end

endmodule