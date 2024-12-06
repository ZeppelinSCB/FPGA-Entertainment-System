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
    letter_i,
    letter_x,
    letter_y,
    number_x,
    number_y,
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
output reg             letter_i     ;
output reg             letter_x     ;
output reg             letter_y     ;
output reg              number_x    ;
output reg              number_y    ;

reg [32:0]              letter_req  ;
reg               letter_req_colored;
reg                 number_req_score;
reg         number_req_colored_score;
//reg                number_req_time;
//reg        number_req_colored_time;
reg                    game_state   ;
reg                    stringIndex  ;
reg                    arrayindex   ;




parameter V_A_LEFT = (`VGA_WIDTH/2) - 128 - 1;
parameter V_A_RGHT = (`VGA_WIDTH/2) + 128 - 1;
parameter V_A_TOP  = (`VGA_HEIGHT/2) - 8 - 1;
parameter V_A_BTM  = (`VGA_HEIGHT/2) + 8 - 1;

parameter Y_D_LEFT   = (`VGA_WIDTH/2) - 128;
parameter Y_D_RGHT   = (`VGA_WIDTH/2) + 128;
parameter Y_D_TOP    = 32 - 1             ;
parameter Y_D_BTM    = 64 - 1             ;

parameter Y_F_S_LEFT = (`VGA_WIDTH/2)-128-1;
parameter Y_F_S_RGHT = (`VGA_WIDTH/2)+128-1;
parameter Y_F_S_TOP  = 112-1;
parameter Y_F_S_BTM  = 128-1;

parameter SCORE_LEFT = (`VGA_WIDTH/2)-12-1;
parameter SCORE_RGHT = (`VGA_WIDTH/2)+12-1;
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
    if(!sys_rst_n)
        if(game_won == 1)
            game_state = 1;
        else if(game_over == 1)
            game_state = 0;
        else
            game_state = 0;
end

always@(posedge vga_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)
        if(game_state == 1'b0)begin//lose, over
            if(((screen_x >= Y_D_LEFT)&&(screen_x <= Y_D_RGHT))&&
                ((screen_y >= Y_D_TOP)&&(screen_y <= Y_D_BTM)))begin
                    letter_req = {5'd24,5'd14,5'd20,5'd26,5'd3,5'd8,5'd4,5'd3};//"YOU DIED"
                    stringIndex <= (screen_x-Y_D_LEFT)/16;
                    letter_i <= letter_req[arrayindex];
                    letter_x <= screen_x-Y_D_LEFT;
                    letter_y <= screen_y-Y_D_TOP;

                    case(letter_req)
                        1'b0:   letter_req_colored = 16'h4040;//test* it should be BLACK(FFFF)
                        1'b1:   letter_req_colored = WHITE;
                        default:letter_req_colored = 16'h4040;//test* it should be BLACK(FFFF)
                    endcase

                    pix_data = letter_req_colored;
                end
            else if(((screen_x >= Y_F_S_LEFT)&&(screen_x <= Y_F_S_RGHT))&&
                    ((screen_y >= Y_F_S_TOP)&&(screen_y <= Y_F_S_BTM)))begin
                    letter_req = {5'd24,5'd14,5'd20,5'd17,5'd26,5'd5,5'd8,5'd13,5'd0,5'd11,5'd26,5'd18,5'd2,5'd14,5'd17,5'd4};//"YOUR FINAL SCORE"
                    stringIndex <= (screen_x-Y_F_S_LEFT)/16;
                    letter_i <= letter_req[arrayindex];
                    letter_x <= screen_x-Y_F_S_LEFT;
                    letter_y <= screen_y-Y_F_S_TOP;

                        case(letter_req)
                            1'b0:   letter_req_colored = 16'h4040;//test* it should be BLACK(FFFF)
                            1'b1:   letter_req_colored = WHITE;
                            default:letter_req_colored = 16'h4040;//test* it should be BLACK(FFFF)
                        endcase

                    pix_data = letter_req_colored;
                end
            else if(((screen_x >= SCORE_LEFT)&&(screen_x <= SCORE_RGHT))&&
                    ((screen_y >= SCORE_TOP)&&(screen_y <= SCORE_BTM)))begin
                    number_req_score = score;

                    case(number_req_score)
                        1'b0:   number_req_colored_score = 16'h4040;//test* it should be BLACK(FFFF)
                        1'b1:   number_req_colored_score = WHITE;
                        default:number_req_colored_score = 16'h4040;//test* it should be BLACK(FFFF)
                    endcase

                    pix_data = number_req_colored_score;
                end
            end
        else if(game_state == 1'b1)begin//won
            letter_req = {5'd21,5'd8,5'd2,5'd19,5'd14,5'd17,5'd24,5'd26,5'd0,5'd2,5'd7,5'd8,5'd4,5'd21,5'd4,5'd3};//"VICTORY ACHIEVED;
            stringIndex <= (screen_x-V_A_LEFT)/16;
            letter_i <= letter_req[arrayindex];
            letter_x <= screen_x-V_A_LEFT;
            letter_y <= screen_y-V_A_TOP;
            case(letter_req)
            1'b0:   letter_req_colored = 16'h4040;//test* it should be BLACK(FFFF)
            1'b1:   letter_req_colored = YELLOW;
            default:letter_req_colored = 16'h4040;//test* it should be BLACK(FFFF)
            endcase
            end

        //case(number_req_time)
        //    1'b0:   number_req_colored_time = 16'h4040;//test* it should be BLACK(FFFF)
        //    1'b1:   number_req_colored_time = WHITE;
        //    default:number_req_colored_time = 16'h4040;//test* it should be BLACK(FFFF)
        //endcase

        if(sys_rst_n == 1'b0)begin


            if(((screen_x >= V_A_LEFT)&&(screen_x <= V_A_RGHT))&&((screen_y >= V_A_TOP)&&(screen_y <= V_A_BTM)))begin
                pix_data = letter_req_colored;
                end

            if(((screen_x >= SCORE_LEFT)&&(screen_x <= SCORE_RGHT))&&((screen_y >= SCORE_TOP)&&(screen_y <= SCORE_BTM)))begin
                pix_data = number_req_colored_score;
                end
        end
end

letter_character letter_character_inst(
.letter_i(letter_req),
.letter_x(letter_x),
.letter_y(letter_y),
.letter_o(letter_o)
);

endmodule