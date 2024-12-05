`timescale  1ns/1ns
module  tb_vga_display();

wire [15:0] draw_RGB  ;
wire        dR        ;
wire        dG        ;
wire        dB        ;
wire [15:0] out_RGB   ;
wire        hsync     ;
wire        vsync     ;
wire        valid     ;
wire  [9:0]  VGA_X     ;
wire  [9:0]  VGA_Y     ;
reg         sys_clk   ;
reg         sys_rst     ;
reg         iColor_SW ;
reg [0:1]   ent       ;

initial
	begin
    sys_clk   = 1;
    iColor_SW <= 1;
    ent      <= 2'b1;
	sys_rst  <= 1'b0;
	#200
	sys_rst  <= 1'b1;
	end

always #10 sys_clk = ~sys_clk;
assign dR = vga_draw_inst.oRed;
assign dG = vga_draw_inst.oGreen;
assign dB = vga_draw_inst.oBlue;

vga_draw vga_draw_inst(
    .iVGA_CLK    (sys_clk),
    .ovga_x      (VGA_X),
    .ovga_y      (VGA_Y),

    .sys_reset_n (sys_rst),
    .iColor_SW   (iColor_SW),
    .ent         (ent),

    .vga_rgb     (out_RGB),
    .vga_hsync   (hsync),
    .vga_vsync   (vsync),
    .vga_valid   (valid)
);
endmodule
