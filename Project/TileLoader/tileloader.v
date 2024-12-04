module tileloader(
    sys_reset_n;
)
vga_draw	u3 // Drawing
	(	//	Read Out Side
		.oRGB  (mVGA_RGB),
		.iVGA_X(mVGA_X),
		.iVGA_Y(mVGA_Y),
		.iVGA_CLK(vga_clk),
		//	Control Signals
		.sys_reset_n(sys_reset_n),
		.iColor_SW(1'b1),
		.ent(cur_ent_code)
	);

vga_ctrl	u2 // Setting up VGA Signal
	(	//	Host Side
        .vga_clk(vga_clk),
        .sys_rst_n(sys_reset_n),
        .pix_data(mVGA_RGB),
		.pix_x(mVGA_X),
		.pix_y(mVGA_Y),
        .hsync(VGA_HS),
        .vsync(VGA_VS),
        .rgb(sVGA_RGB),
        .rgb_valid(vga_en)
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

endmodule