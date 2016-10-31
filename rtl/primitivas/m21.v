// Xilinx Only 
// TODO ifdef to enable inclusion
// (* LUT_MAP="yes" *)

module m21 (
  input   wire sel,
  input   wire a,
  input   wire b,

  output  wire o
);

  assign o = sel ? b : a;

endmodule
