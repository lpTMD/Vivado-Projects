module mux1(input [2:0] x, output reg f);
 always @(x[0] or x[1]or x[2]) 
 if (x[0] == 1) 
    f = x[1];
 else 
        f = x[2];
endmodule