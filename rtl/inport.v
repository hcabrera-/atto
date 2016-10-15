module inport #(parameter X_LOCAL = 2, parameter Y_LOCAL = 2)
  (
      input   wire clka,
      input   wire rsta,

      input   wire [1:0]  diff_pair_din,
      input   wire [47:0] channel_din,

      output  wire        request_dout,

      output  wire        x_hit_dout,
      output  wire        y_hit_dout,

      output  wire [47:0] packet_dout
  );


// Segmentation Registers
reg [47:0]  input_pipe_reg = 48'b0;

always @(posedge clka)
  if (request_unreg)
    input_pipe_reg <= channel_din;

// Register for arbitration request
reg request_reg;

always @(posedge clka)
  request_reg <= request_unreg;


// Port flow_handler
wire  request_unreg;

input_flow_handler inport_flow_handler
  	(
  		.clka       (clka),
  		.rsta       (rsta),

  		.diff_pair_p(diff_pair_din[1]),
  		.diff_pair_n(diff_pair_din[0]),

  		.pipe_en    (request_unreg)
  	); // flow_handler


// Registered outputs
assign packet_dout  = input_pipe_reg[47:0];
assign request_dout = request_reg;

// Derived outputs
assign x_hit_dout = (input_pipe_reg[47:44] == X_LOCAL) ? 1'b1 : 1'b0;
assign y_hit_dout = (input_pipe_reg[43:40] == Y_LOCAL) ? 1'b1 : 1'b0;

endmodule
