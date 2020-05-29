module control(
    input clk6hz,clk100mhz,
    input clr,clr0,clr1,clr2,
    input s0,s1,s3,s4,
    output reg start_,
    output [7:0]control_position,
    output [300:0] rhyme,md,
    output [3:0]single_music,
    output reg [3:0]single_md,
    output reg [7:0] how_long
    );
    parameter canon = 301'h5432_1765_1766_5644_6543_3212_2344_5644_5435_4565_4333_2133_4321_7655_4355_4355;
    parameter tiger = 301'h0011_5522_0011_5522_1133_4565_1133_4565_0055_4433_0055_4433_1133_2211_1133_2211;
    parameter canon_md = {48'h2222_2000_2000,112'h0,96'h0022_2222_2222_0002_2222_2222};
    reg [300:0]last_rhyme,last_md=0;
    reg [7:0]control_i;
    reg [3:0]music;
    assign control_position = control_i;
    assign rhyme = last_rhyme;
    assign single_music = music;
    assign md = last_md;
    
    always @(last_md,control_i)
         single_md <= last_md/(1 << (4*control_i) )%(16);
    always @(last_rhyme,control_i)
        music <= last_rhyme/(1 << (4*control_i) )%(16);
    always @(posedge clk6hz) begin
        if(!clr) begin 
            control_i <= 0;
            start_ <= 0;
            //last_md <= 0;
        end
        else if(s0||s3) begin
            start_ <= 1;
            if(s0 && control_i < 70) 
                control_i <= control_i + 1;
            else if(s3 && control_i > 0)
                control_i <= control_i - 1;
            else control_i <= control_i;
        end
        else if(s1||s4) begin
            start_ <= 1;
            if(s1)begin
                if(last_rhyme/(1 << (4*control_i) )%(16) > 0) 
                    last_rhyme <= last_rhyme - (1<<( 4*(control_i) ));
                else if(last_md/(1 << (4*control_i) )%(16)!=1) begin
                    last_rhyme <= last_rhyme|(7<<(4*control_i));
                    if(last_md/(1 << (4*control_i) )%(16) == 0)
                        last_md <= last_md - last_md/(1 << (4*control_i) )%(16)*(1<<(4*control_i)) + (1<<(4*control_i));
                    else last_md <= last_md - last_md/(1 << (4*control_i) )%(16)*(1<<(4*control_i));
                end
                   
            end
            else if(s4) begin
                if(last_rhyme/(1 << (4*control_i) )%(16) < 7) 
                    last_rhyme <= last_rhyme + (1<<( 4*(control_i) ));
                else if(last_md/(1 << (4*control_i) )%(16)!=2) begin
                    last_rhyme <= last_rhyme - last_rhyme/(1 << (4*control_i) )%(16) * (1<<( 4*(control_i) ));
                    if(last_md/(1 << (4*control_i) )%(16) == 1) begin
                        last_md <= last_md - last_md/(1 << (4*control_i) )%(16)*(1<<(4*control_i));
                    end
                    else last_md <= last_md - last_md/(1 << (4*control_i) )%(16)*(1<<(4*control_i)) + 2*(1<<(4*control_i));
                end
            end
            else begin
                last_rhyme <= last_rhyme;
                last_md <= last_md;
            end
        end
        else if(clr0) begin
            start_ <= 0;
            last_rhyme <= 0;
            control_i <= 0;
            last_md <= 0;
        end
        else if(clr1) begin
            start_ <= 0;
            control_i <= 0;
            last_rhyme <= tiger;
            //last_md <= {64'h0000_1100_0000_1100,237'h0};
            last_md[207:200]<=8'h11;
            last_md[239:232]<=8'h11;
            //last_md <= 0;
        end
        else if(clr2) begin
            start_ <= 0;
            control_i <= 0;
            last_rhyme <= canon;
            last_md <= canon_md;
        end
        else start_ <= 0;
    end
    
    always @(posedge clk100mhz) begin
        if(!clr) ;
        else if(clr0) 
            how_long <= 0;
        else if(clr1||clr2) 
            how_long <=64;
        else if(control_i+1>how_long) 
            how_long <= control_i + 1;
        
    end
endmodule
