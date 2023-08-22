`timescale 1ns / 1ps

module Lab5(clock, out, AN);

    wire [2:0] in;
    wire Resetn;
    wire outsignal;
    wire resetS;
    output [0:6] out;
    output [7:0] AN;
    input clock;
    
    assign AN = 8'b11111110;
    
    slowerClkGen Pog(clock, resetS, outsignal);    
    upcounter counties(Resetn, outsignal, in);          
    Decoder pog(in, out); 

endmodule

module Decoder( input [2:0] X, output reg [7:0] Y );
    
   always @(X)
   
        case(X)
        
            3'b000:
                Y=7'b0000001;
            3'b001:
                Y=7'b1001111;
            3'b010:
                Y=7'b0010010;
            3'b011:
                Y=7'b0000110;
            3'b100:
                Y=7'b1001100;
            3'b101:
                Y=7'b0100100;
            3'b110:
                Y=7'b0100000;
            3'b111:
                Y=7'b0001111;
        default:
            Y=7'b0000000;
            
       endcase
    
endmodule


module upcounter (Resetn, Clock, Q);
	input Resetn, Clock;
	output reg [2:0] Q;
	
	always @(negedge Resetn, posedge Clock)
	 	if (Resetn)
			Q <= 0;
		else 
			Q <= Q + 1;
			
endmodule


module slowerClkGen(clk, resetSW, outsignal);
    input clk;
    input resetSW;
    output  outsignal;
    
    reg [26:0] counter;  
    reg outsignal;
    
    always @ (posedge clk)
    begin
    
	if (resetSW)
	   begin
		  counter=0;
		  outsignal=0;
        end
	  
	else
        begin
	       counter = counter +1;
	       if (counter == 100_000_000) //why is this a 0.5 Hz?
		      begin
			     outsignal=~outsignal;
			     counter =0;
		      end
           end
        end
        
endmodule

