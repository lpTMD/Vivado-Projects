`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2020 01:38:16 PM
// Design Name: 
// Module Name: ShiftReg
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


module ShiftReg( clock, In, Q );

input clock;
input In;
output reg [3:0] Q;

always@(posedge clock)

    begin
    
    /*
        Q[0] = Q[1];
        Q[1] = Q[2];
        Q[2] = Q[3];
        Q[3] = In;
    */
    
    Q = {In, Q[3:1]};
    
    end

endmodule
