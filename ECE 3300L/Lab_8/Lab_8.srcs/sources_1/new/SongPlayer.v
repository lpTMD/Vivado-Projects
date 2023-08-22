`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2020 02:27:07 AM
// Design Name: 
// Module Name: SongPlayer
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


module SongPlayer( input clock, input reset, input playSound, output reg audioOut, output wire aud_sd);
reg [19:0] counter;
reg [31:0] time1, noteTime;
reg [9:0] msec, number;	//millisecond counter, and sequence number of musical note.
wire [4:0] note, duration;
wire [19:0] notePeriod;
parameter clockFrequency = 100_000_000; 

assign aud_sd = 1'b1;

MusicSheet 	mysong(number, notePeriod, duration	);

//mux3to1rot Sheet();

always @ (posedge clock) 
  begin
	if(reset | ~playSound) 
 		begin 
          counter <=0;  
          time1<=0;  
          number <=0;  
          audioOut <=1;	
     	end
    else 
        begin
		  counter <= counter + 1; 
          time1<= time1+1;
		  if( counter >= notePeriod) 
                begin
			         counter <=0;  
			         audioOut <= ~audioOut ; 
                end	//toggle audio output 	
		  if( time1 >= noteTime) 
                begin	
				        time1 <=0;  
                        number <= number + 1; 
                end  //play next note
        if(number == 104) number <=0; // Make the number reset at the end of the song
	       end
        end	
         
  always @(duration) noteTime = duration * clockFrequency / 12; 
       //number of   FPGA clock periods in one note.
endmodule


module MusicSheet( input [9:0] number, 
	output reg [19:0] note,//max 32 different musical notes
	output reg [4:0] duration);
parameter   EIGHTH = 5'b00001;
parameter   QUARTER = 5'b00010;//2 Hz
parameter	HALF = 5'b00100;
parameter	ONE = 2* HALF;
parameter	TWO = 2* ONE;
parameter	FOUR = 2* TWO;
parameter A4=113636.3636, B4 = 101239.1674, C4=191109.5822, D4=170264.9322, E4 = 151685.2288, F4=143172.1215, G4 = 127551.0204, SP = 1;  
parameter A3=227272.7273, B3=202478.3348, C3=382233.7742, D3=340529.8645, E3=303379.6493, F3=286352.4426, G3=255102.0408;
parameter A2=454545.4545, B2=404956.6696, C2=764409.1118, D2=681013.3479, E2=606722.4851, F2=572672.088, G2=510204.0816;
parameter A1=909090.9091, B1=809847.7486, C1=1529051.988, D1=1362026.696, E1=1213592.233, F1=1145475.372, G1=1020408.163;
parameter A0=1818181.818, B0=1619695.497, C0=3058103.976, D0=2724795.64, E0=2427184.466, F0=2290426.019, G0=2040816.327;
parameter A5=56818.1812, B5=50619.07124, C5=95556.6173, D5=85131.01663, E5=75843.76185, F5=71586.06076, G5=63776.32368;
parameter A6=28409.09091, B6=25309.66374, C6=47778.30865, D6=42565.50832, E6=37921.59331, F6=35793.28661, G6=31888.16184;
parameter A7=14204.54545, B7=12654.79984, C7=23889.15432, D7=21282.75416, E7=18960.79666, F7=17896.57925, G7=15944.08092;
parameter A8=7102.272727, B8=6327.407927, C8=11944.54863, D8=10641.39973, E8=9480.398328, F8=8948.305638, G8=7972.027749;
parameter AS2=429037.2404, CS2=721500.7215, DS2=642838.776, FS2=540540.5405, GS2=481556.3903;
parameter AS3=214518.6202, CS3=360776.3908, DS3=321419.388, FS3=270270.2703, GS3=240789.7905;
parameter AS4=107259.3101, CS4=180388.1954, DS4=160704.5287, FS4=135138.7875, GS4=120394.8953;

 
/*
always @ (number) begin
case(number) 
0: begin note = A0;  duration = EIGHTH;	end	
1: begin note = SP; duration = EIGHTH; end
2: begin note = A0; duration = EIGHTH; 	end	
3: begin note = SP; duration = EIGHTH; end
4: begin note = A0; duration = EIGHTH; 	end	
5: begin note = SP; duration = EIGHTH; end
6: begin note = A3;  duration = QUARTER;	end	
7: begin note = SP; duration = HALF; end
8: begin note = A0; duration = EIGHTH; 	end	
9: begin note = SP; duration = EIGHTH; end
10: begin note = A0; duration = EIGHTH; 	end	
11: begin note = SP; duration = EIGHTH; end
12: begin note = A0; duration = EIGHTH; 	end
13: begin note = SP; duration = EIGHTH; end	
14: begin note = A5; duration = QUARTER; end
15: begin note = SP; duration = EIGHTH; 	end	

default: 	begin note = C4; duration = FOUR; 	end
endcase
end
*/


always @ (number) begin
case(number) 

0: begin note = GS3;  duration = QUARTER;	end	
1: begin note = SP; duration = EIGHTH; end
2: begin note = E3; duration = QUARTER; 	end	
3: begin note = SP; duration = EIGHTH; end
4: begin note = FS3; duration = QUARTER; 	end	
5: begin note = SP; duration = EIGHTH; end
6: begin note = GS3; duration = QUARTER;	end	
7: begin note = SP; duration = EIGHTH; end
8: begin note = B3; duration = HALF; end
9: begin note = B3; duration = QUARTER; end
10: begin note = E4; duration = QUARTER; end
11: begin note = SP; duration = HALF;  end

12: begin note = AS3;  duration = QUARTER;	end	
13: begin note = SP; duration = EIGHTH; end
14: begin note = FS3; duration = QUARTER; 	end	
15: begin note = SP; duration = EIGHTH; end
16: begin note = AS3; duration = QUARTER; 	end	
17: begin note = SP; duration = EIGHTH; end
18: begin note = B3; duration = QUARTER;	end	
19: begin note = SP; duration = EIGHTH; end
20: begin note = CS4; duration = HALF; end
21: begin note = CS4; duration = QUARTER; end
22: begin note = DS2; duration = QUARTER; end
23: begin note = SP; duration = HALF; end

24: begin note = DS4;  duration = QUARTER;	end	
25: begin note = SP; duration = EIGHTH; end
26: begin note = CS4; duration = QUARTER; 	end	
27: begin note = SP; duration = EIGHTH; end
28: begin note = B3; duration = QUARTER; 	end	
29: begin note = SP; duration = EIGHTH; end
30: begin note = AS3; duration = QUARTER;	end	
31: begin note = SP; duration = EIGHTH; end
32: begin note = B3; duration = HALF; end
33: begin note = B3; duration = QUARTER; end
34: begin note = FS2; duration = QUARTER; end
35: begin note = SP; duration = HALF; end

36: begin note = B3;  duration = QUARTER;	end	
37: begin note = SP; duration = EIGHTH; end
38: begin note = AS3; duration = QUARTER; 	end	
39: begin note = SP; duration = EIGHTH; end
40: begin note = GS3; duration = QUARTER; 	end	
41: begin note = SP; duration = EIGHTH; end
42: begin note = FS3; duration = QUARTER;	end	
43: begin note = SP; duration = EIGHTH; end
44: begin note = GS3; duration = HALF; end
45: begin note = GS3; duration = QUARTER; end
46: begin note = B3; duration = QUARTER; end
47: begin note = SP; duration = HALF; end

48: begin note = E3;  duration = QUARTER;	end	
49: begin note = SP; duration = EIGHTH; end
50: begin note = FS3; duration = QUARTER; 	end	
51: begin note = SP; duration = EIGHTH; end
52: begin note = GS3; duration = QUARTER; 	end	
53: begin note = SP; duration = EIGHTH; end
54: begin note = SP; duration = QUARTER; end
55: begin note = SP; duration = EIGHTH; end

56: begin note = GS3;  duration = QUARTER;	end	
57: begin note = SP; duration = EIGHTH; end
58: begin note = AS3; duration = QUARTER; 	end	
59: begin note = SP; duration = EIGHTH; end
60: begin note = B3; duration = QUARTER; 	end	
61: begin note = SP; duration = EIGHTH; end
62: begin note = SP; duration = QUARTER; end
63: begin note = SP; duration = EIGHTH; end

64: begin note = AS3;  duration = QUARTER;	end	
65: begin note = SP; duration = EIGHTH; end
66: begin note = FS3; duration = QUARTER; 	end	
67: begin note = SP; duration = EIGHTH; end
68: begin note = AS3; duration = QUARTER; 	end	
69: begin note = SP; duration = EIGHTH; end
70: begin note = B3; duration = QUARTER;	end	
71: begin note = SP; duration = EIGHTH; end
72: begin note = CS4; duration = HALF; end
73: begin note = CS4; duration = QUARTER; end
74: begin note = DS2; duration = QUARTER; end
75: begin note = SP; duration = HALF; end

76: begin note = B3;  duration = QUARTER;	end	
77: begin note = SP; duration = EIGHTH; end
78: begin note = CS4; duration = QUARTER; 	end	
79: begin note = SP; duration = EIGHTH; end
80: begin note = DS4; duration = QUARTER; 	end	
81: begin note = SP; duration = EIGHTH; end
82: begin note = E4; duration = QUARTER; end
83: begin note = SP; duration = EIGHTH; end

84: begin note = FS4;  duration = QUARTER;	end	
85: begin note = SP; duration = EIGHTH; end
86: begin note = E4; duration = QUARTER; 	end	
87: begin note = SP; duration = EIGHTH; end
88: begin note = DS4; duration = QUARTER; 	end	
89: begin note = SP; duration = EIGHTH; end
90: begin note = CS4; duration = QUARTER; end
91: begin note = SP; duration = EIGHTH; end

92: begin note = GS3;  duration = QUARTER;	end	
93: begin note = SP; duration = EIGHTH; end
94: begin note = AS3; duration = QUARTER; 	end	
95: begin note = SP; duration = EIGHTH; end
96: begin note = B3; duration = QUARTER; 	end	
97: begin note = SP; duration = EIGHTH; end
98: begin note = CS4; duration = QUARTER; end
99: begin note = SP; duration = EIGHTH; end

100: begin note = FS4;  duration = HALF;	end	
101: begin note = SP; duration = QUARTER; end
102: begin note = DS4; duration = HALF; 	end	
103: begin note = SP; duration = QUARTER; end

default: 	begin note = C4; duration = FOUR; 	end
endcase
end

endmodule

module mux3x1rot(
    input [2:0] D,
    input clk,
    output y
);
    reg [1:0] count;
    always @(posedge clk)
    begin
        count = (count+1)%3;
    end
    assign y=D>>count;
endmodule
