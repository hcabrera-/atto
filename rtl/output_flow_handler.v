module output_flow_handler
	(
		input	wire clka,
		input	wire rsta,

		input	wire toggle,

		output	wire diff_pair_p,
    output	wire diff_pair_n
	);


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
				if (toggle)
					begin
						diff_pair_p_reg <= ~diff_pair_p_reg;
						diff_pair_n_reg <= ~diff_pair_n_reg;
					end
			end
	end


// output assign
assign diff_pair_p = diff_pair_p_reg;
assign diff_pair_n = diff_pair_n_reg;

endmodule// flow_handler
