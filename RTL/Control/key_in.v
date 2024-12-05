`include "../libs/define.vh"

module key_in
(
    key_up          , 
    key_down        , 
    key_left        , 
    key_right       ,
    key_flag        , 
    clk             ,
    sys_clk         ,
    sys_rst_n       ,
    direction

);

input wire key_up        ;//key1
input wire key_down      ;//key2
input wire key_left      ;//key0
input wire key_right     ;//key3
input wire key_flag		;
input wire clk           ;
input wire sys_clk       ;
input wire sys_rst_n     ;

output reg [0:1] direction;


reg left, right, up, down;
reg key_press;
reg [19:0] cnt_20ms ;

parameter CNT_MAX = 20'd999_999;//The maximum counter number

initial

begin
    direction = `TOP_DIR;
end

always @(posedge sys_clk or negedge sys_rst_n) begin

    key_press = (key_up||key_down||key_left||key_right);

 	if(sys_rst_n == 1'b0)
		cnt_20ms <= 20'b0;
	else if(key_press == 1'b1)
		cnt_20ms <= 20'b0;
	else if(cnt_20ms == CNT_MAX && key_press == 1'b0)
		cnt_20ms <= cnt_20ms;
	else
		cnt_20ms <= cnt_20ms + 1'b1;
end

always@(posedge sys_clk or negedge sys_rst_n) begin
	if(sys_rst_n == 1'b0)
		key_flag <= 1'b0;
	else if(cnt_20ms == CNT_MAX - 1'b1)
		key_flag <= 1'b1;
	else
		key_flag <= 1'b0;
end

always @(posedge clk)
begin

    left = key_left;
    right = key_right;
    up = key_up;
    down = key_down;

	if((left + right + up + down == 3'b001)&&(key_flag == 1'b1)) // if only one pressed 

	begin 

		if(left && (direction != `RIGHT_DIR)) 

		begin 
			direction = `LEFT_DIR; 
		end 



		if(right && (direction != `LEFT_DIR)) 

		begin 
			direction = `RIGHT_DIR; 
		end 



		if(up && (direction != `DOWN_DIR)) 

		begin 
			direction = `TOP_DIR;
		end 			 



		if(down && (direction != `TOP_DIR)) 

		begin 
			direction = `DOWN_DIR; 
		end 
	end

    else
        direction = direction; 

end

endmodule