`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2020 02:00:14 PM
// Design Name: 
// Module Name: ffff
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


module ffff(clk, reset, max_tick, q);

  localparam N=4;

  localparam M=10;

  input wire clk, reset;

  output wire max_tick;

  output wire [N-1:0] q;

  reg [N-1:0] r_reg;

  wire [N-1:0] r_next;

   always @(posedge clk, posedge reset)

      if (reset)

         r_reg <= 0;

      else

         r_reg <= r_next;

   assign r_next = (r_reg==(M-1)) ? 0 : r_reg + 1;

   assign q = r_reg;

   assign max_tick = (r_reg==(M-1)) ? 1'b1 : 1'b0;

endmodule
