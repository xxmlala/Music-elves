module gpu(clr,clk190hz,single_md,play_md,single_music,play_music,control_position,play_position,pos,seg,pos_,seg_);
input clr;
input clk190hz;
input [3:0] single_music,play_music,single_md,play_md;
input [7:0] control_position,play_position;
output reg [3:0] pos;
output reg [7:0] seg;
output reg [3:0] pos_;
output reg [7:0] seg_;

reg [1:0] posC;
reg [1:0] posC_;
reg [3:0] dataP;
reg [3:0] dataP_;

always@(posedge clk190hz)begin
    case(posC)
        0:begin
            pos <= 4'b0001; 
            dataP <= 10;
        end
        1:begin
            pos <= 4'b0010;
            if(clr)
                dataP <= (control_position + 1) % 10;
            else dataP <= (play_position + 1) % 10;
          end
        2:begin
            pos <= 4'b0100;
            if(clr)
                dataP <= (control_position + 1) / 10;
            else dataP <= (play_position + 1) / 10;
          end
        3:begin
            pos <= 4'b1000;
            dataP <= 10;
          end
     endcase
     posC <= posC + 1;
     
end

always@(posedge clk190hz)begin
    case(posC_)
        0:begin
            pos_ <= 4'b0001;
            dataP_ <= 10;
          end
        1:begin
            pos_ <= 4'b0010;
            if(clr)
                dataP_ <= single_music;
            else dataP_ <= play_music;
          end
        2:begin
            pos_ <= 4'b0100;
            if(clr) 
                case(single_md)
                   0: dataP_ <= 14;
                   1: dataP_ <= 13;
                   2: dataP_ <= 12;
                endcase  
            else
                case(play_md)
                   0: dataP_ <= 14;
                   1: dataP_ <= 13;
                   2: dataP_ <= 12;
                endcase
            //dataP_ <= 13;
          end
        3:begin
            pos_ <= 4'b1000;
            dataP_ <= 10;
          end
     endcase
     posC_ <= posC_ + 1;
end

always@(dataP,dataP_)
begin
        case(dataP)
            0:seg=8'b0011_1111;
            1:seg=8'b0000_0110;
            2:seg=8'b0101_1011;
            3:seg=8'b0100_1111;
            4:seg=8'b0110_0110;
            5:seg=8'b0110_1101;
            6:seg=8'b0111_1101;
            7:seg=8'b0000_0111;
            8:seg=8'b0111_1111;
            9:seg=8'b0110_1111;
            10:seg=8'b0100_0000;
            11:seg=8'b0000_0000;
            default:seg=8'b0000_1000;
        endcase
        case(dataP_)
            0:seg_=8'b0011_1111;
            1:seg_=8'b0000_0110;
            2:seg_=8'b0101_1011;
            3:seg_=8'b0100_1111;
            4:seg_=8'b0110_0110;
            5:seg_=8'b0110_1101;
            6:seg_=8'b0111_1101;
            7:seg_=8'b0000_0111;
            8:seg_=8'b0111_1111;
            9:seg_=8'b0110_1111;
            10:seg_=8'b0100_0000;
            11:seg_=8'b0000_0000;
            12:seg_=8'b0111_0110;//h
            13:seg_=8'b0011_1000; //l
            14:seg_=8'b0111_1001;//m
            default:seg_=8'b0000_1000;
        endcase
        end
endmodule