`timescale  1ns/1ns
module tb_main();
reg          res_x_one          ;
reg          res_x_two          ;
reg          res_y_one          ;
reg          res_y_two          ;
reg          sys_clk            ; // 50MHz
reg          sys_rst            ;
reg          iColor_SW          ; //when set to 1, display color bar
reg          debug_mode         ; //when set to 1, display all the sprites

wire         clk_5x             ;
wire         VGA_HS             ;// VGA H_SYNC
wire         VGA_VS             ;// VGA V_SYNC
wire [15:0]  VGA_RGB            ;// VGA RGB
wire         HDMI_CLK_P         ;
wire         HDMI_CLK_N         ;
wire         HDMI_ddc_scl       ;
wire         HDMI_ddc_sda       ;
wire [2:0]   HDMI_tmds_data_p   ;
wire [2:0]   HDMI_tmds_data_n   ;
wire [7:0]   sseg_a_to_dp       ;
wire [3:0]   sseg_an            ;
wire [0:1]   dir_out            ;

wire [15:0]  dR                 ;
wire [15:0]  dG                 ;
wire [15:0]  dB                 ;
wire	[9:0]	mVGA_X;
wire	[9:0]	mVGA_Y;

wire [3:0]      entity;

initial
	begin
    sys_clk   = 1;
    iColor_SW <= 1;
	sys_rst  <= 1'b0;
	#200
	sys_rst  <= 1'b1;
	end

always #10 sys_clk = ~sys_clk;
assign dR = main_inst.vga_draw_inst.oRed    ;
assign dG = main_inst.vga_draw_inst.oGreen  ;
assign dB = main_inst.vga_draw_inst.oBlue   ;
assign mVGA_X = main_inst.mVGA_X;
assign mVGA_Y = main_inst.mVGA_Y;
assign clk_5x = main_inst.vga5x_clk;
assign entity = main_inst.cur_ent_code;

main main_inst(
    .res_x_one        (res_x_one       ),
    .res_x_two        (res_x_two       ),
    .res_y_one        (res_y_one       ),
    .res_y_two        (res_y_two       ),
    .sys_clk          (sys_clk         ),
    .sys_reset_n      (sys_rst         ),
    .color            (iColor_SW       ),
    .VGA_HS           (VGA_HS          ),
    .VGA_VS           (VGA_VS          ),
    .VGA_RGB          (VGA_RGB         ),
    .HDMI_CLK_P       (HDMI_CLK_P      ),
    .HDMI_CLK_N       (HDMI_CLK_N      ),
    .HDMI_ddc_scl     (HDMI_ddc_scl    ),
    .HDMI_ddc_sda     (HDMI_ddc_sda    ),
    .HDMI_tmds_data_p (HDMI_tmds_data_p),
    .HDMI_tmds_data_n (HDMI_tmds_data_n),
    .sseg_a_to_dp     (sseg_a_to_dp    ),
    .sseg_an          (sseg_an         ),
    .dir_out          (dir_out         )
);
endmodule