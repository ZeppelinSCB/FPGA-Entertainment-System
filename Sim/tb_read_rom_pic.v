`timescale  1ns/1ns
module  tb_read_rom_pic();

wire [15:0] sprite_RGB;
wire [15:0] out_RGB   ;
wire [19:0] rom_addr  ;
wire [9:0]  pic_x     ;
wire [9:0]  pic_y     ;
reg  [9:0]  VGA_X     ;
reg  [9:0]  VGA_Y     ;
reg         sys_clk   ;
reg         sys_rst   ;
wire        rd_en     ;

initial
	begin
    VGA_X = 0;
    VGA_Y = 0;
    sys_clk   = 1;
	sys_rst  = 1'b0;
	#200
	sys_rst  = 1'b1;
	end

always #10 sys_clk = ~sys_clk;
assign sprite_RGB = read_rom_pic_inst.rom_data;
assign rom_addr   = read_rom_pic_inst.rom_addr;
assign rd_en      = read_rom_pic_inst.rd_en;
assign pic_x      = read_rom_pic_inst.pic_x;
assign pic_y      = read_rom_pic_inst.pic_y;

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

read_rom_pic read_rom_pic_inst	(	//	Read Out Side
    .vga_clk     (sys_clk),
    .sys_rst_n   (sys_rst),
    .pix_x       (VGA_X),
    .pix_y       (VGA_Y),

    .pix_data_out(out_RGB)
);
endmodule
