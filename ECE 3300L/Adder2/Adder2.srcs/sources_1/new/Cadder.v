`timescale 1ns / 1ps


module Cadder(Cin, X, Y, S, Cout);
parameter n=1;
input Cin;
input [n:0] X, Y;
output [n:0] S;
output Cout;
assign {Cout, S} = X + Y + Cin;
endmodule
