// top level module
`include "./libs/define.vh"

module main (
	// joystick input
	input wire
		res_x_one   ,
		res_x_two   ,
		res_y_one   ,
		res_y_two   ,

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
    parameter COLOR_DEBUG = 1'b0;
    parameter GAME_DEBUG  = 1'b0;
	// Clock
    wire reset_p;// This reset is enable at high
	wire vga_clk, update_clk, vga5x_clk;
	wire clk_locked;

    assign reset_p = !sys_reset_n;
    assign HDMI_ddc_scl = 1'b1;
    assign HDMI_ddc_sda = 1'b1;

    // VGA
	wire	[9:0]	mVGA_X;
	wire	[9:0]	mVGA_Y;
    wire	        vga_en;
	wire   [15:0]   sVGA_RGB;

	// Game input
	wire [0:1] dir;

	assign VGA_RGB = sVGA_RGB;
    wire [7:0] sVGA_R;
    wire [7:0] sVGA_G;
    wire [7:0] sVGA_B;
    assign sVGA_R = {sVGA_RGB[15:11], 3'b0};
    assign sVGA_G = {sVGA_RGB[10:5], 2'b0};
    assign sVGA_B = {sVGA_RGB[4:0], 3'b0};


	assign dir_out = dir; // for debug

	// Game logic
	wire [0:`SPRITE_LADDR] cur_ent_code;
	wire `TAIL_SIZE game_score;

	clk_gen vga_clk_gen (
        .areset(reset_p), 
        .inclk0(sys_clk),
        .c0    (vga_clk),
        .c1    (vga5x_clk),
        .locked(clk_locked)
	);

	game_upd_clk upd_clk(
		.in_clk(vga_clk),
		.sys_reset_n(sys_reset_n),
		.x_in(mVGA_X),
		.y_in(mVGA_Y),
		.out_clk(update_clk)
	);

	joystick_input ji (
		.one_resistor_x(res_x_one),
		.two_resistors_x(res_x_two),
		.one_resistor_y(res_y_one),
		.two_resistors_y(res_y_two),
		.clk(update_clk),
		.direction(dir)
	);

	game_logic game_logic_module (
        .debug_mode(GAME_DEBUG),
		.vga_clk(vga_clk),
		.update_clk(update_clk),
		.reset(reset_p),
		.direction(dir),
		.x_in(mVGA_X),
		.y_in(mVGA_Y),
		.entity(cur_ent_code),
		//.game_over(),
		//.game_won(),
		.tail_count(game_score)
	);

	vga_draw    vga_draw_inst(
			.iVGA_CLK(vga_clk),
            .ovga_x(mVGA_X),
            .ovga_y(mVGA_Y),
			//	Control Signals
			.sys_reset_n(sys_reset_n),
			.iColor_SW(COLOR_DEBUG),
			.ent(cur_ent_code),
            .vga_rgb(sVGA_RGB),
            .vga_hsync(VGA_HS),
            .vga_vsync(VGA_VS),
            .vga_valid(vga_en)
	);

    hdmi_ctrl hdmi_ctrl_inst(
        .clk_1x     (vga_clk), //input system clock
        .clk_5x     (vga5x_clk), //input 5x system clock
        .sys_rst_n  (sys_rst_n), //reset
        .rgb_blue   (sVGA_B),
        .rgb_green  (sVGA_G),
        .rgb_red    (sVGA_R),
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