`include "../libs/define.vh"

module key_input
(
    iK_Left     ,
    iK_Right    ,
    iK_Up       ,
    iK_Down     ,
    iClk        , // clock
    oF_kUp      ,
    oF_kDown    ,
    oF_kLeft    ,
    oF_kRight   ,
    oDirection  
);

input wire
    iK_Left     ,
    iK_Right    ,
    iK_Up       ,
    iK_Down     ,
    iClk        ; // clock
output wire
    oF_kUp      ,
    oF_kDown    ,
    oF_kLeft    ,
    oF_kRight   ;
output reg [0:1] 
    oDirection;

initial begin
    oDirection = `TOP_DIR;
    end

always @(posedge iClk) begin
    if (oF_kUp && (oDirection!=`DOWN_DIR))
        oDirection = `TOP_DIR;
    else if(oF_kDown && (oDirection!=`TOP_DIR))
        oDirection = `DOWN_DIR;
    else if(oF_kLeft && (oDirection!=`RIGHT_DIR))
        oDirection = `LEFT_DIR;
    else if(oF_kRight && (oDirection!=`LEFT_DIR))
        oDirection = `RIGHT_DIR;
    else
        oDirection = oDirection;
end

//Key Debounce
key_filter filter_left(
    .sys_clk(iClk),
    .sys_rst_n(1'b1),
    .key_in(iK_Left),
    .key_flag(oF_kLeft)
);

key_filter filter_right(
    .sys_clk(iClk),
    .sys_rst_n(1'b1),
    .key_in(iK_Right),
    .key_flag(oF_kRight)
);

key_filter filter_up(
    .sys_clk(iClk),
    .sys_rst_n(1'b1),
    .key_in(iK_Up),
    .key_flag(oF_kUp)
);

key_filter filter_down(
    .sys_clk(iClk),
    .sys_rst_n(1'b1),
    .key_in(iK_Down),
    .key_flag(oF_kDown)
);
endmodule