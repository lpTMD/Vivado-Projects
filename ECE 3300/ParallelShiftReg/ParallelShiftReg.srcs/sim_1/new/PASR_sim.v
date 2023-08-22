`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2020 01:43:02 PM
// Design Name: 
// Module Name: PASR_sim
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


module PASR_sim;

reg In, C, clock;

wire[3:0] Q;
reg[3:0] R;

PASR uut(In, R, C, clock, Q);

initial
begin

clock = 0;  R=4'b0101; C = 1; In = 0;

end

always@*
begin
    
    repeat(20) #1 clock =~ clock;
    
    #3 C = 0;
    #1 In = 1;
    #3 In = 0;
    
end


endmodule
