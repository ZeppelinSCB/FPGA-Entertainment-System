`include "../libs/define.vh"

module fsm (
    vga_clk             ,
    sys_rst_n           ,
	one_resistor_x      ,
    two_resistors_x     ,
    one_resistor_y      ,
    two_resistors_y     ,
    state
);

input vga_clk        ;
input sys_rst_n      ;
input one_resistor_x ;
input two_resistors_x;
input one_resistor_y ;
input two_resistors_y;

parameter KEY_PRESS = 1'b1;
parameter GAME_START = 3'b000;
parameter DIFF_SEL = 3'b001;
parameter GAME_END = 3'b011;

reg [2:0] state;

endmodule