module cpu(
    input clr,s2,clk1mhz,clk100mhz,clk6hz,start_,
    input [7:0]how_long,
    input [300:0]rhyme,
    input [300:0]md,
    input [3:0]single_music,
    input [1:0]single_md,
    output reg sound,power,
    output  [3:0]play_music,
    output reg [7:0]play_position,
    output  [3:0]play_md
    );
    reg [31:0]countSlow;
    reg [4:0]mic;
    reg [17:0]quti;
    reg [31:0]speed;
    reg start;
    reg [25:0]count_single;
    reg [5:0]mic_t;
    assign play_music ={1'b0,mic[2:0]};
    assign play_md = {2'b00,mic[4:3]};
    always @(posedge clk6hz)
        if(!clr&&s2)
            start <= !start;
            
    always @(posedge clk100mhz) begin
        if((start&&!clr)||(start_&&!count_single[25]))
            power <= !power;
        else power <= 0;
        if(start_&&!count_single[25]) begin
            count_single <= count_single + 1;
        end
        else if(!start_||!clr)
            count_single <= 0;
    end
    always @(mic) begin
        case(mic)
            0: quti <= 1;
            1: quti <= 95557;//95200;
            2: quti <= 85131;//85100;/////////////////
            3: quti <= 75844;//75800;
            4: quti <= 71586;//71600;//////////////////
            5: quti <= 63776;//63800;
            6: quti <= 56818;//56800;
            7: quti <= 50619;//50600;
            9: quti <= 191110;//191100;
            10: quti <= 170265;////170300;
            11: quti<= 151685;//150200;
            12: quti<= 143172;//143200;
            13: quti<= 127551;//127600;
            14: quti<= 113636;//113600;
            15: quti<= 101239;//101200;
            17: quti<= 47778;//47800;
            18: quti<= 42566;//42600;
            19: quti<= 37922;//37900;
            20: quti<= 35793;////35800;
            21: quti<= 31888;//31900;
            22: quti<= 28409;//28400;
            23: quti<= 25310;//25300;
            default: quti <= 1;
        endcase
    end
    always @(posedge clk100mhz) begin
        if(clr) begin
            play_position <= 0;
            mic <= {single_md,single_music[2:0]};
        end
        else if(start) begin   
            speed <= (speed + 1) % 30000000;
            if(speed == 0) begin
                mic <= rhyme/(1 << (4*play_position) )%(16) + md/(1 << (4*play_position) )%(16) * 8 ;
                if(play_position == how_long - 1)
                    play_position <= 0;
                else    
                    play_position <= play_position + 1;
            end
        end
    end
    
    always @(posedge clk100mhz) begin
        if(countSlow == 0) begin
            sound <= !sound;
        end
        countSlow <= (countSlow + 1)%quti;
    end
endmodule
