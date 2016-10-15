
module arbitro (

  // Request bundles are composed by:
  //    * request_bundle[2] :: hit_x
  //    * request_bundle[1] :: hit_y
  //    * request_bundle[0] :: request
    input wire [2:0] pe_request_bundle,
    input wire [2:0] north_request_bundle,
    input wire [2:0] east_request_bundle,

// Configuration bundles are composed by:
//    * cfg_bundle[2] :: mux_ctrl[1]
//    * cfg_bundle[1] :: mux_ctrl[0]
//    * cfg_bundle[0] :: toggle

    output reg [1:0] pe_cfg_bundle,
    output reg [2:0] south_cfg_bundle,
    output reg [2:0] west_cfg_bundle,

// ACK that a request from the PE has been accepted
    output reg      r2pe_ack
  );

// Local Symbols
  localparam  MUX_EAST  = 3'b111;
  localparam  MUX_NORTH = 3'b101;
  localparam  MUX_PE    = 3'b001;
  localparam  MUX_NULL  = 3'b000;

// Signal for visivility at debug
  wire [2:0] request_vector;

  assign request_vector = {east_request_bundle[0], north_request_bundle[0], pe_request_bundle[0]};

// First level classification - by active request

always @(*)
  begin

  // default values to infer combinational logic
  west_cfg_bundle  = MUX_NULL;
  south_cfg_bundle = MUX_NULL;
  pe_cfg_bundle    = MUX_NULL;

  r2pe_ack         = 1'b0;

    case (request_vector)
      3'b000: // None
        begin
          // Everything on default
        end


      3'b001: // PE
        begin
          r2pe_ack = 1'b1;
          case (pe_request_bundle[2:1])
            2'b00:  west_cfg_bundle  = MUX_PE;    // mux1 -> pe, mux2 -> north, toggle -> 1
            2'b01:  west_cfg_bundle  = MUX_PE;    // mux1 -> pe, mux2 -> north, toggle -> 1
            2'b10:  south_cfg_bundle = MUX_PE;    // mux1 -> pe, mux2 -> north, toggle -> 1
            2'b11:
              begin
                r2pe_ack = 1'b0;
                south_cfg_bundle = MUX_NULL;  // invalid
              end
          endcase
        end


      3'b010: // North
        case (north_request_bundle[2:1])
          2'b00:  west_cfg_bundle  = MUX_NORTH; // mux1 -> ports, mux2 -> north, toggle -> 1
          2'b01:  west_cfg_bundle  = MUX_NORTH; // mux1 -> ports, mux2 -> north, toggle -> 1
          2'b10:  south_cfg_bundle = MUX_NORTH; // mux1 -> ports, mux2 -> north, toggle -> 1
          2'b11:  pe_cfg_bundle    = 2'b01;     // mux1 -> north  toggle -> 1
        endcase


      3'b011: // North, PE
        begin
          r2pe_ack = 1'b1;
          case (north_request_bundle[2:1])
              2'b00:
                begin
                  west_cfg_bundle  = MUX_NORTH; // mux1 -> ports, mux2 -> north, toggle -> 1
                  south_cfg_bundle = MUX_PE;    // mux1 -> pe,    mux2 -> north, toggle -> 1
                end
            2'b01:
              begin
                west_cfg_bundle  = MUX_NORTH; // mux1 -> ports, mux2 -> north, toggle -> 1
                south_cfg_bundle = MUX_PE;    // mux1 -> pe,    mux2 -> north, toggle -> 1
              end
            2'b10:
              begin
                south_cfg_bundle = MUX_NORTH; // mux1 -> ports, mux2 -> north, toggle -> 1
                west_cfg_bundle  = MUX_PE;    // mux1 -> pe,    mux2 -> north, toggle -> 1
              end
            2'b11:
              begin
                west_cfg_bundle = MUX_PE;    // mux1 -> pe,    mux2 -> north, toggle -> 1
                pe_cfg_bundle   = 2'b01;     // mux1 -> north  toggle -> 1
              end
          endcase
        end


      3'b100: // East
        case (east_request_bundle[2:1])
          2'b00:  west_cfg_bundle  = MUX_EAST; // mux1 -> ports, mux2 -> east, toggle -> 1
          2'b01:  west_cfg_bundle  = MUX_EAST; // mux1 -> ports, mux2 -> east, toggle -> 1
          2'b10:  south_cfg_bundle = MUX_EAST; // mux1 -> ports, mux2 -> east, toggle -> 1
          2'b11:  pe_cfg_bundle    = 2'b11;  // mux1 -> east   toggle -> 1
        endcase


      3'b101: // East, PE
        begin
          r2pe_ack = 1'b1;
          case (east_request_bundle[2:1])
            2'b00:
              begin
                west_cfg_bundle  = MUX_EAST; // mux1 -> ports, mux2 -> east, toggle -> 1
                south_cfg_bundle = MUX_PE;   // mux1 -> pe,    mux2 -> north, toggle -> 1
              end

            2'b01:
              begin
                west_cfg_bundle  = MUX_EAST; // mux1 -> ports, mux2 -> east,  toggle -> 1
                south_cfg_bundle = MUX_PE;   // mux1 -> pe,    mux2 -> north, toggle -> 1
              end
            2'b10:
              begin
                south_cfg_bundle = MUX_EAST; // mux1 -> ports, mux2 -> east,  toggle -> 1
                west_cfg_bundle  = MUX_PE;   // mux1 -> pe,    mux2 -> north, toggle -> 1
              end
            2'b11:
              begin
                west_cfg_bundle = MUX_PE;  // mux1 -> pe,    mux2 -> north, toggle -> 1
                pe_cfg_bundle   = 2'b11;   // mux1 -> east   toggle -> 1
              end
          endcase
        end


      3'b110: // East, North
        case (east_request_bundle[2:1])
          2'b00:
            begin
              west_cfg_bundle  = MUX_EAST;  // mux1 -> ports, mux2 -> east, toggle -> 1
              south_cfg_bundle = MUX_NORTH; // mux1 -> ports, mux2 -> north, toggle -> 1
            end

          2'b01:
            begin
              west_cfg_bundle  = MUX_EAST;  // mux1 -> ports, mux2 -> east,  toggle -> 1
              south_cfg_bundle = MUX_NORTH; // mux1 -> ports, mux2 -> north, toggle -> 1
            end
          2'b10:
            begin
              south_cfg_bundle = MUX_EAST;  // mux1 -> ports, mux2 -> east,  toggle -> 1
              west_cfg_bundle  = MUX_NORTH; // mux1 -> ports, mux2 -> north, toggle -> 1
            end
          2'b11:
            begin
              west_cfg_bundle  = MUX_NORTH; // mux1 -> ports, mux2 -> north, toggle -> 1
              pe_cfg_bundle   = 2'b11;      // mux1 -> east   toggle -> 1
            end
        endcase


      3'b111: // East, North, PE
        case (east_request_bundle[2:1])
          2'b00:
            begin
              west_cfg_bundle  = MUX_EAST;  // mux1 -> ports, mux2 -> east, toggle -> 1
              south_cfg_bundle = MUX_NORTH; // mux1 -> ports, mux2 -> north, toggle -> 1
            end

          2'b01:
            begin
              west_cfg_bundle  = MUX_EAST;  // mux1 -> ports, mux2 -> east,  toggle -> 1
              if (north_request_bundle[2:1] == 2'b11)
                begin
                  south_cfg_bundle  = MUX_PE; // mux1 -> pe,    mux2 -> north, toggle -> 1
                  pe_cfg_bundle     = 2'b01;  // mux1 -> north, toggle -> 1
                  r2pe_ack          = 1'b1;
                end
              else
                  south_cfg_bundle = MUX_NORTH; // mux1 -> ports, mux2 -> north, toggle -> 1
            end
          2'b10:
            begin
              west_cfg_bundle  = MUX_NORTH; // mux1 -> ports, mux2 -> north, toggle -> 1
              if (north_request_bundle[2:1] == 2'b11)
                begin
                  west_cfg_bundle = MUX_PE; // mux1 -> pe,    mux2 -> north, toggle -> 1
                  pe_cfg_bundle   = 2'b01;  // mux1 -> north, toggle -> 1
                  r2pe_ack        = 1'b1;
                end
              else
                south_cfg_bundle = MUX_EAST;  // mux1 -> ports, mux2 -> east,  toggle -> 1
            end
          2'b11:
            begin
              if (north_request_bundle[2:1] == 2'b01)
                begin
                  west_cfg_bundle  = MUX_NORTH; // mux1 -> ports, mux2 -> north, toggle -> 1
                  south_cfg_bundle = MUX_PE;    // mux1 -> pe,    mux2 -> north, toggle -> 1
                end
              else
                begin
                  west_cfg_bundle  = MUX_PE;    // mux1 -> pe,    mux2 -> north, toggle -> 1
                  south_cfg_bundle = MUX_NORTH;  // mux1 -> ports, mux2 -> north, toggle -> 1
                end
              pe_cfg_bundle   = 2'b11;      // mux1 -> east   toggle -> 1
              r2pe_ack        = 1'b1;
            end
        endcase


    endcase // first level descrimination :: by active request
  end // arbiter body


endmodule
