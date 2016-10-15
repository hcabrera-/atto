`timescale 1ns/1ns

module arbiter_tb();

// Request bundles are composed by:
//    * request_bundle[2] :: hit_x
//    * request_bundle[1] :: hit_y
//    * request_bundle[0] :: request
  reg [2:0] pe_request_bundle;
  reg [2:0] north_request_bundle;
  reg [2:0] east_request_bundle;

// Configuration bundles are composed by:
//    * cfg_bundle[2] :: mux_ctrl[1]
//    * cfg_bundle[1] :: mux_ctrl[0]
//    * cfg_bundle[0] :: toggle

  wire [1:0] pe_cfg_bundle;
  wire [2:0] south_cfg_bundle;
  wire [2:0] west_cfg_bundle;

// ACK that a request from the PE has been accepted
  wire      r2pe_ack;

// localparam

localparam  MUX_EAST  = 3'b011;
localparam  MUX_NORTH = 3'b001;
localparam  MUX_PE    = 3'b101;
localparam  MUX_NULL  = 3'b000;

localparam  WEST  = 3'b011;
localparam  SOUTH = 3'b101;
localparam  PE    = 3'b111;
localparam  NULL  = 3'b000;


arbitro UUT(
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


// stimuli
  initial
    begin
      // initial values
      pe_request_bundle     = 0;
      north_request_bundle  = 0;
      east_request_bundle   = 0;

      // stimuli
      #(30);
        // out of stability period
          north_request_bundle = WEST;
            #(20);
          north_request_bundle = NULL;
            #(20);
          north_request_bundle = SOUTH;
            #(20);
          north_request_bundle = PE;
            #(20);
          north_request_bundle = NULL;
        // Done with North
        // Start PE request
          pe_request_bundle = WEST;
            #(20);
          pe_request_bundle = SOUTH;
            #(20);
          pe_request_bundle = SOUTH | WEST;
            #(20);
          pe_request_bundle = NULL;
            #(20)
        // Done with PE
        // Start South request
          east_request_bundle = WEST;
            #(20);
          east_request_bundle = SOUTH;
            #(20);
          east_request_bundle = PE;
            #(20);
          east_request_bundle = NULL;
            #(20);
        // Done with South
        // Multiple Petition
        north_request_bundle = WEST;
        east_request_bundle  = SOUTH;
          #(20);
        north_request_bundle = NULL;
        east_request_bundle  = NULL;
          #(20);
        north_request_bundle = WEST;
        east_request_bundle  = WEST;
          #(20);
        north_request_bundle = NULL;
        east_request_bundle  = NULL;
          #(20);
        north_request_bundle = SOUTH;
        east_request_bundle  = SOUTH;
        pe_request_bundle    = WEST;
          #(20);
        north_request_bundle = SOUTH;
        east_request_bundle  = WEST;
        pe_request_bundle    = WEST;
          #(20);
        north_request_bundle = PE;
        east_request_bundle  = WEST;
        pe_request_bundle    = WEST;
          #(20);
        north_request_bundle = SOUTH;
        east_request_bundle  = PE;
        pe_request_bundle    = WEST;
          #(20);
        north_request_bundle = NULL;
        east_request_bundle  = NULL;
        pe_request_bundle    = NULL; 
          #(20);

        // Done with Multiple

        #(200);
          $finish;
    end


endmodule //arbiter_tb
