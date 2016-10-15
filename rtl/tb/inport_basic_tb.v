`timescale 1ns/1ns

module inport_basic_tb();

reg clka;
reg rsta;

reg [1:0]   diff_pair_din;
reg [47:0]  channel_din;

wire        request_dout;

wire        x_hit_dout;
wire        y_hit_dout;

wire [3:0]  x_addr_dout;
wire [3:0]  y_addr_dout;
wire [39:0] payload_dout;


// clk generator
always
  begin
    #(10)
    clka = ~clka;
  end


inport UUT
  (
      .clka(clka),
      .rsta(rsta),

      .diff_pair_din(diff_pair_din),
      .channel_din(channel_din),

      .request_dout(request_dout),

      .x_hit_dout(x_hit_dout),
      .y_hit_dout(y_hit_dout),

      .x_addr_dout(x_addr_dout),
      .y_addr_dout(y_addr_dout),
      .payload_dout(payload_dout)
  ); // inport


// stimuli
  initial
    begin
      // initial values
        clka = 1'b0;
        rsta = 1'b1;

        diff_pair_din = 2'b10;
        channel_din   = 0;

      // stimuli
        repeat (10)
          @(negedge clka);

      // out of reset
        rsta = 1'b0;

        repeat (10)
          @(negedge clka);

        diff_pair_din = 2'b01;
        channel_din   = 48'h02a987654321;

        @(negedge clka);

        channel_din   = 48'h000000000000;

        repeat (10)
          @(negedge clka);


        diff_pair_din = 2'b10;
        channel_din   = 48'h200b0073d000;

        repeat (10)
          @(negedge clka);

        diff_pair_din = 2'b00;
        channel_din   = 48'h000000000000;

        repeat (10)
          @(negedge clka);

        $finish;
    end

endmodule
