`include "../libs/define.vh"

module joystick_input
(
	input one_resistor_x, two_resistors_x, one_resistor_y, two_resistors_y, clk,
	output reg [0:1] direction

);

reg left, right, up, down;

initial

begin
    direction = `TOP_DIR;
end



always @(posedge clk)

begin

	left = two_resistors_x;
	right = ~one_resistor_x;
	up = two_resistors_y;
	down = ~one_resistor_y;

	// u=up;
	// l=left;
	// d=down;
	// r=right;

	if(left + right + up + down == 3'b001) // if only one pressed 

	begin 
        /*
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
        */
        direction = `RIGHT_DIR;
	end 

end 


endmodule
