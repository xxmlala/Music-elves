module main(
    input S0,S1,S2,S3,S4,
    input clr,clr0,clr1,clr2,clk100mhz,
    output  sound,power,
    output [7:0]pos,
    output [15:0]seg
    );
    
    wire s0,s1,s2,s3,s4;
    wire clk190hz,clk3hz,clk6hz,clk1mhz;
    wire [7:0]control_position,how_long,play_position;
    wire [300:0] rhyme,md;
    wire [3:0] single_music,play_music,play_md,single_md;
    wire start_;
    
    cpu U1(clr,s2,clk1mhz,clk100mhz,clk6hz,start_,how_long,rhyme,md,single_music,single_md,sound,power,play_music,play_position,play_md); 
    gpu U2(clr,clk190hz,single_md,play_md,single_music,play_music,control_position,play_position,pos[7:4],seg[15:8],pos[3:0],seg[7:0]);
    control U3(clk6hz,clk100mhz,clr,clr0,clr1,clr2,s0,s1,s3,s4,start_,control_position,rhyme,md,single_music,single_md,how_long);
    
    clkDiv C1(clk100mhz,clk190hz,clk6hz,clk1mhz);
    
    xd k0(S0,clk100mhz,s0);
    xd k1(S1,clk100mhz,s1);
    xd k2(S2,clk100mhz,s2);
    xd k3(S3,clk100mhz,s3);
    xd k4(S4,clk100mhz,s4);
    
    
endmodule
