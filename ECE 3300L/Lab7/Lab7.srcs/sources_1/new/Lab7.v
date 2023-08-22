`timescale 1ns / 1ps

module Lab7(clock, out, AN, resetALL);

    wire [5:0] second;
    wire [5:0] minute;
    wire [1:0] select;
    
    wire [0:6] out1;
    wire [0:6] out2;
    wire [0:6] out3;
    wire [0:6] out4;
    
    wire outsignal1;
    wire outsignal2;
    
    wire resetS1;
    wire resetS2;
    
    input clock;
    
    input resetALL;
    
    output [0:6] out;
    output [7:0] AN;
    
    HZ1ClkGen timeClock(clock, resetALL, outsignal1);
    
    upcounterTime pog(resetALL, outsignal1, second, minute);
    
    HZ400ClkGen selectClock(clock, resetALL, outsignal2);
    
    upcounter2B segmentSelect(resetALL, outsignal2, select);
    
    Decoder secR(second%10, out1);
    Decoder secL(second/10, out2);
    Decoder minR(minute%10, out3);
    Decoder minL(minute/10, out4);
    
    display(select, AN, out, out1, out2, out3, out4);
    
endmodule

module Decoder( input [3:0] X, output reg [7:0] Y );
    
   always @(X)
   
        case(X)
        
            4'b0000:
                Y=7'b0000001;
            4'b0001:
                Y=7'b1001111;
            4'b0010:
                Y=7'b0010010;
            4'b0011:
                Y=7'b0000110;
            4'b0100:
                Y=7'b1001100;
            4'b0101:
                Y=7'b0100100;
            4'b0110:
                Y=7'b0100000;
            4'b0111:
                Y=7'b0001111;
            4'b1000:
                Y=7'b0000000;
            4'b1001:
                Y=7'b0001100;
                
            default:
                Y=7'b0000000;
            
    endcase
    
endmodule

module display(input [1:0] sel, output reg [7:0] AN, out, out1, out2, out3, out4);
    
    always @(sel)
        case (sel)
            2'b00:
                begin
                    AN <= 8'b11111110;
                    out <= out1;
                end
            2'b01:
                begin
                    AN <= 8'b11111101;
                    out <= out2;
                end
            2'b10:
                begin
                    AN <= 8'b11111011;
                    out <= out3;
                end
            2'b11:
                begin
                    AN <= 8'b11110111;
                    out <= out4;
                end
            default:
                begin
                    AN <= 8'b11111111;
                    out <= out1;
                end
        endcase
endmodule

module upcounterTime (reset, ClockSignal, sec, min);
	input reset, ClockSignal;
	output reg [5:0] sec;
	output reg [5:0] min;
	
	always @(negedge reset, posedge ClockSignal)
	 	if (reset)
	 	      begin
			     sec <= 0;
			     min <= 0;
		      end
	    else if (sec >= 6'b111011 && min >= 6'b111011)
	          begin
	             sec <= 0;
	             min <= 0;
	          end
		else if (sec >= 6'b111011)
		      begin
		         sec <= 0;
		         min <= min + 1;
		      end
		else
			sec <= sec + 1;	
endmodule

module upcounter2B (reset, ClockSignal, a);
        
    input reset, ClockSignal;
    output reg [1:0] a;
    
    always @(negedge reset, posedge ClockSignal)
        if (reset)
            a <= 0;
        else
            a <= a + 1;
            
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

module HZ400ClkGen(clk, resetCLK, outsignal);
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
	       if (counter == 125_000) 
		      begin
			     outsignal=~outsignal;
			     counter =0;
		      end
           end
        end
        
endmodule