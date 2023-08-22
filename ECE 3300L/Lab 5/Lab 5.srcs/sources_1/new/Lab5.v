`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2020 09:57:29 PM
// Design Name: 
// Module Name: Lab5
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Lab5(in1, in2, out, AN);

    input [3:0] in1;
    input [3:0] in2;
    wire [3:0] summy;
    output [0:6] out;
    output [7:0] AN;
    
    assign AN = 8'b11111110;
        
    sign_mag_add pog(in1, in2, summy);
    Decoder pogtwo(summy, out); 

endmodule

module sign_mag_add
   #(parameter N=4 ) 
   (input wire [N-1:0] a, b,
    output reg [N-1:0] sum
   );
   // signal declaration
   reg [N-2:0]  mag_a, mag_b, mag_sum, max, min;
   reg sign_a, sign_b, sign_sum;
   //body
   always @*
   begin
      // separate magnitude and sign
      mag_a = a[N-2:0];
      mag_b = b[N-2:0];
      sign_a = a[N-1];
      sign_b = b[N-1];
      // sort according to magnitude
      if (mag_a > mag_b)
         begin
            max = mag_a;
            min = mag_b;
            sign_sum = sign_a;
         end
      else
         begin
            max = mag_b;
            min = mag_a;
            sign_sum = sign_b;
         end
      // add/sub magnitude
      if (sign_a==sign_b)
         mag_sum = max + min;
      else
         mag_sum = max - min;
      // form output
      sum = {sign_sum, mag_sum};
   end
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
                Y=7'b0111000;
        
        default:
            Y=7'b0000000;
            
    endcase
    
endmodule
