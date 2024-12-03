module border
(
    vga_clk     ,
    sys_rst_n   ,
    pix_x       ,
    pix_y       ,
    pix_data    
);

input vga_clk  ;
input sys_rst_n;

output pix_x   ;
output pix_y   ;
output pix_data;


always@(posedge vga_clk or negedge sys_rst_n)//Edge of game area
    if(sys_rst_n == 1'b0)
        pix_data <= 16'd0;
    else if((pix_x>=0)&&(pix_x<=16))||((pix_x<=639)&&(pix_x>=623))//Left and right sides fill with 16-pixel width green colour bar 
        pix_data <= GREEN;
    else if((pix_x>=16)&&(pix_y>=0)&&(pix_y<=16)||(pix_x>=16)&&(pix_y>=463)&&(pix_y<=479))//Up and down sides fill with 16-pixel width green colour bar 
        pix_data <= GREEN;
    else
        pix_data <= 0;

endmodule