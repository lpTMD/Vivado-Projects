`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2020 10:34:35 PM
// Design Name: 
// Module Name: L11
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


module L11(clock, in, loadControl, pulse, parity, signalOut);

    input clock;
    input [7:0] in;
    input loadControl;
    
    output pulse;
    output parity;
    output signalOut;
    
    wire [7:0] storeg;
    wire [2:0] counts;
    
    HZ1ClkGen jammies(clock, loadControl, pulse);
    upcounter3B upC(loadControl, pulse, counts);
    shiftRegParityTracker parityChec(loadControl, pulse, in, counts, signalOut, parity);

endmodule


module shiftRegParityTracker(reset, clockSignal, insert, count, outbit, parity);

    input reset, clockSignal;
    input [7:0] insert;
    input [2:0] count;
    
    output reg outbit;
    output reg parity;
    
    reg [7:0] storeg;
    
    always @ (negedge reset, posedge clockSignal)
    begin
        if(reset)
            begin
                storeg <= insert;
                outbit <= 0;
                parity <= 1;
            end
        else if (count < 7)
            begin
                outbit = storeg[0];
                if (storeg[0] == 1)
                    parity = ~parity;
                storeg <= storeg >> 1;
            end
        else
            begin
                outbit = storeg[0];
            end
    end    
    
endmodule



module HZ1ClkGen(clk, resetCLK, outsignal);
    input clk;
    input resetCLK;
    output  outsignal;
    
    reg [26:0] counter;  
    reg outsignal;
    
    always @ (posedge clk)
    begin
    
	if (resetCLK)
	   begin
		  counter=0;
		  outsignal=0;
        end
	  
	else
        begin
	       counter = counter +1;
	       if (counter == 50_000_000) 
		      begin
			     outsignal=~outsignal;
			     counter =0;
		      end
           end
        end
        
endmodule


module upcounter3B (reset, ClockSignal, a);
        
    input reset, ClockSignal;
    output reg [2:0] a;
    
    always @(negedge reset, posedge ClockSignal)
        if (reset)
            a <= 0;
        else if (a < 7)
            a <= a + 1;
            
endmodule

module select (a, out);

    input [2:0] a;
    output out;

    assign out = a[2] & a[1] & a[0];

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


module mux2to1 (w0, w1, s, f);

  input w0, w1, s;
  output reg f;
  
  always @(w0, w1, s)
    if (s==0)
        f = w0;
    else
        f = w1;

 
endmodule