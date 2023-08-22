`timescale 1ns / 1ps

module Lab3(X, Y, S, carryout);

    input [7:0]X;
    input [7:0]Y;
    output [7:0]S;
    output carryout;
    wire [7:1]C;
    
    fulladd stage0(0, X[0], Y[0], S[0], C[1]);
    fulladd stage1(C[1], X[1], Y[1], S[1], C[2]);
    fulladd stage2(C[2], X[2], Y[2], S[2], C[3]);
    fulladd stage3(C[3], X[3], Y[3], S[3], C[4]);
    fulladd stage4(C[4], X[4], Y[4], S[4], C[5]);
    fulladd stage5(C[5], X[5], Y[5], S[5], C[6]);
    fulladd stage6(C[6], X[6], Y[6], S[6], C[7]);
    fulladd stage7(C[7], X[7], Y[7], S[7], carryout);
    


endmodule

module fulladd(Cin, x, y, s, Cout);
    input Cin, x, y;
    output s, Cout;
    
    assign s = x ^ y ^ Cin;
    assign Cout = (x & y) | (x & Cin) | (y & Cin);
    
endmodule