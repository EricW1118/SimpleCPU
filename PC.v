// Module for
module ProgramCounter (
    input [7:0] addi,
	 input we,
    output reg [7:0] addo 
);

always@(*) begin
	if (we) begin 
		addo <= addi;
	end
end


endmodule