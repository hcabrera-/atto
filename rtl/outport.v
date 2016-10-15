module outport
  (
      input   wire clka,
      input   wire rsta,

      input  wire        toggle_din,
      input  wire [47:0] crossbar_din,

      output wire [1:0]  diff_pair_dout,
      output wire [47:0] channel_dout
  );


// Segmentation Registers
reg [47:0]  output_pipe_reg = 48'b0;

always @(posedge clka)
  if (toggle_din)
    output_pipe_reg <= crossbar_din;

assign channel_dout = output_pipe_reg;

// output_flow_handler
output_flow_handler output_flow_handler
	(
		.clka(clka),
		.rsta(rsta),

		.toggle(toggle_din),

		.diff_pair_p(diff_pair_dout[1]),
    .diff_pair_n(diff_pair_dout[0])
	);

endmodule
