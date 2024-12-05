module tb_game_logic();

reg        sys_clk      ;
reg        sys_rst      ;
reg [0:1]  dir          ;
wire        update_clk   ;
reg [9:0]  VGA_X        ;
reg [9:0]  VGA_Y        ;
wire [0:1]  cur_ent_code ;
wire was_updated;
wire [2:0] drawing_cycles_passed;
initial
	begin
    VGA_X = 0;
    VGA_Y = 0;
    dir   = 2'b00;
    sys_clk   = 1;
	sys_rst  <= 1'b0;
	#200
	sys_rst  <= 1'b1;
	end

always #10 sys_clk = ~sys_clk;
assign was_updated = logic_main_inst.upd_clk.was_updated;
assign drawing_cycles_passed = logic_main_inst.upd_clk.drawing_cycles_passed;
always@(posedge sys_clk) begin
    if(dir >= 2'b11)
        dir <= 2'b00;
    else
        dir <= dir+1;
end

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

logic_main logic_main_inst(
    .sys_clk      (sys_clk     ),
    .sys_rst      (sys_rst     ),
    .dir          (dir         ),
    .update_clk   (update_clk  ),
    .VGA_X        (VGA_X       ),
    .VGA_Y        (VGA_Y       ),
    .cur_ent_code (cur_ent_code)
);


endmodule