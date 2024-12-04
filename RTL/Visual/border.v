`include "../libs/define.vh"

module border
(
    vga_clk     ,
    sys_rst_n   ,
    pix_x       ,
    pix_y       ,
    pix_data    ,
    time_1s     ,
    time_10s    ,
    time_100s   ,
    number_i    ,
    number_x    ,
    number_y    
);

input             vga_clk      ;
input             sys_rst_n    ;
input [ 3:0]      time_1s      ;  
input [ 3:0]      time_10s     ;
input [ 3:0]      time_100s    ;

output         pix_x        ;
output         pix_y        ;
output         pix_data     ;
output [3:0]   number_i     ;
output [3:0]   number_x     ;
output [3:0]   number_y     ;

reg score_colour;

parameter BORDER_COLOUR = 16'h5746;
parameter BORDER_BLACK = 16'hFFFF;
parameter BORDER_W_TOP = 15;
parameter BORDER_W_LEFT = 15;
parameter BORDER_W_BOTTOM = VGA_HEIGHT - 1 - 16;
parameter BORDER_W_RIGHT = VGA_WIDTH - 1 - 16;
parameter TIME_H = VGA_HEIGHT - 1 - 16;
parameter TIME_LEFT = ((VGA_WIDTH - 1)/2) - 24;
parameter TIME_RIGHT = ((VGA_WIDTH - 1)/2) + 24;

always@(*)//Colour of the score displayed
    if(number_0 == 1)begin
            score_colour = 16'hFFFF;
        end
        else begin
            score_colour = 16'h0000;
        end

always@(posedge vga_clk or negedge sys_rst_n)//Edge of game area
    if(sys_rst_n == 1'b0)begin
        if((pix_y>=TIME_H)&&((pix_x>=TIME_LEFT)&&(pix_x<=TIME_RIGHT)))begin
            pix_data = score_colour;
        end
        else if((pix_y<=BORDER_W_TOP)||(pix_y>=BORDER_W_BOTTOM)||(pix_x<=BORDER_W_LEFT)||(pix_x>=BORDER_W_RIGHT))
            pix_data = 16'h4040;//test
        else begin
            pix_data = BORDER_COLOUR;
        end
    end


    
endmodule