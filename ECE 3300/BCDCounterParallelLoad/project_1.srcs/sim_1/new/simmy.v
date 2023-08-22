`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2020 12:46:46 PM
// Design Name: 
// Module Name: simmy
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


module simmy;

wire [7:0] Q;
reg clear, clock;

Counter uut(Q, clock, clear);

always@*
begin
    repeat(200)#1 clock = ~clock;
end

initial
    begin
        clock=1; clear=1; 
        #1 clear = 0;
        #1 clock = 1;
        #1 clock = 0;
    end

endmodule
