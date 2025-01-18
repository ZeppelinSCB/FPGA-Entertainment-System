`include "../RTL/libs/define.vh"
`timescale  1ns/1ns
module tb_game_logic();

reg        sys_clk      ;
reg        sys_rst      ;
reg [0:1]  dir          ;
wire        update_clk   ;
reg [9:0]  VGA_X        ;
reg [9:0]  VGA_Y        ;
wire [0:1]  cur_ent_code ;
wire was_updated;
reg [2:0] game_state;
wire [2:0] drawing_cycles_passed;
reg `X_SIZE snake_x;
wire `Y_SIZE snake_y;
reg Flag_GameOver;
wire Flag_GameWon;
initial
	begin
    VGA_X = 0;
    VGA_Y = 0;
    dir   = 2'b00;
    sys_clk   = 1;
	sys_rst  <= 1'b0;
    game_state <= `STATE_START;
	#200
	sys_rst  <= 1'b1;
    #40
    game_state <= `STATE_INGAME;
	end

always #10 sys_clk = ~sys_clk;
assign was_updated = upd_clk.was_updated;
assign drawing_cycles_passed = upd_clk.drawing_cycles_passed;
/*
always@(posedge sys_clk) begin
    if(dir >= 2'b11)
        dir <= 2'b00;
    else
        dir <= dir+1;
end
*/

always@(posedge sys_clk) begin
    if(snake_x >= `LAST_HOR_ADDR) begin
        snake_x <= `GRID_MID_WIDTH;
        Flag_GameOver <= 1;
    end
    else begin
        snake_x <= VGA_X+12'd1;
        Flag_GameOver <= 0;
    end
end

always@(posedge sys_clk) begin
    if(VGA_X >= 640-1)
        VGA_X <= 0;
    else
        VGA_X <= VGA_X+1;
end

always@(posedge sys_clk) begin
    if(VGA_Y >= 480-1)
        VGA_Y <= 0;
    else if(VGA_X >= 640-1)
        VGA_Y <= VGA_Y+1;
    else
        VGA_Y <= VGA_Y;
end


assign snake_y = game_logic_module.snake_head_y;

game_logic game_logic_module (
	.vga_clk    (sys_clk     ),
	.update_clk (sys_clk     ),
	.reset_p      (!sys_rst    ),
	.direction  (dir         ),
	.x_in       (VGA_X       ),
	.y_in       (VGA_Y       ),
	.entity     (cur_ent_code),
	.tail_count (game_score  ),
    .game_state (game_state  ),
    .game_over  ( ),
    .game_won   (Flag_GameWon  )

);

game_upd_clk upd_clk(
	.in_clk     (sys_clk    ),
	.sys_reset_n(sys_rst    ),
	.x_in       (VGA_X      ),
	.y_in       (VGA_Y      ),
	.out_clk    (update_clk )
);



endmodule