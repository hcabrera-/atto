module m21x8 (
  input   wire sel,
  input   wire [7:0] a,
  input   wire [7:0] b,

  output  wire [7:0] o
);

genvar index;

  generate
    for (index = 0; index < 8;index = index + 1)
      begin: m21_slice
        m21 m21 (
                  .sel(sel),
                  .a(a[index]),
                  .b(b[index]),
                  .o(o[index])
                );
        end
    endgenerate

endmodule // m21x8
