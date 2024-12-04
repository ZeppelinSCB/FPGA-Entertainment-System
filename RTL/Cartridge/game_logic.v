`include "../libs/define.vh"

module game_logic (
	input vga_clk, update_clk, reset,
	input [0:1] direction,
	input wire [9:0] x_in, y_in, // new values are given at each clock cycle
	output reg [0:1] entity,
	output reg game_over, game_won,
	output reg `TAIL_SIZE tail_count
);
	wire `X_SIZE cur_x;
	wire `Y_SIZE cur_y;
	reg `X_SIZE snake_head_x, apple_x;
	reg `Y_SIZE snake_head_y, apple_y;
	reg is_cur_coord_tail;
	reg `COORD_SIZE tails [0:`LAST_TAIL_ADDR];
	wire [5:0] rand_num_x_orig, rand_num_y_orig,
		rand_num_x_fit, rand_num_y_fit;

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

	assign rand_num_x_fit = rand_num_x_orig % `LAST_HOR_ADDR;
	assign rand_num_y_fit = rand_num_y_orig % `LAST_VER_ADDR;
    integer i, j;

	task init();
	begin
		apple_x <= 34;
		apple_y <= 9;
	end
	endtask

	initial
	begin
		init();
		snake_head_x <= `GRID_MID_WIDTH;
		snake_head_y <= `GRID_MID_HEIGHT;
		tail_count <= 0;
		game_won <= 0;
	end

	assign cur_x = (x_in / `H_SQUARE);
	assign cur_y = (y_in / `V_SQUARE);

	// return entity code of the current x & y
	always @(posedge vga_clk)
	begin
		if (
			cur_x == snake_head_x &&
			cur_y == snake_head_y
		)
		begin
			entity <= `ENT_SNAKE_HEAD;
		end
		else if (
			cur_x == apple_x &&
			cur_y == apple_y
		)
		begin
			entity <= `ENT_APPLE;
		end
		else if (is_cur_coord_tail)
		begin
			entity <= `ENT_SNAKE_TAIL;
		end
		else
		begin
			entity <= `ENT_NOTHING;
		end
	end

	// traverse the array of tails and see if
	// the current coordinate is a tail
	always @(posedge vga_clk or posedge reset)
	begin
		if (reset)
		begin
			game_over = 0;
		end
		else
		begin
			is_cur_coord_tail = 1'b0;

			for (i = 0; i < `MAX_TAILS; i = i + 1)
			begin
				if (i < tail_count)
				begin
					if (tails[i] == {cur_x, cur_y})
					begin
						is_cur_coord_tail = 1'b1;
					end

					if (tails[i] == {snake_head_x, snake_head_y})//Snake collides with itself
					begin
						game_over = 1'b1;
					end
					else if ((snake_head_y <= 32)||(snake_head_y >= 447))//Snake collides with the wall
        			begin
						game_over = 1'b1;
					end
					else if ((snake_head_x <= 32)||(snake_head_x >= 607))//Snake collides with the wall
					begin
						game_over = 1'b1;
					end
					else
						game_over <= 1'b0;
				end
			end
		end
	end

	// move snake head
	always @(posedge update_clk or posedge reset)
	begin
		if (reset)
		begin
			snake_head_x <= `GRID_MID_WIDTH;
			snake_head_y <= `GRID_MID_HEIGHT;
		end
		else
		begin
			if (~game_over)
			begin
				case (direction)
					`LEFT_DIR:
					begin
						snake_head_x <=
							(snake_head_x == 0) ?
								`LAST_HOR_ADDR:
								(snake_head_x - 12'd1);
					end
					`TOP_DIR:
					begin
						snake_head_y <=
							(snake_head_y == 0) ?
								`LAST_VER_ADDR:
								(snake_head_y - 12'd1);
					end
					`RIGHT_DIR:
					begin
						snake_head_x <=
							(snake_head_x == `LAST_HOR_ADDR) ?
								0:
								(snake_head_x + 12'd1);
					end
					`DOWN_DIR:
					begin
						snake_head_y <=
							(snake_head_y == `LAST_VER_ADDR) ?
								0:
								(snake_head_y + 12'd1);
					end
				endcase
			end
		end
	end

	// update tails
	always @(posedge update_clk or posedge reset)
	begin

		if (reset)
		begin
			init();
			tail_count <= 0;
		end
		else
		begin
			// if (~game_over) // cool animation
			// begin
			// in case of apple hit
			if (snake_head_x == apple_x &&
					snake_head_y == apple_y)
			begin
				// add tail to the previous position of the head
				if (tail_count < `MAX_TAILS) // that is, game is not won
				begin
					tails[tail_count] <= {snake_head_x, snake_head_y};
					tail_count <= tail_count + 1;
				end

				apple_x <= rand_num_x_fit;
				apple_y <= rand_num_y_fit;
			end
			else
			begin
				// swap coordinates of adjacent tails
				for (j = 0; j < `MAX_TAILS; j = j + 1)
				begin
					if (j == (tail_count - 1))
					begin
						tails[j] <= {snake_head_x, snake_head_y};
					end
					else
					begin
						if (j != `LAST_TAIL_ADDR) // won't compile without this,
							// however, in reality this condition will always be true
						begin
							tails[j] <= tails[j + 1];
						end
					end
				end
			end
			//end
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
		else if (time_max_flag == 1'b1)
		begin
			game_won <= 1;
		end
		else
			game_won <= 0;
	end

endmodule
