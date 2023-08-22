`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2020 02:00:34 PM
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


module simmy(

    );
    
  reg clk;
  wire mt;
  wire [4:0] q;
  ffff uut(clk, 0, mt, q ); 
 // uut stands for "Unit Under Test", which is declared as an 'object' of module "decoder"

initial begin

 #1 clk = 0;
 #1 clk = 1;
 #1 clk = 0;
 #1 clk = 1;
 #1 clk = 0;
 #1 clk = 1;
 #1 clk = 0;
 #1 clk = 1;
 #1 clk = 0;
 #1 clk = 1;
 #1 clk = 0;
 #1 clk = 1;
 #1 clk = 0;
 #1 clk = 1;
 #1 clk = 0;
 #1 clk = 1;
 #1 clk = 0;
 #1 clk = 1;
 #1 clk = 0;
 #1 clk = 1;
 #1 clk = 0;
 #1 clk = 1;
 
 end
    
endmodule
