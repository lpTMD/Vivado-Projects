`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2020 05:34:04 PM
// Design Name: 
// Module Name: L12
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


module L12(clock, pulse, resetALL, turing_state, tapeReg, index, doneReg);

    input clock;
    input resetALL;
    
    output reg [7:0] tapeReg;
    output reg [3:0] index;
    output reg doneReg;
    
    output pulse;
    
    output reg turing_state;

    HZ1ClkGen hi(clock, resetALL, pulse);

    always @ (negedge resetALL, posedge pulse)
    begin
        
        if (resetALL)
        begin
            tapeReg <= 8'b00111000;
            index <= 5;
            turing_state <= 0;
            doneReg <= 0;
        end
        else
        if(turing_state != 1)
        begin
            if (turing_state == 0 && tapeReg[index] == 1)
            begin
                index <= index - 1;
            end
            if(turing_state == 0 && tapeReg[index] == 0)
            begin
                tapeReg[index] = 1;
                index <= index - 1;
                turing_state <= 1;
                doneReg <= 1;
            end
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