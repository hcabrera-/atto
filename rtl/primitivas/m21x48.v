module m21x48 (
  input   wire sel,
  input   wire [47:0] a,
  input   wire [47:0] b,

  output  wire [47:0] o
);

genvar index;

  generate
    for (index = 0; index < 6;index = index + 1)
      begin: m21x8_slice
        m21x8 m21x8 (
                  .sel(sel),
                  .a(a[7 + (index * 8) : index * 8]),
                  .b(b[7 + (index * 8) : index * 8]),

                  .o(o[7 + (index * 8) : index * 8])
                );
        end
    endgenerate

endmodule // m21x48
