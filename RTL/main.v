// top level module
`include "./libs/define.vh"

module main (
	// joystick input
	input wire
		res_x_one,
		res_x_two,
		res_y_one,
		res_y_two,

	input wire sys_clk, // 50MHz

	// VGA input
	input wire
		reset,
		color, // swap between 2 outputs

	// VGA output
	output wire
		VGA_HS, // VGA H_SYNC
		VGA_VS, // VGA V_SYNC
		VGA_RGB, // VGA RGB

    output wire
        HDMI_CLK_P ,
        HDMI_CLK_N ,

    output wire [2:0] tmds_data_p,
    output wire [2:0] tmds_data_n,


	// Sseg output
	output wire
		[7:0] sseg_a_to_dp,
	output wire
		[3:0] sseg_an
	// joystick output
	//, output wire [0:1] dir_out // for debug
);
	// Clock
	wire vga_clk, update_clk, vga5x_clk;
	wire clk_locked;

	clk_gen vga_clk_gen (
        .areset(reset) , 
        .inclk0(sys_clk),
        .c0    (vga_clk),
        .c1    (vga5x_clk),
        .locked(clk_locked),
	);

	game_upd_clk upd_clk(
		.in_clk(vga_clk),
		.reset(reset),
		.x_in(mVGA_X),
		.y_in(mVGA_Y),
		.out_clk(update_clk)
	);

	// Game input
	wire [0:1] dir;

	joystick_input ji (
		.one_resistor_x(res_x_one),
		.two_resistors_x(res_x_two),
		.one_resistor_y(res_y_one),
		.two_resistors_y(res_y_two),
		.clk(update_clk),
		.direction(dir)
	);

	assign dir_out = dir; // for debug

	// Game logic
	wire [0:1] cur_ent_code;
	wire `TAIL_SIZE game_score;

	game_logic game_logic_module (
		.vga_clk(vga_clk),
		.update_clk(update_clk),
		.reset(reset),
		.direction(dir),
		.x_in(mVGA_X),
		.y_in(mVGA_Y),
		.entity(cur_ent_code),
		//.game_over(),
		//.game_won(),
		.tail_count(game_score)
	);

	// VGA
	wire	[9:0]	mVGA_X;
	wire	[9:0]	mVGA_Y;
    wire	        vga_en;
	wire   [15:0]   mVGA_RGB;
	wire   [15:0]   sVGA_RGB;

	VGA_Draw	u3 // Drawing
		(	//	Read Out Side
			.oRGB  (mVGA_RGB),
			.iVGA_X(mVGA_X),
			.iVGA_Y(mVGA_Y),
			.iVGA_CLK(vga_clk),
			//	Control Signals
			.reset(reset),
			.iColor_SW(0),
			.ent(cur_ent_code)
		);

	VGA_Ctrl	u2 // Setting up VGA Signal
		(	//	Host Side
			.oCurrent_X(mVGA_X),
			.oCurrent_Y(mVGA_Y),
            .oVga_valid(vga_en),
			.iRGB(mVGA_RGB),
			//	VGA Side
			.oVGA_RGB(sVGA_RGB),
			.oVGA_HS(VGA_HS),
			.oVGA_VS(VGA_VS),
			//	Control Signal
			.iCLK(vga_clk),
			.reset(reset)
		);

	assign VGA_RGB = sVGA_RGB;
    wire [7:0] sVGA_R;
    wire [7:0] sVGA_G;
    wire [7:0] sVGA_B;
    assign sVGA_R = {sVGA_RGB[15:11], 3'b0};
    assign sVGA_G = {sVGA_RGB[10:5], 2'b0};
    assign sVGA_B = {sVGA_RGB[4:0], 3'b0};

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
        .hdmi_r_p   (tmds_data_p[2]),
        .hdmi_r_n   (tmds_data_n[2]),
        .hdmi_g_p   (tmds_data_p[1]),
        .hdmi_g_n   (tmds_data_n[1]),
        .hdmi_b_p   (tmds_data_p[0]),
        .hdmi_b_n   (tmds_data_n[0])
    );

	SSEG_Display sseg_d(
		.clk_50M(sys_clk),
		.reset(reset),
		.sseg_a_to_dp(sseg_a_to_dp),
		.sseg_an(sseg_an),
		.data(game_score)
	);

endmodule