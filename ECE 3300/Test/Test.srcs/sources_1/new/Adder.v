`timescale 1ns / 1ps




module Adder(carryin, X, Y, S, carryout);

              input carryin;

              input [1:0] X, Y;

              output [1:0] S;

              output carryout;

              wire [1:1] C;

              fulladd stage0 (carryin, X[0], Y[0], S[0], C[1]);

              fulladd stage1 (C[1], X[1], Y[1], S[1], carryout);

endmodule

 

module fulladd(Cin, x, y, s, Cout);

input Cin, x, y;

              output s, Cout;

              assign s = x ^ y ^ Cin;

              assign Cout = (x & y) | (x & Cin) | (y & Cin);

endmodule

 