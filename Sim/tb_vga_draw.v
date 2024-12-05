`timescale  1ns/1ns
module  tb_vga_draw();

wire [15:0] draw_RGB  ;
wire        dR        ;
wire        dG        ;
wire        dB        ;
wire [15:0] out_RGB   ;
wire        hsync     ;
wire        vsync     ;
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
    iColor_SW <= 1;
    ent      <= 1;
	sys_rst  <= 1'b0;
	#200
	sys_rst  <= 1'b1;
	end

always #10 sys_clk = ~sys_clk;
assign dR = Drawer_inst.oRed;
assign dG = Drawer_inst.oGreen;
assign dB = Drawer_inst.oBlue;

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

vga_draw Drawer_inst	(	//	Read Out Side
        .oRGB     (draw_RGB),
        .oVGA_X   (VGA_X),
        .oVGA_Y   (VGA_Y),
        .iVGA_CLK (sys_clk),
        .reset    (!sys_rst),
        .iColor_SW(iColor_SW),
        .ent      (ent)
    );
endmodule
