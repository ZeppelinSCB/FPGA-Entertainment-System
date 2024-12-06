`timescale 1ns/1ns
module tb_bintodeci();

reg [13:0] bin;
wire [15:0] bcd;

assign bcd = 0;

always@(*)
	bin = 234;


bintodeci bintodeci_inst(
    .bin(bin),
    .bcd(bcd)
);
endmodule