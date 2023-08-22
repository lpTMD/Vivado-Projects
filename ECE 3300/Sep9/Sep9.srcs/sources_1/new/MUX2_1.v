`timescale 1ns / 1ps



module MUX2_1(w0, w1, s, f);
   
   input w0, w1, s;
   output f;
   
   assign f = s ? w1 : w0;
   
endmodule


/*

module MUX2_1(w0, w1, s, f);
    input w0, w1, s;
    output reg f;
    
    always @(w0, w1, s)
        f = s ? w1 : w0 ;

*/
