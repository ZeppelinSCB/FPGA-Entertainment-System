// top level module
`include "./libs/define.vh"

module main (
	// joystick input
	input wire
		key_UUPP    ,
		key_DOWN    ,
		key_LEFT    ,
		key_RGHT    ,

	input wire 
        sys_clk     , // 50MHz

	// VGA input
	input wire
		sys_reset_n ,
		color       , // swap between 2 outputs

	// VGA output
	output wire
		VGA_HS      , // VGA H_SYNC
		VGA_VS      , // VGA V_SYNC
    
	output wire [15:0]
      VGA_RGB     , // VGA RGB

    output wire
        HDMI_CLK_P  ,
        HDMI_CLK_N  ,
        HDMI_ddc_scl,
        HDMI_ddc_sda,

    output wire [2:0] HDMI_tmds_data_p  ,
    output wire [2:0] HDMI_tmds_data_n  ,

	// Sseg output
	output wire [7:0] sseg_a_to_dp      ,
	output wire [3:0] sseg_an           ,

	output wire [0:1] dir_out           // for debug
);

parameter
    VISUAL_DEBUG = 1'b0,
    GAME_DEBUG   = 1'b0;

// Clock
wire reset_p;// This reset is enable at high
wire vga_clk, update_clk, vga5x_clk;
wire clk_locked;
wire reset_n;

// HDIMI
assign reset_n = (sys_reset_n & clk_locked);
assign reset_p = !reset_n;
assign HDMI_ddc_scl = 1'b1;
assign HDMI_ddc_sda = 1'b1;

// VGA
wire   [15:0]   draw_RGB    ; // RGB value rendered
wire	[9:0]	src_coord_X ; //coordinate respect to the screen
wire	[9:0]	src_coord_Y ; //coordinate respect to the screen
wire	        vga_en      ;

// Game input
wire [0:1] dir;

// HDMI
wire [7:0] sVGA_R;
wire [7:0] sVGA_G;
wire [7:0] sVGA_B;

assign dir_out = dir; // for debug

// Game logic
wire [0:1] cur_ent_code;
wire `TAIL_SIZE game_score;

clk_gen vga_clk_gen (
    .areset(~sys_reset_n), 
    .inclk0(sys_clk),
    .c0    (vga_clk),
    .c1    (vga5x_clk),
    .locked(clk_locked)
);

// Slow down clock for game
game_upd_clk upd_clk(
	.in_clk(vga_clk),
	.sys_reset_n(reset_n),
	.x_in(src_coord_X),
	.y_in(src_coord_Y),
	.out_clk(update_clk)
);

key_in key_input_inst (
	.key_right	(key_RGHT),
	.key_left	(key_LEFT),
	.key_down	(key_DOWN),
	.key_up		(key_UUPP),
    .iClk       (sys_clk ),
    .oDirection (dir     )
);

game_logic game_logic_module (
	.vga_clk(vga_clk),
	.update_clk(update_clk),
	.reset(reset_p),
	.direction(dir),
	.x_in(src_coord_X),
	.y_in(src_coord_Y),
	.entity(cur_ent_code),
	//.game_over(),
	//.game_won(),
	.tail_count(game_score)
);

// VGA controller that constantly scans the screen
vga_ctrl vga_ctrl_inst(
    .vga_clk     (vga_clk),
    .sys_rst_n   (reset_n),
    .pix_data    (draw_RGB),
    .pix_x       (src_coord_X),
    .pix_y       (src_coord_Y),
    .hsync       (VGA_HS),
    .vsync       (VGA_VS),
    .rgb         (VGA_RGB),
    .rgb_valid   (vga_en)
);

// VGA renderer
vga_draw    vga_draw_inst(
    .iVGA_CLK    (vga_clk),
    .ivga_x      (src_coord_X),
    .ivga_y      (src_coord_Y),
    .iReset_n    (reset_n),
    .iColor_SW   (VISUAL_DEBUG),
    .iSprite     (cur_ent_code),
    .oRGB        (draw_RGB)
);

    
assign sVGA_R = {VGA_RGB[15:11], 3'b0};
assign sVGA_G = {VGA_RGB[10:5], 2'b0 };
assign sVGA_B = {VGA_RGB[4:0], 3'b0  };

hdmi_ctrl hdmi_ctrl_inst(
    .clk_1x     (vga_clk), //input system clock
    .clk_5x     (vga5x_clk), //input 5x system clock
    .sys_rst_n  (reset_n), //reset
    .rgb_blue   ({VGA_RGB[4:0], 3'b0  }),
    .rgb_green  ({VGA_RGB[10:5], 2'b0 }),
    .rgb_red    ({VGA_RGB[15:11], 3'b0}),
    .hsync      (VGA_HS), //horizontal sync
    .vsync      (VGA_VS), //vertical sync
    .de         (vga_en), //enable signal
    .hdmi_clk_p (HDMI_CLK_P),
    .hdmi_clk_n (HDMI_CLK_N),
    .hdmi_r_p   (HDMI_tmds_data_p[2]),
    .hdmi_r_n   (HDMI_tmds_data_n[2]),
    .hdmi_g_p   (HDMI_tmds_data_p[1]),
    .hdmi_g_n   (HDMI_tmds_data_n[1]),
    .hdmi_b_p   (HDMI_tmds_data_p[0]),
    .hdmi_b_n   (HDMI_tmds_data_n[0])
);

/*
SSEG_Display sseg_d(
	.clk_50M(sys_clk),
	.reset(reset_p),
	.sseg_a_to_dp(sseg_a_to_dp),
	.sseg_an(sseg_an),
	.data(game_score)
);
*/

endmodule