`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2020 04:45:59 PM
// Design Name: 
// Module Name: Ba
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


module Ba(w, clock, z);

input w;
input clock;

wire Q2;
wire Q1;
wire Q0;

wire D2;
wire D1;
wire D0;

output reg z;


DFlipFlop d2(D2, 0, clock, Q2);
DFlipFlop d1(D1, 0, clock, Q1);
DFlipFlop d0(D0, 0, clock, Q0);

assign D2 = (w && Q1 && Q0) || (w && Q2 && !Q1) || (!w && !Q2 && !Q1 && !Q0);
assign D1 = (!w && Q0) || (!Q1 && Q0) || (Q2 && Q1) || (w && Q2);
assign D0 = (w && !Q2) || (w && Q0) || (w && Q1);

always @ (posedge clock)
    z = Q2 && Q1;


endmodule


module DFlipFlop(D,R,clock,Q);

input D;
input R,clock;
output reg Q;

always@(posedge R, posedge clock)
    begin
        if(R)
            Q<=0;
        else
            begin
                Q<=D;
            end
    end
endmodule


