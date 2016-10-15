module router #(parameter X_LOCAL = 2, parameter Y_LOCAL = 2)
  (
    input   wire clka,
    input   wire rsta,

    // input channels
      input wire [47:0] north_channel_din,
      input wire [1:0]  north_diff_pair_din,
      input wire [47:0] east_channel_din,
      input wire [1:0]  east_diff_pair_din,
      input wire [47:0] pe_channel_din,
      input wire [1:0]  pe_diff_pair_din,

    // output channels
      output wire [47:0]  south_channel_dout,
      output wire [1:0]   south_diff_pair_dout,
      output wire [47:0]  west_channel_dout,
      output wire [1:0]   west_diff_pair_dout,
      output wire [39:0]  pe_channel_dout,
      output wire [1:0]   pe_diff_pair_dout,
      output wire         r2pe_ack_dout
  );

//
//  router top level
//  module dependencies
//    3 x inport
//    1 x arbiter
//    1 x crossbar
//    2 x outport
//    1 x pe custom outport
//

// inports ---------------------------------- //////////////////////////////////

  // north inport --------------------------- //////////////////////////////////
  wire [2:0]  north_request_bundle;
  wire [47:0] north_packet_reg;


    inport  #(
              .X_LOCAL  (X_LOCAL),
              .Y_LOCAL  (Y_LOCAL)
            )
    north_inport
      (
          .clka (clka),
          .rsta (rsta),

          .diff_pair_din  (north_diff_pair_din),
          .channel_din    (north_channel_din),

          .request_dout   (north_request_bundle[0]),

          .x_hit_dout     (north_request_bundle[2]),
          .y_hit_dout     (north_request_bundle[1]),

          .packet_dout    (north_packet_reg)
      ); // north inport


  // east inport ---------------------------- //////////////////////////////////
  wire [2:0]  east_request_bundle;
  wire [47:0] east_packet_reg;

    inport  #(
              .X_LOCAL  (X_LOCAL),
              .Y_LOCAL  (Y_LOCAL)
            )
    east_inport
      (
          .clka (clka),
          .rsta (rsta),

          .diff_pair_din  (east_diff_pair_din),
          .channel_din    (east_channel_din),

          .request_dout   (east_request_bundle[0]),

          .x_hit_dout     (east_request_bundle[2]),
          .y_hit_dout     (east_request_bundle[1]),

          .packet_dout    (east_packet_reg)
      ); // east inport


  // pe inport ------------------------------ //////////////////////////////////
  wire [2:0]  pe_request_bundle;
  wire [47:0] pe_packet_reg;

  inport  #(
            .X_LOCAL  (X_LOCAL),
            .Y_LOCAL  (Y_LOCAL)
          )
  pe_inport
    (
        .clka (clka),
        .rsta (rsta),

        .diff_pair_din  (pe_diff_pair_din),
        .channel_din    (pe_channel_din),

        .request_dout   (pe_request_bundle[0]),

        .x_hit_dout     (pe_request_bundle[2]),
        .y_hit_dout     (pe_request_bundle[1]),

        .packet_dout    (pe_packet_reg)
    ); // pe inport

// arbiter ---------------------------------- //////////////////////////////////
wire [1:0] pe_cfg_bundle;
wire [2:0] south_cfg_bundle;
wire [2:0] west_cfg_bundle;
wire    r2pe_ack;

  arbitro arbiter(
    // Request bundles are composed by:
    //    * request_bundle[2] :: hit_x
    //    * request_bundle[1] :: hit_y
    //    * request_bundle[0] :: request
      .pe_request_bundle    (pe_request_bundle),
      .north_request_bundle (north_request_bundle),
      .east_request_bundle  (east_request_bundle),

    // Configuration bundles are composed by:
    //    * cfg_bundle[2] :: mux_ctrl[1]
    //    * cfg_bundle[1] :: mux_ctrl[0]
    //    * cfg_bundle[0] :: toggle

      .pe_cfg_bundle        (pe_cfg_bundle),
      .south_cfg_bundle     (south_cfg_bundle),
      .west_cfg_bundle      (west_cfg_bundle),

    // ACK that a request from the PE has been accepted
        .r2pe_ack           (r2pe_ack)
  );

// crossbar --------------------------------- //////////////////////////////////
wire [47:0] south_packet_out;
wire [47:0] west_packet_out;
wire [39:0] pe_packet_out;

  crossbar  crossbar
  	(
  		.north_channel  (north_packet_reg),
  		.east_channel   (east_packet_reg),
  		.pe_in_channel  (pe_packet_reg),

  	// LSB selects between North and East inports
  	// MSB selects between PE and the selection between North and East
  		.south_ctrl     (south_cfg_bundle[2:1]),
  		.west_ctrl      (west_cfg_bundle[2:1]),
  		.pe_out_ctrl    (pe_cfg_bundle[1]),

  		.south_channel   (south_packet_out),
  		.west_channel    (west_packet_out),
  		.pe_out_channel  (pe_packet_out)
  	);
// outports --------------------------------- //////////////////////////////////

  // south outport -------------------------- //////////////////////////////////


    outport south_outport
      (
          .clka (clka),
          .rsta (rsta),

          .toggle_din     (south_cfg_bundle[0]),
          .crossbar_din   (south_packet_out),

          .diff_pair_dout (south_diff_pair_dout),
          .channel_dout   (south_channel_dout)
      );

  // west outport --------------------------- //////////////////////////////////
    outport west_outport
      (
          .clka (clka),
          .rsta (rsta),

          .toggle_din     (west_cfg_bundle[0]),
          .crossbar_din   (west_packet_out),

          .diff_pair_dout (west_diff_pair_dout),
          .channel_dout   (west_channel_dout)
      );

  // pe custom outport ---------------------- //////////////////////////////////
  pe_custom_outport pe_outport
    (
      .clka (clka),
      .rsta (rsta),

        .r2pe_ack_din   (r2pe_ack),
        .toggle_din     (pe_cfg_bundle[0]),
        .crossbar_din   (pe_packet_out),

        .r2pe_ack_dout  (r2pe_ack_dout),
        .diff_pair_dout (pe_diff_pair_dout),
        .channel_dout   (pe_channel_dout)
    );

endmodule
