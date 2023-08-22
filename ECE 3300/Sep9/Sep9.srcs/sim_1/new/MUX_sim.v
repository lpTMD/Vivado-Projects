`timescale 1ns / 1ps


module MUX_sim;

reg w0;
reg w1; 
reg s;
wire f;

MUX2_1 uut(w0, w1, s, f);

initial begin  //don't forget this in a sim

    w0 = 0; w1 = 0; s = 0;
    #1 w0 = 0; w1 = 0; s = 1;
    #1 w0 = 0; w1 = 1; s = 0;
    #1 w0 = 0; w1 = 1; s = 1;
    #1 w0 = 1; w1 = 0; s = 0;
    #1 w0 = 1; w1 = 0; s = 1;
    #1 w0 = 1; w1 = 1; s = 0;
    #1 w0 = 1; w1 = 1; s = 1;

end     //don't forget this in a sim

endmodule
