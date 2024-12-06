//Shown "SNAKE (GAME)" (and "PRESS ANY KEY") in the Start Page
`include "../libs/define.vh"

module page_start
(
    vga_clk,
    sys_rst_n,
    screen_x,
    screen_y,
    letter_i,
    letter_x,
    letter_y,
    pix_data
);

input wire             vga_clk      ;
input wire             sys_rst_n    ;
input wire             screen_x     ;
input wire             screen_y     ;

output reg             pix_data     ;
output reg             letter_i     ;
output reg             letter_x     ;
output reg             letter_y     ;

reg [32:0]              letter_req  ;
reg               letter_req_colored;
reg                    stringIndex  ;
reg                    arrayindex   ;

parameter SNAKE_LEFT =(`VGA_WIDTH/2) - 160 - 1;
parameter SNAKE_RGHT =(`VGA_WIDTH/2) + 160 - 1;
parameter SNAKE_TOP  =(`VGA_HEIGHT/2) - 32 - 1;
parameter SNAKE_BTM  =(`VGA_HEIGHT/2) + 32 - 1;

parameter P_A_K_LEFT =(`VGA_WIDTH/2) - 104 - 1;
parameter P_A_K_RGHT =(`VGA_WIDTH/2) + 104 - 1;
parameter P_A_K_TOP  = 384;
parameter P_A_K_BTM  = 400;

parameter WHITE = 16'h0000;
parameter BLACK = 16'hFFFF;
parameter SNAKE_COLOUR = 16'h5746;

always@(posedge vga_clk or negedge sys_rst_n)begin

    if(sys_rst_n == 1'b0)begin
        if(((screen_x >= SNAKE_LEFT)&&(screen_x <= SNAKE_RGHT))&&
            ((screen_y >= SNAKE_TOP)&&(screen_y <= SNAKE_BTM)))begin
                letter_req = {5'd22,5'd13,5'd0,5'd10,5'd4};//"SNAKE GAME"
                stringIndex <= (screen_x-SNAKE_LEFT)/16;
                letter_i <= letter_req[arrayindex];
                letter_x <= (screen_x-SNAKE_LEFT)/4;
                letter_y <= (screen_y-SNAKE_TOP)/4;

                case(letter_req)
                    1'b0:   letter_req_colored = 16'h4040;//test* it should be BLACK(FFFF)
                    1'b1:   letter_req_colored = SNAKE_COLOUR;
                    default:letter_req_colored = 16'h4040;//test* it should be BLACK(FFFF)
                endcase

                pix_data = letter_req_colored;
            end
        else if(((screen_x >= P_A_K_LEFT)&&(screen_x <= P_A_K_RGHT))&&
                ((screen_y >= P_A_K_TOP)&&(screen_y <= P_A_K_BTM)))begin
                letter_req = {5'd5,5'd17,5'd4,5'd18,5'd18,5'd26,5'd0,5'd13,5'd24,5'd26,5'd10,5'd4,5'd24};//"PRESS ANY KEY"
                stringIndex <= (screen_x-P_A_K_LEFT)/16;
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
        else
            pix_data = WHITE;
    end

end

letter_character letter_character_inst(
.letter_i(letter_req),
.letter_x(letter_x),
.letter_y(letter_y),
.letter_o(letter_o)
);

endmodule