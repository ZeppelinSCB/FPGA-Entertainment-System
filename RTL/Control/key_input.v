`include "../libs/define.vh"

module key_input
(
    iK_Left     ,
    iK_Right    ,
    iK_Up       ,
    iK_Down     ,
    iClk        , // clock
    oDirection  
);

input wire
    iK_Left     ,
    iK_Right    ,
    iK_Up       ,
    iK_Down     ,
    iClk        ; // clock
output reg [0:1] 
    oDirection;

wire left, right, up, down;

initial begin
    oDirection = `TOP_DIR;
    end

always @(posedge iClk) begin
    if (up && (oDirection!=`DOWN_DIR))
        oDirection = `TOP_DIR;
    else if(down && (oDirection!=`TOP_DIR))
        oDirection = `DOWN_DIR;
    else if(left && (oDirection!=`RIGHT_DIR))
        oDirection = `LEFT_DIR;
    else if(right && (oDirection!=`LEFT_DIR))
        oDirection = `RIGHT_DIR;
    else
        oDirection = oDirection;
end

//Key Debounce
key_filter filter_left(
    .sys_clk(iClk),
    .sys_rst_n(1'b1),
    .key_in(iK_Left),
    .key_flag(left)
);

key_filter filter_right(
    .sys_clk(iClk),
    .sys_rst_n(1'b1),
    .key_in(iK_Right),
    .key_flag(right)
);

key_filter filter_up(
    .sys_clk(iClk),
    .sys_rst_n(1'b1),
    .key_in(iK_Up),
    .key_flag(up)
);

key_filter filter_down(
    .sys_clk(iClk),
    .sys_rst_n(1'b1),
    .key_in(iK_Down),
    .key_flag(down)
);
endmodule