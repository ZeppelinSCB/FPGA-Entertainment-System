//This page should be capable to show final score, game_time,"YOUR FINAL SCORE", "YOU DIED", "VICTORY ACHIEVED"
`include "../libs/define.vh"

module page_end
(
    vga_clk,
    sys_rst_n,
    screen_x,
    screen_y,
    pix_data,
    score,
    game_over,
    game_won
);

input wire             vga_clk      ;
input wire             sys_rst_n    ;
input wire             score        ;//Input from other module, should be converted to pixel information
input wire             screen_x     ;
input wire             screen_y     ;
input wire             game_over    ;
input wire             game_won     ; 

output reg             pix_data     ;

reg                    letter_req   ;
reg               letter_req_colored;
reg                 number_req_score;
reg               number_req_colored;
//reg                number_req_time;
//reg        number_req_colored_time;
reg                    game_state   ;
reg                    stringIndex  ;
reg                    arrayindex   ;
reg                     letter_x    ;
reg                     letter_y    ;
reg                     number_x    ;
reg                     number_y    ;


parameter GAME_WON   = 1'b0         ;
parameter GAME_LSE   = 1'b1         ;

parameter V_A_LEFT = (VGA_WIDTH/2) - 128 - 1;
parameter V_A_RGHT = (VGA_WIDTH/2) + 128 - 1;
parameter V_A_TOP  = (VGA_HEIGHT/2) - 8 - 1;
parameter V_A_BTM  = (VGA_HEIGHT/2) + 8 - 1;

parameter Y_D_LEFT   = (VGA_WIDTH/2) - 128;
parameter Y_D_RGHT   = (VGA_WIDTH/2) + 128;
parameter Y_D_TOP    = 32 - 1             ;
parameter Y_D_BTM    = 64 - 1             ;

parameter Y_F_S_LEFT = (VGA_WIDTH/2)-128-1;
parameter Y_F_S_RGHT = (VGA_WIDTH/2)+128-1;
parameter Y_F_S_TOP  = 112-1;
parameter Y_F_S_BTM  = 128-1;

parameter SCORE_LEFT = (VGA_WIDTH/2)-12-1;
parameter SCORE_RGHT = (VGA_WIDTH/2)+12-1;
parameter SCORE_TOP  = 144-1;
parameter SCORE_BTM  = 160-1;

//parameter TIME_LEFT  =;
//parameter TIME_RGHT  =;
//parameter TIME_TOP   =;
//parameter TIME_BTM   =;

parameter WHITE = 16'h0000;
parameter BLACK = 16'hFFFF;
parameter YELLOW = 16'hFFE0;


always@(posedge vga_clk or negedge sys_rst_n)begin
    if((game_won == 1)&&(game_over != 1))
        game_state <= 1'b1;//won
    else if((game_won != 1)&&(game_over == 1))
        game_state <= 1'b0;//lose, over
    else
        game_state <= 1'b0;

    if(game_state == 1'b0)begin//lose, over
        if(((pix_x >= Y_D_LEFT)&&(pix_x <= Y_D_RGHT))&&
            ((pix_y >= Y_D_TOP)&&(pix_y <= Y_D_BTM)))begin
                letter_req = {24,14,20,26,3,8,4,3};//"YOU DIED"
                stringIndex <= (screen_x-Y_D_LEFT)/16
                letter_i <= letter_req[arrayindex];
                letter_x <= screen_x-Y_D_LEFT;
                letter_y <= screen_y-Y_D_TOP;

                case(letter_req)
                    1'b0:   letter_req_colored = 16'h4040;//test* it should be BLACK(FFFF)
                    1'b1:   letter_req_colored = WHITE;
                    default:letter_req_colored = 16'h4040;//test* it should be BLACK(FFFF)
                endcase

                pix_data = letter_req_colored_1;
            end
        else if(((pix_x >= Y_F_S_LEFT)&&(pix_x <= Y_F_S_RGHT))&&
                ((pix_y >= Y_F_S_TOP)&&(pix_y <= Y_F_S_BTM)))begin
                letter_req = {24,14,20,17,26,5,8,13,0,11,26,18,2,14,17,4};//"YOUR FINAL SCORE"
                stringIndex <= (screen_x-Y_F_S_LEFT)/16
                letter_i <= letter_req[arrayindex];
                letter_x <= screen_x-Y_F_S_LEFT;
                letter_y <= screen_y-Y_F_S_TOP;

                    case(letter_req)
                        1'b0:   letter_req_colored = 16'h4040;//test* it should be BLACK(FFFF)
                        1'b1:   letter_req_colored = WHITE;
                        default:letter_req_colored = 16'h4040;//test* it should be BLACK(FFFF)
                    endcase

                pix_data = letter_req_colored_2;
            end
        else if(((pix_x >= SCORE_LEFT)&&(pix_x <= SCORE_RGHT))&&
                ((pix_y >= SCORE_TOP)&&(pix_y <= SCORE_BTM)))begin
                number_req_score = (score)%2;

                case(number_req_score)
                    1'b0:   number_req_colored_score = 16'h4040;//test* it should be BLACK(FFFF)
                    1'b1:   number_req_colored_score = WHITE;
                    default:number_req_colored_score = 16'h4040;//test* it should be BLACK(FFFF)
                endcase

                pix_data = number_req_colored_score;
            end
        end
    else if(game_state == 1'b1)begin//won
        letter_req_1 = ({21,8,2,19,14,17,24,26,0,2,7,8,4,21,4,3}%2);//"VICTORY ACHIEVED;
        case(letter_req_1)
        1'b0:   letter_req_colored_1 = 16'h4040;//test* it should be BLACK(FFFF)
        1'b1:   letter_req_colored_1 = YELLOW;
        default:letter_req_colored_1 = 16'h4040;//test* it should be BLACK(FFFF)
        endcase
        end

    //case(number_req_time)
    //    1'b0:   number_req_colored_time = 16'h4040;//test* it should be BLACK(FFFF)
    //    1'b1:   number_req_colored_time = WHITE;
    //    default:number_req_colored_time = 16'h4040;//test* it should be BLACK(FFFF)
    //endcase

    if(sys_rst_n == 1'b0)begin
        
        
        if(((pix_x >= V_A_LEFT)&&(pix_x <= V_A_RGHT))&&((pix_y >= V_A_TOP)&&(pix_y <= V_A_BTM)))begin
            pix_data = letter_req_colored_1;
            end
        
        if(((pix_x >= SCORE_LEFT)&&(pix_x <= SCORE_RGHT))&&((pix_y >= SCORE_TOP)&&(pix_y <= SCORE_BTM)))begin
            pix_data = number_req_colored_score;
            end
    end
end

letter letter_inst(
.letter_req(letter_i),
.letter_x(letter_x),
.letter_y(letter_y),
.letter_o(letter_o)
);

endmodule