`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2020 12:40:38 PM
// Design Name: 
// Module Name: Counter
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

module Counter(Q, clock, clr);
    input clr;
    input clock;
    output [7:0] Q;
    wire [7:0] D;
    wire l0;
    wire l1;
    wire e0;
    wire e1;
    
    assign D = 8'b00000000;
    assign e0 = 1;
    assign e1 = Q[0]&&Q[3];
    assign l0= (Q[0]&&Q[3]) || clr;
    assign l1 = (Q[4]&&Q[7]) || clr;
    
    BCDCounter count0(D[3:0], e0, l0, clock, Q[3:0]);
    BCDCounter count1(D[7:4], e1, l1, clock, Q[7:4]);

endmodule

module BCDCounter(D, E, L, clock, Q);

input [3:0]D;
input E, L, clock;
output reg [3:0] Q;

always@(posedge clock)
begin
    if (L)
        Q<= D;
else
    begin
      if(E)
        Q<=Q+1;
    end
end
endmodule
