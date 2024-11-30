module pixel_renderer(
    //System Clock
    input                vga_clk,  
    input                sys_rst_n,
    //Screen Scan Position
    input      [ 9:0]     pixel_xpos,
    input      [ 9:0]     pixel_ypos,
    input wire            food_x,
    input wire            food_y,
    input wire [14:0]     block_x[20:0],
    input wire [14:0]     block_y[20:0],
    input wire [12:0]     snake_cur_len,

    //Pixel Data Output	 
    output     reg [15:0] pixel_data	
);

// 640480@60Hz 
//640 10个位宽 480 9个位宽
parameter  H_DISP      = 10'd640;                //分辨率——行
parameter  V_DISP      = 10'd480;                //分辨率——列

// localparam SIDE_W      = 10'd20;                  //边框宽度
localparam SIDE_W      = 10'd10;                  //边框宽 10个像素
localparam BLOCK_W     = 10'd20;                  //方块宽度

//颜色定义
// localparam BLUE        = 16'b00000_000000_11111;  //边框颜色 蓝色
localparam BLUE        	= 16'h7FFA;  //边框颜色 蓝色
localparam WHITE       	= 16'hFFFF;  //背景颜色 白色
localparam ORANGE       = 16'hFD20;  //背景颜色 橙色
localparam BLACK       	= 16'h0000;  //方块颜色 黑色
localparam RED       	= 16'hF800;  //蛇头颜色 红色
localparam BROWN       	= 16'h8A22;  //蛇头颜色 红色

//打印蛇，给不同的区域绘制不同的颜色
// 负责根据当前的像素坐标pixel_xpos和pixel_ypos，在VGA显示器上绘制蛇和食物。
// 代码使用了状态机来确定在屏幕的哪个部分绘制什么颜色
always @(posedge vga_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n) 
        pixel_data <= BLACK;//如果复位信号sys_rst_n为低，则将像素数据设置为黑色，通常用于清屏
    else begin

		// 检查像素坐标是否在屏幕边框内，如果是，则绘棕色边框
        if((pixel_xpos < SIDE_W) || (pixel_xpos >= H_DISP - SIDE_W)
          || (pixel_ypos < SIDE_W) || (pixel_ypos >= V_DISP - SIDE_W))
            pixel_data <= BROWN;  //绘制边框为棕色
			
		// 检查像素坐标是否在食物方块内，如果是，则绘制白色食物方块
		else if((pixel_xpos >= food_x) && (pixel_xpos < food_x + BLOCK_W)
			     && (pixel_ypos >= food_y) && (pixel_ypos < food_y + BLOCK_W))
		         pixel_data <= WHITE;   //绘制食物方块为白色

		// 根据蛇的长度snake_cur_len，绘制相应长度的蛇 
        else if(snake_cur_len == 1)//绘制一节的蛇
		begin          
			// 如果是一节蛇，检查当前像素是否在蛇头的方块内，如果是，则绘制红色色蛇头			
		     if((pixel_xpos >= block_x[0]) && (pixel_xpos < block_x[0] + BLOCK_W)
			     && (pixel_ypos >= block_y[0]) && (pixel_ypos < block_y[0] + BLOCK_W))
			     pixel_data <= RED;//绘制方块为红色
		     else // 如果不在蛇头内，则绘制黑色背景
                 pixel_data <= BLACK;                //绘制背景为黑色
        end
		else if(snake_cur_len == 2)//绘制两节的蛇
		begin                   
			//如果是两节蛇，检查当前像素是否在蛇头或蛇身的方块内 
		      if((pixel_xpos >= block_x[0]) && (pixel_xpos < block_x[0] + BLOCK_W)
			       && (pixel_ypos >= block_y[0]) && (pixel_ypos < block_y[0] + BLOCK_W))
					begin
						pixel_data <= RED;//蛇头为红色
					end    
		      else if((pixel_xpos >= block_x[1]) && (pixel_xpos < block_x[1] + BLOCK_W)
			       && (pixel_ypos >= block_y[1]) && (pixel_ypos < block_y[1] + BLOCK_W))
				   begin
						pixel_data <= ORANGE;//绘制方块为橙色色
				   end  
		      else
			  		begin
						pixel_data <= BLACK;//绘制背景为黑色 
			  		end
				    
		end
		else if(snake_cur_len == 3) //绘制三节蛇
		begin                    
		    if((pixel_xpos >= block_x[0]) && (pixel_xpos < block_x[0] + BLOCK_W)
			    && (pixel_ypos >= block_y[0]) && (pixel_ypos < block_y[0] + BLOCK_W))
				begin
					pixel_data <= RED; //蛇头为红色
				end
			    
		    else if((pixel_xpos >= block_x[1]) && (pixel_xpos < block_x[1] + BLOCK_W)
			    && (pixel_ypos >= block_y[1]) && (pixel_ypos < block_y[1] + BLOCK_W))
				begin
					pixel_data <= ORANGE;//绘制方块为橙色
				end
			    
		    else if((pixel_xpos >= block_x[2]) && (pixel_xpos < block_x[2] + BLOCK_W)
			    && (pixel_ypos >= block_y[2]) && (pixel_ypos < block_y[2] + BLOCK_W))
				begin
					pixel_data <= BLUE;//绘制方块为黑色 
				end
			    
			else
				begin
					pixel_data <= BLACK; //绘制背景为黑色 
				end
		        
	    end
        else if(snake_cur_len == 4)//绘制最上的4节蛇
		begin
		    if((pixel_xpos >= block_x[0]) && (pixel_xpos < block_x[0] + BLOCK_W)
			    && (pixel_ypos >= block_y[0]) && (pixel_ypos < block_y[0] + BLOCK_W))
			    pixel_data <= RED; //绘制方块为黑色
		    else
		    if((pixel_xpos >= block_x[1]) && (pixel_xpos < block_x[1] + BLOCK_W)
			    && (pixel_ypos >= block_y[1]) && (pixel_ypos < block_y[1] + BLOCK_W))
			    pixel_data <= ORANGE;  //绘制方块为黑色
		    else
		    if((pixel_xpos >= block_x[2]) && (pixel_xpos < block_x[2] + BLOCK_W)
			    && (pixel_ypos >= block_y[2]) && (pixel_ypos < block_y[2] + BLOCK_W))
			    pixel_data <= BLUE; //绘制方块为黑色
		    else 
		    if((pixel_xpos >= block_x[3]) && (pixel_xpos < block_x[3] + BLOCK_W)
			    && (pixel_ypos >= block_y[3]) && (pixel_ypos < block_y[3] + BLOCK_W))
			    pixel_data <= ORANGE; //绘制方块为黑色
		    else
		        pixel_data <= BLACK;//绘制背景为白色 
	    end

	    else if(snake_cur_len == 5) 
		begin
		    if((pixel_xpos >= block_x[0]) && (pixel_xpos < block_x[0] + BLOCK_W)
			    && (pixel_ypos >= block_y[0]) && (pixel_ypos < block_y[0] + BLOCK_W))
			    pixel_data <= RED;                //绘制方块为黑色
		    else
		    if((pixel_xpos >= block_x[1]) && (pixel_xpos < block_x[1] + BLOCK_W)
			    && (pixel_ypos >= block_y[1]) && (pixel_ypos < block_y[1] + BLOCK_W))
			    pixel_data <= ORANGE;                //绘制方块为黑色
		    else
		    if((pixel_xpos >= block_x[2]) && (pixel_xpos < block_x[2] + BLOCK_W)
			    && (pixel_ypos >= block_y[2]) && (pixel_ypos < block_y[2] + BLOCK_W))
			    pixel_data <= BLUE;                //绘制方块为黑色
		    else 
		    if((pixel_xpos >= block_x[3]) && (pixel_xpos < block_x[3] + BLOCK_W)
			    && (pixel_ypos >= block_y[3]) && (pixel_ypos < block_y[3] + BLOCK_W))
			    pixel_data <= ORANGE;                //绘制方块为黑色
			else
			if((pixel_xpos >= block_x[4]) && (pixel_xpos < block_x[4] + BLOCK_W)
			    && (pixel_ypos >= block_y[4]) && (pixel_ypos < block_y[4] + BLOCK_W))
				pixel_data <= BLUE;                //绘制方块为黑色
		    else
		        pixel_data <= BLACK;                //绘制背景为白色 
	    end

	/*
		// 继续绘制更长的蛇身体
		else if(snake_cur_len == 6) begin
		    // 默认设置像素数据为背景色
		    pixel_data <= BLACK;

		    // 绘制蛇头（红色）
		    if((pixel_xpos >= block_x[0]) && (pixel_xpos < block_x[0] + BLOCK_W) &&
		       (pixel_ypos >= block_y[0]) && (pixel_ypos < block_y[0] + BLOCK_W)) begin
		        pixel_data <= RED;
		    end

		    // 绘制蛇身，颜色交替为白色和蓝色
		    for(i = 1; i < 6; i = i + 1) begin
		        if((pixel_xpos >= block_x[i]) && (pixel_xpos < block_x[i] + BLOCK_W) &&
		           (pixel_ypos >= block_y[i]) && (pixel_ypos < block_y[i] + BLOCK_W)) begin
		            // 交替颜色，蛇头不交替
		            pixel_data <= (i % 2 == 0) ? WHITE : BLUE;
		            // 找到匹配的蛇身部分后，不需要继续检查
		        end
		    end
		end
	*/	


		else begin
		    if((pixel_xpos >= block_x[0]) && (pixel_xpos < block_x[0] + BLOCK_W)
			    && (pixel_ypos >= block_y[0]) && (pixel_ypos < block_y[0] + BLOCK_W))
			    pixel_data <= BLACK;                //绘制方块为黑色
		    else
		    if((pixel_xpos >= block_x[1]) && (pixel_xpos < block_x[1] + BLOCK_W)
			    && (pixel_ypos >= block_y[1]) && (pixel_ypos < block_y[1] + BLOCK_W))
			    pixel_data <= BLACK;                //绘制方块为黑色
		    else
		    if((pixel_xpos >= block_x[2]) && (pixel_xpos < block_x[2] + BLOCK_W)
			    && (pixel_ypos >= block_y[2]) && (pixel_ypos < block_y[2] + BLOCK_W))
			    pixel_data <= BLACK;                //绘制方块为黑色
		    else 
		    if((pixel_xpos >= block_x[3]) && (pixel_xpos < block_x[3] + BLOCK_W)
			    && (pixel_ypos >= block_y[3]) && (pixel_ypos < block_y[3] + BLOCK_W))
			    pixel_data <= BLACK;                //绘制方块为黑色
			else
			if((pixel_xpos >= block_x[4]) && (pixel_xpos < block_x[4] + BLOCK_W)
			    && (pixel_ypos >= block_y[4]) && (pixel_ypos < block_y[4] + BLOCK_W))
				pixel_data <= BLACK;                //绘制方块为黑色
			else
			if((pixel_xpos >= block_x[5]) && (pixel_xpos < block_x[5] + BLOCK_W)
			    && (pixel_ypos >= block_y[5]) && (pixel_ypos < block_y[5] + BLOCK_W))
				pixel_data <= BLACK;                //绘制方块为黑色
		    else
		        pixel_data <= WHITE;                //绘制背景为白色 
		end
    end
end

endmodule 