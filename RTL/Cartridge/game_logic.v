`include "../libs/define.vh"

module game_logic (
	input vga_clk, update_clk, reset,
	input [0:1] direction,
	input wire [9:0] x_in, y_in, // new values are given at each clock cycle
	output reg [0:1] entity,
    output wire game_over,
	output reg game_won,
	output reg `TAIL_SIZE tail_count
);
reg hit_self, hit_wall;
wire `X_SIZE grid_coord_x;
wire `Y_SIZE grid_coord_y;
reg `X_SIZE snake_head_x, apple_x;
reg `Y_SIZE snake_head_y, apple_y;
reg is_cur_coord_tail;
// reg [`MEM_BITS_HOR_G*`TAIL_SIZE-1:0]   tail_x;
// reg [`MEM_BITS_VERT_G*`TAIL_SIZE-1:0]  tail_y;
reg `COORD_SIZE tails [0:`LAST_TAIL_ADDR];
wire [5:0] rand_num_x_orig, rand_num_y_orig,
	rand_num_x_fit, rand_num_y_fit;
wire flag_time_max;//indicates that the time is over

	random_num_gen_63 rng_x (
		.clk(update_clk),
		.seed(6'b100_110),
		.rnd(rand_num_x_orig)
	);

	random_num_gen_63 rng_y (
		.clk(update_clk),
		.seed(6'b101_001),
		.rnd(rand_num_y_orig)
	);

	assign rand_num_x_fit = 1+rand_num_x_orig % (`LAST_HOR_ADDR-2);
	assign rand_num_y_fit = 1+rand_num_y_orig % (`LAST_VER_ADDR-2);
    integer i, j;
    assign game_over = hit_self | hit_wall;
task init_apple();
	begin
		apple_x <= `GRID_MID_WIDTH ;
		apple_y <= `GRID_MID_HEIGHT;
	end
endtask

initial
	begin
        hit_self <= 0;
        hit_wall <= 0;
		init_apple();
		snake_head_x <= `GRID_MID_WIDTH ;
		snake_head_y <= `GRID_MID_HEIGHT;
		tail_count   <= 0;
		game_won     <= 0;
	end

	assign grid_coord_x = (x_in / `H_SQUARE);
	assign grid_coord_y = (y_in / `V_SQUARE);

	// return entity code of the current x & y
always @(posedge vga_clk) begin
	if (
		grid_coord_x == snake_head_x &&
		grid_coord_y == snake_head_y
	) begin
		entity <= `ENT_SNAKE_HEAD;
	    end
	else if (
		grid_coord_x == apple_x &&
		grid_coord_y == apple_y
	) begin
		entity <= `ENT_APPLE;
	    end
	else if (is_cur_coord_tail) begin
		entity <= `ENT_SNAKE_TAIL;
	    end
	else begin
		entity <= `ENT_NOTHING;
	    end
    end

// traverse the array of tails and see if
// the current coordinate is a tail
always @(posedge vga_clk or posedge reset) begin
	if (reset) begin
		hit_self = 0;
		end
	else begin
        is_cur_coord_tail = 0;
		for (i = 0; i < `MAX_TAILS; i = i + 1) begin
			if (i < tail_count) begin // if tail exists
				if (tails[i] == {grid_coord_x, grid_coord_y}) begin // if a tail
					is_cur_coord_tail = 1'b1;
					if (tails[i] == {snake_head_x, snake_head_y}) begin//Snake collides with itself
						hit_self = 1'b1;
					    end
				    end
			    end
		    end
	    end
    end

// move snake head
always @(posedge update_clk or posedge reset) begin
	if (reset) begin
		snake_head_x <= `GRID_MID_WIDTH;
		snake_head_y <= `GRID_MID_HEIGHT;
		end
	else begin
		if (~(game_over|game_won)) begin
			case (direction)
				`LEFT_DIR: begin
					snake_head_x <=
						(snake_head_x == 0) ?
							`LAST_HOR_ADDR:
							(snake_head_x - 12'd1);
					end
				`TOP_DIR: begin
					snake_head_y <=
						(snake_head_y == 0) ?
							`LAST_VER_ADDR:
							(snake_head_y - 12'd1);
					end
				`RIGHT_DIR: begin
					snake_head_x <=
						(snake_head_x == `LAST_HOR_ADDR) ?
							0:
							(snake_head_x + 12'd1);
					end
				`DOWN_DIR: begin
					snake_head_y <=
						(snake_head_y == `LAST_VER_ADDR) ?
							0:
							(snake_head_y + 12'd1);
				    end
                default: begin
                    snake_head_x <= snake_head_x;
                    snake_head_y <= snake_head_y;
                    end
			endcase
			end
        else begin // if game over or won
            snake_head_x <= snake_head_x;
            snake_head_y <= snake_head_y;
            end
		end
	end

// Move tails
always @(posedge update_clk or posedge reset) begin
	if (reset) 
        tails[0] <= tails[0];// do nothing
	else begin
        if(~(game_over|game_won))
            // TODO: Check if this is correct
		    for (j = 0; j < `MAX_TAILS; j = j + 1) begin
		    	if (j == (0)) // if the first tail
		    		tails[j] <= {snake_head_x, snake_head_y};
		    	else if (j != `LAST_TAIL_ADDR) //if not the first tail
		    		tails[j] <= tails[j - 1]; //assign coord of prvious tails to current
		        end
        else
            tails[0] <= tails[0];
        end
	end

// check if the snake head is on the apple
always @(posedge update_clk or posedge reset) begin
    if (reset) begin
        init_apple();
        tail_count <= 0;
        end
    else begin
        if (snake_head_x == apple_x && snake_head_y == apple_y) begin
            if (tail_count < `MAX_TAILS)
                tail_count <= tail_count + 1;
            else
                tail_count <= tail_count;
            apple_x <= rand_num_x_fit;
            apple_y <= rand_num_y_fit;
            end
        end
    end

	always @(posedge update_clk or posedge reset)
	begin
		if (reset)
		begin
			game_won <= 0;
		end
		else if (tail_count == `MAX_TAILS)
		begin
			game_won <= 1;
		end
		else if (flag_time_max == 1'b1)
		begin
			game_won <= 1;
		end
		else
			game_won <= 0;
	end

endmodule
