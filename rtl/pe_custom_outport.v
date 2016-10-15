module pe_custom_outport
  (
      input   wire clka,
      input   wire rsta,

      input  wire        r2pe_ack_din,
      input  wire        toggle_din,
      input  wire [39:0] crossbar_din,

      output wire        r2pe_ack_dout,
      output wire [1:0]  diff_pair_dout,
      output wire [39:0] channel_dout
  );


// Segmentation Registers
reg [39:0]  output_pipe_reg = 40'b0;
reg         r2pe_ack_reg    =  1'b0;


always @(posedge clka)
  if (toggle_din)
    begin
      output_pipe_reg <= crossbar_din;
      r2pe_ack_reg    <= r2pe_ack_din;
    end

assign channel_dout  = output_pipe_reg;
assign r2pe_ack_dout = r2pe_ack_reg;

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
