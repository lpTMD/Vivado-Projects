`timescale 1ns / 1ps



module Lab4(in, out, AN);

    input [2:0] in;
    output [0:6] out;
    output [7:0] AN;
    
    assign AN = 8'b11111110;
        
    Decoder pog(in, out); 

endmodule

module Decoder( input [3:0] X, output reg [7:0] Y );
    
   always @(X)
   
        case(X)
        
            4'b0000:
                Y=7'b0000001;
            4'b0001:
                Y=7'b1001111;
            4'b0010:
                Y=7'b0010010;
            4'b0011:
                Y=7'b0000110;
            4'b0100:
                Y=7'b1001100;
            4'b0101:
                Y=7'b0100100;
            4'b0110:
                Y=7'b0100000;
            4'b0111:
                Y=7'b0001111;
            4'b1000:
                Y=7'b0000000;
            4'b1001:
                Y=7'b0001100;
            4'b1010:
                Y=7'b0001000;
            4'b1011:
                Y=7'b1100000;
            4'b1100:
                Y=7'b0110001;
            4'b1101:
                Y=7'b1000010;
            4'b1110:
                Y=7'b0110000;
            4'b1111:
                Y=7'b0011000;
        
        default:
            Y=7'b0000000;
            
    endcase
    
endmodule
        