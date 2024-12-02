always@(posedge vga_clk or negedge sys_rst_n)//Edge of game area
    if(sys_rst_n == 1'b0)
        pix_data <= 16'd0;
    else if((pix_x>=0)&&(pix_x<=16))||((pix_x<=639)&&(pix_x>=623))//Left and right sides fill with 16-pixel width green colour bar 
        pix_data <= GREEN;
    else if((pix_x>=16)&&(pix_y>=0)&&(pix_y<=16)||(pix_x>=16)&&(pix_y>=463)&&(pix_y<=479))//Up and down sides fill with 16-pixel width green colour bar 
        pix_data <= GREEN;
    else
        pix_data <= BLACK;


always@(posedge vga_clk or negedge sys_rst_n)//Snake collide with wall
if ((snake_head_x <= 16)||(snake_head_x >= 623))
					begin
						game_over = 1'b1;
					end
else if ((snake_head_y <= 16)||(snake_head_y >= 479))
                    begin
						game_over = 1'b1;
					end
else
                    begin
                        game_over = 1'b0;
                    end


always@(posedge sys_clk or negedge sys_rst_n)//Time counter
begin 
	//One should use or to connect 
	if((sys_rst_n == 1'b0)||(game_over = 1'b1))
	begin
		counter <= 0;
        counter_1s <= 0
	end
	else if(counter == 0) 
	begin
		counter = 2499_9999; // 2499_9999;
        counter_1s = counter_1s + 1;
	end
	else
	begin
		counter <= counter - 1'b1;
	end
end

always@(posedge sys_clk or negedge sys_rst_n)//Time counter display
begin

end