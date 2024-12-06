//Shown "SNAKE (GAME)" (and "PRESS ANY KEY") in the Start Page
`include "../libs/define.vh"

module page_start
(
    vga_clk,
    sys_rst_n,
    screen_x,
    screen_y,
    pix_data
);

input wire             vga_clk      ;
input wire             sys_rst_n    ;
input wire             screen_x     ;
input wire             screen_y     ;

output reg             pix_data     ;

reg                    letter_req   ;
reg               letter_req_colored;
reg                    stringIndex  ;
reg                    arrayindex   ;

parameter SNAKE_LEFT =(VGA_WIDTH/2) - 160 - 1;
parameter SNAKE_RGHT =(VGA_WIDTH/2) + 160 - 1;
parameter SNAKE_TOP  =(VGA_HEIGHT/2) - 32 - 1;
parameter SNAKE_BTM  =(VGA_HEIGHT/2) + 32 - 1;

parameter P_A_K_LEFT =(VGA_WIDTH/2) - 104 - 1;
parameter P_A_K_RGHT =(VGA_WIDTH/2) + 104 - 1;
parameter P_A_K_TOP  = 384;
parameter P_A_K_BTM  = 400;

parameter WHITE = 16'h0000;
parameter BLACK = 16'hFFFF;
parameter SNAKE_COLOUR = 16'h5746;

always@(posedge vga_clk or negedge sys_rst_n)begin

    if(sys_rst_n == 1'b0)begin
        if(((pix_x >= SNAKE_LEFT)&&(pix_x <= SNAKE_RGHT))&&
            ((pix_y >= SNAKE_TOP)&&(pix_y <= SNAKE_BTM)))begin
                letter_req = {22,13,0,10,4};//"SNAKE GAME"
                stringIndex <= (screen_x-SNAKE_LEFT)/16
                letter_i <= letter_req[arrayindex];
                letter_x <= screen_x-SNAKE_LEFT;
                letter_y <= screen_y-SNAKE_TOP;

                case(letter_req)
                    1'b0:   letter_req_colored = 16'h4040;//test* it should be BLACK(FFFF)
                    1'b1:   letter_req_colored = SNAKE_COLOUR;
                    default:letter_req_colored = 16'h4040;//test* it should be BLACK(FFFF)
                endcase

                pix_data = letter_req_colored;
            end
        else if(((pix_x >= P_A_K_LEFT)&&(pix_x <= P_A_K_RGHT))&&
                ((pix_y >= P_A_K_TOP)&&(pix_y <= P_A_K_BTM)))begin
                letter_req = {15,17,4,18,18,26,0,13,24,26,10,4,24};//"PRESS ANY KEY"
                stringIndex <= (screen_x-P_A_K_LEFT)/16
                letter_i <= letter_req[arrayindex];
                letter_x <= screen_x-P_A_K_LEFT;
                letter_y <= screen_y-P_A_K_TOP;

                case(letter_req)
                    1'b0:   letter_req_colored = 16'h4040;//test* it should be BLACK(FFFF)
                    1'b1:   letter_req_colored = WHITE;
                    default:letter_req_colored = 16'h4040;//test* it should be BLACK(FFFF)
                endcase

                pix_data = letter_req_colored;
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