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
input wire [9:0]       screen_x     ;
input wire [9:0]       screen_y     ;

output reg [15:0]      pix_data     ;

reg [4:0]              letter_i     ;
reg [3:0]              letter_x     ;
reg [3:0]              letter_y     ;

reg [9:0]               relative_x; //relative position of text block
reg [9:0]               relative_y; //relative position of text block

reg [32:0]              letter_req  ;
reg [15:0]              letter_req_colored;
wire                    letter_o;
reg [5:0]               stringIndex  ;
reg [5:0]               arrayindex   ;

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

// reg [32:0] str_SNAKE;
// always @(*)begin
//     str_SNAKE = {5'd22,5'd13,5'd0,5'd10,5'd4};//"SNAKE GAME"
// end

always@(posedge vga_clk or negedge sys_rst_n)begin
    if(sys_rst_n == 1'b0)
        pix_data <= WHITE;
    else begin
        if(((screen_x >= SNAKE_LEFT)&&(screen_x <= SNAKE_RGHT))&&
            ((screen_y >= SNAKE_TOP)&&(screen_y <= SNAKE_BTM)))begin
                /*
                stringIndex <= (screen_x-SNAKE_LEFT)/16;
                letter_i <= 5'b1;//str_SNAKE[stringIndex];
                letter_x <= (screen_x-SNAKE_LEFT)/4;
                letter_y <= (screen_y-SNAKE_TOP)/4;

                case(letter_o)
                    1'b0:   letter_req_colored = 16'h4040;//test* it should be BLACK(FFFF)
                    1'b1:   letter_req_colored = SNAKE_COLOUR;
                    default:letter_req_colored = 16'h4040;//test* it should be BLACK(FFFF)
                endcase
                */
                pix_data = SNAKE_COLOUR; //letter_req_colored;
            end
        else if(((screen_x >= P_A_K_LEFT)&&(screen_x <= P_A_K_RGHT))&&
                ((screen_y >= P_A_K_TOP)&&(screen_y <= P_A_K_BTM)))begin
                relative_x <= screen_x-P_A_K_LEFT;
                relative_y <= screen_y-P_A_K_TOP;
                //letter_req <= {5'd5,5'd17,5'd4,5'd18,5'd18,5'd26,5'd0,5'd13,5'd24,5'd26,5'd10,5'd4,5'd24};//"PRESS ANY KEY"
                if(relative_x <= 9'd16*1) begin
                    letter_i <= 5'd5;
                    letter_x <= relative_x - 9'd16*0;
                    letter_y <= relative_y;
                    end
                else if(relative_x <= 9'd16*2) begin
                    letter_i <= 5'd17;
                    letter_x <= relative_x - 9'd16*1;
                    letter_y <= relative_y;
                    end
                else if(relative_x <= 9'd16*3) begin
                    letter_i <= 5'd4;
                    letter_x <= relative_x - 9'd16*2;
                    letter_y <= relative_y;
                    end
                else if(relative_x <= 9'd16*4) begin
                    letter_i <= 5'd18;
                    letter_x <= relative_x - 9'd16*3;
                    letter_y <= relative_y;
                    end
                else if(relative_x <= 9'd16*5) begin
                    letter_i <= 5'd18;
                    letter_x <= relative_x - 9'd16*4;
                    letter_y <= relative_y;
                    end
                else if(relative_x <= 9'd16*6) begin
                    letter_i <= 5'd26;
                    letter_x <= relative_x - 9'd16*5;
                    letter_y <= relative_y;
                    end
                else if(relative_x <= 9'd16*7) begin
                    letter_i <= 5'd0;
                    letter_x <= relative_x - 9'd16*6;
                    letter_y <= relative_y;
                    end
                else if(relative_x <= 9'd16*8)begin
                    letter_i <= 5'd13;
                    letter_x <= relative_x - 9'd16*7;
                    letter_y <= relative_y;
                    end
                else if(relative_x <= 9'd16*9) begin
                    letter_i <= 5'd24;
                    letter_x <= relative_x - 9'd16*8;
                    letter_y <= relative_y;
                    end
                else if(relative_x <= 9'd16*10) begin
                    letter_i <= 5'd26;
                    letter_x <= relative_x - 9'd16*9;
                    letter_y <= relative_y;
                    end
                else if(relative_x <= 9'd16*11) begin
                    letter_i <= 5'd10;
                    letter_x <= relative_x - 9'd16*10;
                    letter_y <= relative_y;
                    end
                else if(relative_x <= 9'd16*12) begin
                    letter_i <= 5'd4;
                    letter_x <= relative_x - 9'd16*11;
                    letter_y <= relative_y;
                    end
                else    begin
                    letter_i <= 5'd24;
                    letter_x <= relative_x - 9'd16*12;
                    letter_y <= relative_y;
                    end

                case(letter_o)
                    1'b0:   letter_req_colored <= 16'h4040;//test* it should be BLACK(FFFF)
                    1'b1:   letter_req_colored <= BLACK;
                    default:letter_req_colored <= 16'h4040;//test* it should be BLACK(FFFF)
                endcase
                
                pix_data <= letter_req_colored;
            end
        else
            pix_data <= WHITE;
            stringIndex <= 0;
    end

end


letter_character letter_character_inst(
.letter_i(letter_i),
.letter_x(letter_x),
.letter_y(letter_y),
.letter_o(letter_o)
);


endmodule