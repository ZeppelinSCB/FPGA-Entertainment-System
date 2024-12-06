//Shown "SNAKE (GAME)" (and "PRESS ANY KEY") in the Start Page
`include "../libs/define.vh"

module start_page
(
    vga_clk,
    sys_rst_n,
    letter_req_1,
    letter_req_2;
    letter_req_colored_1;
    letter_req_colored_2;
    pix_x,
    pix_y,
    pix_data,
    clk
);

input wire             vga_clk      ;
input wire             sys_rst_n    ;

output reg             pix_data     ;
output reg             pix_x        ;
output reg             pix_y        ;

reg                    letter_req_1 ;
reg                    letter_req_2 ;
reg             letter_req_colored_1;
reg             letter_req_colored_2;

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

    letter_req_1 = ({22,13,0,10,4}%4);//"SNAKE GAME"
    letter_req_2 = {15,17,4,18,18,26,0,13,24,26,10,4,24};//"PRESS ANY KEY"

    case(letter_req_1)
        1'b0:   letter_req_colored_1 = 16'h4040;//test* it should be BLACK(FFFF)
        1'b1:   letter_req_colored_1 = SNAKE_COLOUR;
        default:letter_req_colored_1 = 16'h4040;//test* it should be BLACK(FFFF)
    endcase

    case(letter_req_2)
        1'b0:   letter_req_colored_2 = 16'h4040;//test* it should be BLACK(FFFF)
        1'b1:   letter_req_colored_2 = WHITE;
        default:letter_req_colored_2 = 16'h4040;//test* it should be BLACK(FFFF)
    endcase

    if(sys_rst_n == 1'b0)begin
        if(((pix_x >= SNAKE_LEFT)&&(pix_x <= SNAKE_RGHT))&&((pix_y >= SNAKE_TOP)&&(pix_y <= SNAKE_BTM)))begin
                pix_data = letter_req_colored_1;
            end
        else if(((pix_x >= P_A_K_LEFT)&&(pix_x <= P_A_K_RGHT))&&((pix_y >= P_A_K_TOP)&&(pix_y <= P_A_K_BTM)))begin
                pix_data = letter_req_colored_2;
            end
    end


end
endmodule