`include "./libs/define.vh"

module visual_main (
	// joystick input

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
        vga_en      , // VGA enable
    
	output wire [15:0]
        VGA_RGB      // VGA RGB
);

reg [1:0] cur_ent_code = 2'b11;
wire vga_clk, vga5x_clk, clk_locked;
wire	[9:0]	mVGA_X;
wire	[9:0]	mVGA_Y;

	clk_gen vga_clk_gen (
        .areset(!sys_reset_n), 
        .inclk0(sys_clk),
        .c0    (vga_clk),
        .c1    (vga5x_clk),
        .locked(clk_locked)
	);

	vga_draw    vga_draw_inst(
			.iVGA_CLK(vga_clk),
            .ovga_x(mVGA_X),
            .ovga_y(mVGA_Y),
			//	Control Signals
			.sys_reset_n(sys_reset_n),
			.iColor_SW(1'b0),
			.ent(cur_ent_code),
            .vga_rgb(VGA_RGB),
            .vga_hsync(VGA_HS),
            .vga_vsync(VGA_VS),
            .vga_valid(vga_en)
);

endmodule