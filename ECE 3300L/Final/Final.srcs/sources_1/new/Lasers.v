`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2020 06:14:35 PM
// Design Name: 
// Module Name: Lasers
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


module Lasers( clock, start, moveUp, moveMid, moveDown, aud_sd, audioOut, out, AN, resetALL, play );


    input clock;
    input start;
    input moveUp;
    input moveMid;
    input moveDown;
    input resetALL;

    output [0:6] out;           // segment output
    output [7:0] AN;            // which 7seg is on
    
    output aud_sd;
    output audioOut;

    wire [2:0] segAlternator;
    
    wire [2:0] r0;
    wire [2:0] r1;
    wire [2:0] r2;
    wire [2:0] r3;
    wire [2:0] r4;
    
    wire [0:6] out0;            // player area
    wire [0:6] out1;
    wire [0:6] out2;
    wire [0:6] out3;
    wire [0:6] out4;
    wire [0:6] out5;
    wire [0:6] out6;
    wire [0:6] out7;
    
    wire [2:0] pos;
    
    wire [2:0] laserPos;
    
    wire [6:0] counter;
    
    wire signal400;             // update 7 segment displays
    wire signal10;
    wire signal1;
    
    output play;                  // game is active
    
    wire outSignalDebounce;
    
    wire tMU;
    wire tMD;
    wire tMM;
    
    
    // update the 7 seg LEDs
    HZ400ClkGen hz400Pog(clock, resetALL, signal400);
    HZ10ClkGen laserGen(clock, resetALL, signal10);
    HZ1ClkGen hz1(clock, resetALL, signal1);
    upcounter3B segmentSelect(resetALL, signal400, segAlternator);
    
    HZ25ClkGen debouncer(clock, resetALL, outSignalDebounce);
    
    edge_detect_mealy mU(outSignalDebounce, resetALL, moveUp, tMU);
    edge_detect_mealy mD(outSignalDebounce, resetALL, moveDown, tMD);
    edge_detect_mealy mM(outSignalDebounce, resetALL, moveMid, tMM);
    
    upButton up(resetALL, tMU, tMD, tMM, pos);

    numDecoder RD(counter%10, out6);
    numDecoder LD(counter/10, out7);
    
    Decoder o0(r0, out0);
    Decoder o1(r1, out1);
    Decoder o2(r2, out2);
    Decoder o3(r3, out3);
    Decoder o4(r4, out4);
    Decoder o5(pos, out5);
    
    display(segAlternator, AN, out, out0, out1, out2, out3, out4, out5, out6, out7);
    
    game gamer(resetALL, signal10, counter, laserPos, pos, play, r0, r1, r2, r3, r4);

    SongPlayer jammies(clock, resetALL, play, audioOut, aud_sd);

endmodule

module game(reset, signal, counter, laserPos, pos, play, r0, r1, r2, r3, r4);

    input reset;
    input signal;
    output reg [2:0] laserPos;
    input [2:0] pos;
    output reg play;
    output reg [2:0] r0;
    output reg [2:0] r1;
    output reg [2:0] r2;
    output reg [2:0] r3;
    output reg [2:0] r4;
    
    output reg[6:0] counter;
    
    integer laserTiming;
    integer pick;
    reg [2:0] safe;
    
    
    always @(negedge reset, posedge signal)
    begin
    
    if (reset)
        begin
            laserTiming <= 0;
            laserPos <= 3'b000;
            play <= 1;
            r0 <= 3'b000;
            r1 <= 3'b000;
            r2 <= 3'b000;
            r3 <= 3'b000;
            r4 <= 3'b000;
            counter <= 0;
        end 
    else
    if (play)
    begin
        if (counter == 100)  begin counter = 0; end
        if (laserTiming == 0)
        begin
        
        //laser positioning phase
            if (counter%4 == 0|| (counter+1)%5 == 0)
            begin
                laserPos = 3'b110;
                safe = 3'b001;
            end
            else if (counter%6 == 0 || (counter + 2) % 6 == 0)
            begin
                laserPos = 3'b101;
                safe = 3'b010;
            end
            else if (counter%5 == 0 || (counter + 3)%4 == 0)
            begin
                laserPos = 3'b011;
                safe = 3'b100;
            end
            else
            begin
                laserPos = 3'b101;
                safe = 3'b010;
            end
            
            r0 <= laserPos;
            r1 <= 3'b000;
            r2 <= 3'b000;
            r3 <= 3'b000;
            r4 <= 3'b000;
            laserTiming <= laserTiming + 1;
        end
        else if (laserTiming == 1)
        begin
            r0 <= 3'b000;
            r1 <= laserPos;
            r2 <= 3'b000;
            r3 <= 3'b000;
            r4 <= 3'b000;
            laserTiming <= laserTiming + 1;
        end
        else if (laserTiming == 2)
        begin
            r0 <= 3'b000;
            r1 <= 3'b000;
            r2 <= laserPos;
            r3 <= 3'b000;
            r4 <= 3'b000;
            laserTiming <= laserTiming + 1;
        end
        else if (laserTiming == 3)
        begin
            r0 <= 3'b000;
            r1 <= 3'b000;
            r2 <= 3'b000;
            r3 <= laserPos;
            r4 <= 3'b000;
            laserTiming <= laserTiming + 1;
        end
        else if (laserTiming == 4)
        begin
            r0 <= 3'b000;
            r1 <= 3'b000;
            r2 <= 3'b000;
            r3 <= 3'b000;
            r4 <= laserPos;
            laserTiming <= laserTiming + 1;
        end
        else if (laserTiming == 5)
        begin
            r0 <= 3'b000;
            r1 <= 3'b000;
            r2 <= 3'b000;
            r3 <= 3'b000;
            r4 <= 3'b000;
            laserTiming <= 0;
            if (safe != pos)
            begin
                play <= 0;
            end
            else
            begin
                counter <= counter + 1;
            end
        end
        end
        else
        begin
            laserTiming <= 0;
            laserPos <= 3'b000;
            play <= 0;
            r0 <= 3'b000;
            r1 <= 3'b000;
            r2 <= 3'b000;
            r3 <= 3'b000;
            r4 <= 3'b000;
        end
    end


endmodule

module upcounter3B (reset, SSignal, a);
        
    input reset, SSignal;
    output reg [2:0] a;
    
    always @(negedge reset, posedge SSignal)
        if (reset)
            a <= 0;
        else if (a == 3'b111)
            a <= 0;
        else
            a <= a + 1;
            
endmodule

module Decoder( input [2:0] X, output reg [6:0] Y );
    
   always @(X)
   
        case(X)
        
            3'b001:
                Y=7'b1110111;
            3'b010:
                Y=7'b1111110;
            3'b100:
                Y=7'b0111111;
            3'b110:
                Y=7'b0111110;
            3'b101:
                Y=7'b0110111;
            3'b011:
                Y=7'b1110110;

                
            default:
                Y=7'b1111111;
            
    endcase
    
endmodule

module numDecoder( input [3:0] X, output reg [7:0] Y );
    
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

module display(input [2:0] sel, output reg [7:0] AN, output reg [6:0] out, output reg [6:0] out0, output reg [6:0] out1,
                output reg [6:0] out2, output reg [6:0] out3, output reg [6:0] out4, 
                output reg [6:0] out5, output reg [6:0] out6, output reg [6:0] out7);
    
    always @(sel)
        case (sel)
            3'b000:
                begin
                    AN <= 8'b11111110;
                    out <= out0;
                end
            3'b001:
                begin
                    AN <= 8'b11111101;
                    out <= out1;
                end
            3'b010:
                begin
                    AN <= 8'b11111011;
                    out <= out2;
                end
            3'b011:
                begin
                    AN <= 8'b11110111;
                    out <= out3;
                end
            3'b100:
                begin
                    AN <= 8'b11101111;
                    out <= out4;
                end
            3'b101:
                begin
                    AN <= 8'b1101111;
                    out <= out5;
                end
            3'b110:
                begin
                    AN <= 8'b10111111;
                    out <= out6;
                end
            3'b111:
                begin
                    AN <= 8'b01111111;
                    out <= out7;
                end
            default:
                begin
                end
        endcase
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

module HZ10ClkGen(clk, resetCLK, outsignal);
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
	       if (counter == 5_000_000) 
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

module HZ25ClkGen(clk, resetCLK, outsignal);
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
	       if (counter == 2_000_000) 
		      begin
			     outsignal=~outsignal;
			     counter =0;
		      end
           end
        end
        
endmodule

module OnionKing( input [9:0] number, 
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
 
always @ (number) begin
case(number) 
0: begin note = DS4;  duration = QUARTER;	end	
1: begin note = E4; duration = EIGHTH; end
2: begin note = SP; duration = EIGHTH; 	end	
3: begin note = C4; duration = EIGHTH; end
4: begin note = SP; duration = EIGHTH; 	end	
5: begin note = A3; duration = EIGHTH; end
6: begin note = SP; duration = EIGHTH;	end	
7: begin note = GS3; duration = EIGHTH; end
8: begin note = SP; duration = EIGHTH; end
9: begin note = A3; duration = EIGHTH; end
10: begin note = SP; duration = EIGHTH; end
11: begin note = C4; duration = EIGHTH;  end
12: begin note = SP; duration = EIGHTH; end
13: begin note = E4; duration = EIGHTH;  end
14: begin note = SP; duration = EIGHTH; end
15: begin note = G4; duration = EIGHTH;  end
16: begin note = SP; duration = EIGHTH; end
17: begin note = FS4; duration = EIGHTH;  end
18: begin note = SP; duration = EIGHTH; end
19: begin note = D4; duration = EIGHTH;  end
20: begin note = SP; duration = EIGHTH; end
21: begin note = F4; duration = EIGHTH;  end
22: begin note = SP; duration = EIGHTH; end
23: begin note = E4; duration = HALF;  end
24: begin note = SP; duration = EIGHTH; end
25: begin note = C4; duration = EIGHTH;  end
26: begin note = SP; duration = EIGHTH; end
27: begin note = SP; duration = EIGHTH; end

28: begin note = DS4;  duration = QUARTER;	end	
29: begin note = E4; duration = EIGHTH; end
30: begin note = SP; duration = EIGHTH; 	end	
31: begin note = C4; duration = EIGHTH; end
32: begin note = SP; duration = EIGHTH; 	end	
33: begin note = A3; duration = EIGHTH; end
34: begin note = SP; duration = EIGHTH;	end	
35: begin note = GS3; duration = EIGHTH; end
36: begin note = SP; duration = EIGHTH; end
37: begin note = A3; duration = EIGHTH; end
38: begin note = SP; duration = EIGHTH; end
39: begin note = C4; duration = EIGHTH;  end
40: begin note = SP; duration = EIGHTH; end
41: begin note = E4; duration = EIGHTH;  end
42: begin note = SP; duration = EIGHTH; end
43: begin note = G4; duration = EIGHTH;  end
44: begin note = SP; duration = EIGHTH; end
45: begin note = FS4; duration = EIGHTH;  end
46: begin note = SP; duration = EIGHTH; end
47: begin note = D4; duration = EIGHTH;  end
48: begin note = SP; duration = EIGHTH; end
49: begin note = F4; duration = EIGHTH;  end
50: begin note = SP; duration = EIGHTH; end
51: begin note = E4; duration = HALF;  end
51: begin note = SP; duration = EIGHTH; end
52: begin note = C4; duration = EIGHTH;  end
53: begin note = SP; duration = EIGHTH; end
54: begin note = SP; duration = EIGHTH; end

55: begin note = GS4;  duration = QUARTER;	end	
56: begin note = A4; duration = EIGHTH; end
57: begin note = SP; duration = EIGHTH; 	end	
58: begin note = F4; duration = EIGHTH; end
59: begin note = SP; duration = EIGHTH; 	end	
60: begin note = D4; duration = EIGHTH; end
61: begin note = SP; duration = EIGHTH;	end	
62: begin note = CS4; duration = EIGHTH; end
63: begin note = SP; duration = EIGHTH; end
64: begin note = D4; duration = EIGHTH; end
65: begin note = SP; duration = EIGHTH; end
66: begin note = F4; duration = EIGHTH;  end
67: begin note = SP; duration = EIGHTH; end
68: begin note = A4; duration = EIGHTH;  end
69: begin note = SP; duration = EIGHTH; end
70: begin note = C5; duration = EIGHTH;  end
71: begin note = SP; duration = EIGHTH; end
72: begin note = B4; duration = EIGHTH;  end
73: begin note = SP; duration = EIGHTH; end
74: begin note = G4; duration = EIGHTH;  end
75: begin note = SP; duration = EIGHTH; end
76: begin note = AS4; duration = EIGHTH;  end
77: begin note = SP; duration = EIGHTH; end
78: begin note = A4; duration = HALF;  end
79: begin note = SP; duration = EIGHTH; end
80: begin note = F4; duration = EIGHTH;  end
81: begin note = SP; duration = EIGHTH; end
82: begin note = SP; duration = EIGHTH; end

83: begin note = GS4;  duration = QUARTER;	end	
84: begin note = A4; duration = EIGHTH; end
85: begin note = SP; duration = EIGHTH; 	end	
86: begin note = F4; duration = EIGHTH; end
87: begin note = SP; duration = EIGHTH; 	end	
88: begin note = D4; duration = EIGHTH; end
89: begin note = SP; duration = EIGHTH;	end	
90: begin note = CS4; duration = EIGHTH; end
91: begin note = SP; duration = EIGHTH; end
92: begin note = D4; duration = EIGHTH; end
93: begin note = SP; duration = EIGHTH; end
94: begin note = F4; duration = EIGHTH;  end
95: begin note = SP; duration = EIGHTH; end
96: begin note = A4; duration = EIGHTH;  end
97: begin note = SP; duration = EIGHTH; end
98: begin note = C5; duration = EIGHTH;  end
99: begin note = SP; duration = EIGHTH; end
100: begin note = B4; duration = EIGHTH;  end
101: begin note = SP; duration = EIGHTH; end
102: begin note = G4; duration = EIGHTH;  end
103: begin note = SP; duration = EIGHTH; end
104: begin note = AS4; duration = EIGHTH;  end
105: begin note = SP; duration = EIGHTH; end
106: begin note = A4; duration = HALF;  end
107: begin note = SP; duration = EIGHTH; end
108: begin note = F4; duration = EIGHTH;  end

109: begin note = E5; duration = HALF;  end
110: begin note = C5; duration = HALF;  end
111: begin note = A4; duration = HALF;  end
112: begin note = F4; duration = HALF;  end
113: begin note = E4; duration = HALF;  end
114: begin note = C4; duration = HALF;  end
115: begin note = A3; duration = HALF;  end
116: begin note = F3; duration = HALF;  end
117: begin note = E3; duration = HALF;  end
118: begin note = C2; duration = HALF;  end
119: begin note = A2; duration = HALF;  end
120: begin note = F2; duration = HALF;  end

121: begin note = E2; duration = EIGHTH; end
122: begin note = F2; duration = EIGHTH; end
123: begin note = GS2; duration = EIGHTH; end
124: begin note = C3; duration = EIGHTH; end
125: begin note = E3; duration = EIGHTH; end
126: begin note = F3; duration = EIGHTH; end
127: begin note = GS3; duration = EIGHTH; end
128: begin note = C4; duration = EIGHTH; end
129: begin note = E4; duration = EIGHTH; end
130: begin note = F4; duration = EIGHTH; end
131: begin note = GS4; duration = EIGHTH; end
132: begin note = C5; duration = EIGHTH; end

133: begin note = D3; duration = EIGHTH; end
134: begin note = SP; duration = EIGHTH; 	end	
135: begin note = F3; duration = EIGHTH; end
136: begin note = SP; duration = EIGHTH; 	end	
137: begin note = D3; duration = EIGHTH; end
138: begin note = SP; duration = EIGHTH;	end	
139: begin note = F3; duration = EIGHTH; end
140: begin note = SP; duration = EIGHTH; end
141: begin note = A3; duration = EIGHTH; end
142: begin note = SP; duration = EIGHTH; end
143: begin note = GS3; duration = HALF;  end
144: begin note = SP; duration = EIGHTH; end

145: begin note = F3; duration = EIGHTH; end
146: begin note = SP; duration = EIGHTH; 	end	
147: begin note = D3; duration = EIGHTH; end
148: begin note = SP; duration = EIGHTH; 	end	
149: begin note = F3; duration = EIGHTH; end
150: begin note = SP; duration = EIGHTH;	end	
151: begin note = A3; duration = EIGHTH; end
152: begin note = SP; duration = EIGHTH; end
153: begin note = GS3; duration = EIGHTH; end
154: begin note = SP; duration = EIGHTH; end
155: begin note = F3; duration = EIGHTH;  end
156: begin note = SP; duration = EIGHTH; end
155: begin note = GS3; duration = EIGHTH;  end
157: begin note = SP; duration = EIGHTH; end
158: begin note = C4; duration = EIGHTH;  end
159: begin note = SP; duration = EIGHTH; end
160: begin note = B3; duration = EIGHTH;  end
161: begin note = SP; duration = EIGHTH; end

162: begin note = A3; duration = EIGHTH; end
163: begin note = SP; duration = EIGHTH; 	end	
164: begin note = C4; duration = EIGHTH; end
165: begin note = SP; duration = EIGHTH; 	end	
166: begin note = A3; duration = EIGHTH; end
167: begin note = SP; duration = EIGHTH;	end	
168: begin note = C4; duration = EIGHTH; end
169: begin note = SP; duration = EIGHTH; end
170: begin note = E4; duration = EIGHTH; end
171: begin note = SP; duration = EIGHTH; end
172: begin note = DS4; duration = HALF;  end
173: begin note = SP; duration = EIGHTH; end

174: begin note = C4; duration = EIGHTH; end
175: begin note = SP; duration = EIGHTH; 	end	
176: begin note = A3; duration = EIGHTH; end
177: begin note = SP; duration = EIGHTH; 	end	
178: begin note = C4; duration = EIGHTH; end
179: begin note = SP; duration = EIGHTH;	end	
180: begin note = G4; duration = EIGHTH; end
181: begin note = SP; duration = EIGHTH; end
182: begin note = FS4; duration = EIGHTH; end
183: begin note = SP; duration = EIGHTH; end
184: begin note = D4; duration = EIGHTH;  end
185: begin note = SP; duration = EIGHTH; end
186: begin note = F4; duration = EIGHTH;  end
187: begin note = SP; duration = EIGHTH; end
188: begin note = C5; duration = EIGHTH;  end
189: begin note = SP; duration = EIGHTH; end
190: begin note = B4; duration = EIGHTH;  end
191: begin note = SP; duration = EIGHTH; end

192: begin note = A4; duration = ONE;  end
193: begin note = SP; duration = ONE; end
194: begin note = A4; duration = EIGHTH;  end
195: begin note = B4; duration = EIGHTH;  end
196: begin note = A4; duration = HALF;  end
197: begin note = SP; duration = HALF; end
198: begin note = G4; duration = HALF;  end
199: begin note = SP; duration = HALF; end

200: begin note = A4; duration = HALF;  end
201: begin note = SP; duration = HALF; end
202: begin note = G4; duration = ONE;  end

203: begin note = SP; duration = ONE; end
204: begin note = SP; duration = ONE; end

205: begin note = F4; duration = ONE;  end
206: begin note = SP; duration = ONE; end
207: begin note = F4; duration = EIGHTH;  end
208: begin note = G4; duration = EIGHTH;  end
209: begin note = F4; duration = HALF;  end
210: begin note = SP; duration = HALF; end
211: begin note = D4; duration = HALF;  end
212: begin note = SP; duration = HALF; end

213: begin note = E4; duration = ONE;  end
214: begin note = SP; duration = ONE; end
215: begin note = GS4; duration = ONE;  end
216: begin note = SP; duration = ONE; end

217: begin note = A4; duration = ONE;  end
218: begin note = SP; duration = ONE; end
219: begin note = A4; duration = EIGHTH;  end
220: begin note = B4; duration = EIGHTH;  end
221: begin note = A4; duration = HALF;  end
222: begin note = SP; duration = HALF; end
223: begin note = G4; duration = HALF;  end
224: begin note = SP; duration = HALF; end

225: begin note = A4; duration = HALF;  end
226: begin note = SP; duration = HALF; end
227: begin note = G4; duration = ONE;  end

228: begin note = SP; duration = ONE; end
229: begin note = SP; duration = ONE; end

230: begin note = A4; duration = ONE;  end
231: begin note = SP; duration = ONE; end
232: begin note = A4; duration = EIGHTH;  end
233: begin note = AS4; duration = EIGHTH;  end
234: begin note = A4; duration = HALF;  end
235: begin note = SP; duration = HALF; end
236: begin note = G4; duration = HALF;  end
237: begin note = SP; duration = HALF; end

238: begin note = A4; duration = ONE;  end
239: begin note = SP; duration = ONE; end
240: begin note = GS4; duration = ONE;  end
241: begin note = SP; duration = ONE; end






default: 	begin note = C4; duration = FOUR; 	end
endcase
end
endmodule


module PekoSong( input [9:0] number, 
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

//Peko Theme

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


module SongPlayer( input clock, input reset, input playSound, output reg audioOut, output wire aud_sd);
reg [19:0] counter;
reg [31:0] time1, noteTime;
reg [9:0] msec, number;	//millisecond counter, and sequence number of musical note.
wire [4:0] note, duration;
wire [19:0] notePeriod;
parameter clockFrequency = 100_000_000; 

assign aud_sd = 1'b1;

//PekoSong pekopeko(number, notePeriod, duration);
OnionKing pog(number, notePeriod, duration);

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
        if(number == 243) number <=0; // Make the number reset at the end of the song
	       end
        end	
         
  always @(duration) noteTime = duration * clockFrequency / 12; 
       //number of   FPGA clock periods in one note.
endmodule

module edge_detect_mealy (input wire clk, reset, level, output reg tick);
     localparam zero=1'b0, one=1'b1;
     reg state_reg, state_next;
     always @(posedge clk, posedge reset)
           if (reset)
	state_reg<=zero;
           else
	state_reg<=state_next;
       always@*
            begin
    	state_next=state_reg;
	tick=1'b0;
	case (state_reg)
	   zero:
	        if (level)
	          begin
		tick=1'b1; //this change is immediate
		state_next=one;
	           end
	   one: 
	       if (~level)
		state_next=zero;
	  default: 	 
		state_next=zero;
                         endcase
            end
endmodule


module upButton (reset, upSig, downSig, midSig, pos);
	input reset, upSig, downSig, midSig;
	output reg [2:0] pos;
	
	always @(negedge reset, posedge upSig, posedge downSig, posedge midSig)
	 	if (reset)
	 	      begin
			    pos <= 3'b010;
		      end
		else 
		begin
		  if (upSig) pos <= 3'b100;
		  else if (midSig) pos <= 3'b010;
		  else if (downSig) pos <= 3'b001;
		end
endmodule

//module downButton (reset, inSig, prePos, pos);
//	input reset, inSig;
//	input [2:0] prePos;
//	output reg [2:0] pos;
	
//	always @(negedge reset, posedge inSig)
//	 	if (reset)
//	 	      begin
//			    pos <= 3'b010;
//		      end
//		else if (pos == 3'b001)
//		      begin
//                pos <= 3'b001;
//		      end
//		else if (pos == 3'b010)
//		      begin
//                pos <= 3'b001;
//		      end
//		else 
//		      begin
//                pos <= 3'b010;
//		      end
//endmodule