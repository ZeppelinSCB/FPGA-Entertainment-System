`timescale  1ns/1ns
module  tb_vga_draw();

wire [15:0] draw_RGB  ;
wire [15:0] sprite_RGB;
wire [15:0] back_RGB  ;
wire        R         ;
wire        G         ;
wire        B         ;
wire [15:0] out_RGB   ;
wire        valid     ;
reg  [9:0]  VGA_X     ;
reg  [9:0]  VGA_Y     ;
reg         sys_clk   ;
reg         sys_rst     ;
reg         iColor_SW ;
reg [0:1]   ent       ;

initial
	begin
    VGA_X = 0;
    VGA_Y = 0;
    sys_clk   = 1;
    iColor_SW = 1;
    ent      = 1;
	sys_rst  = 1'b0;
	#200
	sys_rst  = 1'b1;
	end

always #10 sys_clk = ~sys_clk;
assign R = Drawer_inst.red;
assign G = Drawer_inst.green;
assign B = Drawer_inst.blue;
assign sprite_RGB = Drawer_inst.rgb_sprite;
assign back_RGB   = Drawer_inst.rgb_background;

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

always@(posedge sys_clk) begin
    if(ent >= 2'd3)
        ent <= 0;
    else if(VGA_X % 16 == 0)
        ent <= ent + 1;
    else
        ent <= ent;
end

vga_draw Drawer_inst	(	//	Read Out Side
    .iVGA_CLK    (sys_clk),
    .ivga_x      (VGA_X),
    .ivga_y      (VGA_Y),
    .iReset_n    (sys_rst),
    .iColor_SW   (iColor_SW),
    .iSprite      (ent),
    .oRGB        (draw_RGB)
);
endmodule
