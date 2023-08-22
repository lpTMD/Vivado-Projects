`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2020 01:28:32 PM
// Design Name: 
// Module Name: PASR
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


module PASR(In, R, C, clock, Q);

    input In, clock, C;     // C is controlling shift(0) or load(1)
    input [3:0] R;
    output reg[3:0] Q;
    
    always@(posedge clock)
    
    begin
    
        if (C == 1)         // load
            begin
                Q <= R;
            end
            
        else
            begin
                Q = {In, Q[3:1]};
            end
        
    end

endmodule
