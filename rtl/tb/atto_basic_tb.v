`timescale 1ns/1ns

module router_basic_tb();


reg clka;
reg rsta;

// input channels
  reg  [47:0] north_channel_din;
  reg  [1:0]  north_diff_pair_din;
  reg  [47:0] east_channel_din;
  reg  [1:0]  east_diff_pair_din;
  reg  [47:0] pe_channel_din;
  reg  [1:0]  pe_diff_pair_din;

// output channels
  wire [47:0] south_channel_dout;
  wire [1:0]  south_diff_pair_dout;
  wire [47:0] west_channel_dout;
  wire [1:0]  west_diff_pair_dout;
  wire [39:0] pe_channel_dout;
  wire [1:0]  pe_diff_pair_dout;
  wire        r2pe_ack_dout;



// UUT /////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
atto  UUT
  (
    .clka(clka),
    .rsta(rsta),

    // input channels
      .north_channel_din  (north_channel_din),
      .north_diff_pair_din(north_diff_pair_din),
      .east_channel_din   (east_channel_din),
      .east_diff_pair_din (east_diff_pair_din),
      .pe_channel_din     (pe_channel_din),
      .pe_diff_pair_din   (pe_diff_pair_din),

    // output channels
      .south_channel_dout   (south_channel_dout),
      .south_diff_pair_dout (south_diff_pair_dout),
      .west_channel_dout    (west_channel_dout),
      .west_diff_pair_dout  (west_diff_pair_dout),
      .pe_channel_dout      (pe_channel_dout),
      .pe_diff_pair_dout    (pe_diff_pair_dout),
      .r2pe_ack_dout        (r2pe_ack_dout)
  );
////////////////////////////////////////////////////////////////////////////////

// clk generator
always
  begin
    #(10)
    clka = ~clka;
  end

  // stimuli
    initial
      begin
        // initial values
          clka = 1'b0;
          rsta = 1'b1;

          north_channel_din   = 48'b0;
          north_diff_pair_din = 2'b10;
          east_channel_din    = 48'b0;
          east_diff_pair_din  = 2'b10;
          pe_channel_din      = 48'b0;
          pe_diff_pair_din    = 2'b10;

        // stimuli
          repeat (20)
            @(negedge clka);

        // out of reset
          rsta = 1'b0;

          repeat (10)
            @(negedge clka);


        // North only Request //////////////////////////////////////////////////  out :: south
        ////////////////////////////////////////////////////////////////////////
          north_channel_din   = 48'h210000000000;
          north_diff_pair_din = 2'b01;

            @(negedge clka);

        // East only Request /////////////////////////////////////////////////// out :: west
        ////////////////////////////////////////////////////////////////////////
          east_channel_din   = 48'h121111111111;
          east_diff_pair_din = 2'b01;

            @(negedge clka);

        // PE only Request ///////////////////////////////////////////////////// out :: south - west
        ////////////////////////////////////////////////////////////////////////
          pe_channel_din   = 48'h333333333333;
          pe_diff_pair_din = 2'b01;

            @(negedge clka);

        // North - East Request //////////////////////////////////////////////// out :: east  --> west
        ////////////////////////////////////////////////////////////////////////        north --> south
          north_channel_din   = 48'h120000000000;
          north_diff_pair_din = 2'b10;

          east_channel_din   = 48'h121111111111;
          east_diff_pair_din = 2'b10;

            @(negedge clka);


        // End of stimuli //////////////////////////////////////////////////////
          repeat (30)
            @(negedge clka);

          $finish;
      end

endmodule
