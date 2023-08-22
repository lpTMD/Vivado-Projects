`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2020 01:47:51 PM
// Design Name: 
// Module Name: Sim
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


module Sim;

reg clock, In;

wire [3:0] Q;

ShiftReg uut(clock, In, Q);

initial begin
    In = 1;
    clock = 0;
    #1 clock = ~clock;
    #1 clock = ~clock;
    #1 clock = ~clock;
    #1 clock = ~clock;
    #1 clock = ~clock;
    #1 clock = ~clock;
    #1 clock = ~clock;
    #1 clock = ~clock;

end

endmodule
