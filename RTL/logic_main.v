module logic_main(
    input          sys_clk       ,
    input          sys_rst       ,
    input  [0:1]   dir           ,
    output         update_clk    ,
    input   [9:0]  VGA_X         ,
    input   [9:0]  VGA_Y         ,
    output  [0:1]  cur_ent_code  ,
    output  [127:0] game_score   
);


game_logic game_logic_module (
	.vga_clk    (sys_clk     ),
	.update_clk (update_clk  ),
	.reset      (!sys_rst),
	.direction  (dir         ),
	.x_in       (VGA_X       ),
	.y_in       (VGA_Y       ),
	.entity     (cur_ent_code),
	.tail_count (game_score)
);

game_upd_clk upd_clk(
	.in_clk     (sys_clk    ),
	.sys_reset_n(sys_rst    ),
	.x_in       (VGA_X      ),
	.y_in       (VGA_Y      ),
	.out_clk    (update_clk )
);

endmodule