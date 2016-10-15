module crossbar
	(
		input 	wire [47:0]	  north_channel,
		input 	wire [47:0]	  east_channel,
		input 	wire [47:0]	  pe_in_channel,

	// LSB selects between North and East inports
	// MSB selects between PE and the selection between North and East
		input	wire [1:0]	south_ctrl,
		input	wire [1:0]	west_ctrl,
		input	wire 				pe_out_ctrl,

		output	wire [47:0]	  south_channel,
		output	wire [47:0]	  west_channel,
		output	wire [39:0]	  pe_out_channel
	);



// South outport
	wire [47:0] south_mux0_output;

	m21x48 m21x48_south_mux0(
		.sel	(south_ctrl[0]),
		.a		(north_channel),
		.b		(east_channel),

		.o		(south_mux0_output)
	); // m21x48_south_mux0

	m21x48 m21x48_south_mux1(
		.sel	(south_ctrl[1]),
		.a		(pe_in_channel),
		.b		(south_mux0_output),

		.o		(south_channel)
	); // m21x48_south_mux1


// West outport
	wire [47:0] west_mux0_output;

	m21x48 m21x48_west_mux0(
		.sel	(west_ctrl[0]),
		.a		(north_channel),
		.b		(east_channel),

		.o		(west_mux0_output)
	); // m21x48_west_mux0

	m21x48 m21x48_west_mux1(
		.sel	(west_ctrl[1]),
		.a		(pe_in_channel),
		.b		(west_mux0_output),

		.o		(west_channel)
	); // m21x48_west_mux1


// PE outport
	m21x40 m21x40_pe(
		.sel	(pe_out_ctrl),
		.a		(north_channel[39:0]),
		.b		(east_channel[39:0]),

		.o		(pe_out_channel)
	); // m21x48_pe


endmodule
