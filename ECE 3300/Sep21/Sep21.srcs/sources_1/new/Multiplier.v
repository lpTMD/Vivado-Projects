`timescale 1ns / 1ps


module Multiplier(M, Q, P);

parameter n = 3;

input [n:0] M, Q;

output [2*n+1:0]P;

assign P = M*Q;

endmodule
