`include "../libs/define.vh"

module key_in
(
    key_up          , 
    key_down        , 
    key_left        , 
    key_right       , 
    clk             ,
    direction

);

input key_up        ;
input key_down      ;
input key_left      ;
input key_right     ;
input clk           ;

output reg [0:1] direction;

reg left, right, up, down;

initial

begin
    direction = `TOP_DIR;
end

always @(posedge clk)
begin

    left = key_left;
    right = key_right;
    up = key_up;
    down = key_down;

	if(left + right + up + down == 3'b001) // if only one pressed 

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

end

endmodule