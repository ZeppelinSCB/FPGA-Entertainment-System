`timescale  1ns/1ns
module  tb_menu();

wire [15:0] draw_RGB  ;
wire [15:0] pix_data  ;
reg  [9:0]  VGA_X     ;
reg  [9:0]  VGA_Y     ;
reg         sys_clk   ;
reg         sys_rst   ;
reg         iColor_SW ;
reg [0:1]   ent       ;

wire [32:0] letter_req;
wire [9:0] relative_x;
wire [9:0] relative_y;
wire        letter_pixel;
wire [5:0]  stringIndex;

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
assign letter_pixel = page_start_inst.letter_o;
assign pix_data     = page_start_inst.pix_data;
assign stringIndex  = page_start_inst.stringIndex;
assign relative_x = page_start_inst.relative_x;
assign relative_y = page_start_inst.relative_y;
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

page_start page_start_inst	(	//	Read Out Side
    .vga_clk   (sys_clk),      
    .sys_rst_n (sys_rst),      
    .screen_x  (VGA_X),      
    .screen_y  (VGA_Y),      
    .pix_data  (draw_RGB)
);
endmodule
