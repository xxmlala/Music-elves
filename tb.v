`timescale 1ns / 1ps  
module tb();  
reg S0,S1,S2,S3,S4;
reg clr,clr0,clr1,clk100mhz;
wire sound,power;
wire [7:0] pos;
wire [15:0] seg;
initial  
begin  
#100 clr = 1;
#200 clr1 = 1;
#300 clr = 0;
#400 clr = 0;
#500 s2 = 1;
#550 s2 = 0;
end  

always #10 clk100mhz=~clk100mhz;

main m1(S0,S1,S2,S3,S4,clr,clr0,clr1,clk100mhz,sound,power,pos,seg);
cpu U1(clr,s2,clk100mhz,clk6hz,start_,how_long,rhyme,single_music,sound,power,play_music,play_position); 
gpu U2(clr,clk190hz,single_music,play_music,control_position,play_position,pos[7:4],seg[15:8],pos[3:0],seg[7:0]);
control U3(clk6hz,clk100mhz,clr,clr0,clr1,s0,s1,s3,s4,start_,control_position,rhyme,single_music,how_long);
clkDiv C1(clk100mhz,clk190hz,clk6hz);


endmodule