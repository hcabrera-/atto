// Xilinx Only
// TODO ifdef to add  it only on Xilinx
// (* LUT_MAP="yes" *)

module input_flow_handler
	(
		input	wire clka,
		input	wire rsta,

		input	wire diff_pair_p,
		input	wire diff_pair_n,

		output	wire pipe_en
	);


// Pipe Enable Signal
wire 		pipe_enable;
assign 	pipe_enable = ((diff_pair_p ^ diff_pair_p_reg) & (diff_pair_n ^ diff_pair_n_reg)) ? 1'b1 : 1'b0;
assign	pipe_en = pipe_enable;


// Memory Element
reg	diff_pair_p_reg = 1'b1;
reg	diff_pair_n_reg = 1'b0;

always @(posedge clka)
	begin
		if (rsta)
			begin
				diff_pair_p_reg <= 1'b1;
				diff_pair_n_reg <= 1'b0;
 			end
		else
			begin
				if (pipe_enable)
					begin
						diff_pair_p_reg <= ~diff_pair_p_reg;
						diff_pair_n_reg <= ~diff_pair_n_reg;
					end
			end
	end


endmodule// flow_handler
