`include "../libs/define.vh"

module fsm (
    vga_clk             ,
    sys_rst_n           ,
    key_up              , 
    key_down            , 
    key_left            , 
    key_right           ,
    key_press           ,
    game_won            ,
    game_over           ,
    state
);

input vga_clk        ;
input sys_rst_n      ;
input key_up         ;
input key_down       ;
input key_left       ;
input key_right      ;

parameter GAME_START = 2'b00;
parameter IN_GAME = 2'b01;
parameter GAME_END = 2'b11;

reg [0:0] key_press;
reg [1:0] state;//Using Grey-Code to represent


always@(*)//detect key input
    if((key_up==1) || (key_down==1) || (key_left==1) || (key_down==1)) begin
        key_press = 1;
        end
    else begin
        key_press = 0;
        end


always@(posedge vga_clk or negedge sys_rst_n) begin//state machine to decide what to do next
    if(sys_rst_n == 1'b0)
	    state <= GAME_START; 
    else case(state)
        GAME_START:
            if(key_press==1) begin
                state <= IN_GAME;
                end
            else begin
                state <= GAME_START;
                end
        IN_GAME:
            if(game_won==1) begin
                state <= GAME_WON;
                end
            else if(game_over==1) begin
                state <= GAME_OVER;
                end
            else begin
                state <= IN_GAME;
                end
        GAME_END:
            if(key_press==1) begin
                state <= GAME_START;
                end
            else begin
                state <= GAME_END;
                end
        default: state <= GAME_START;
    endcase
end

always@(posedge vga_clk or negedge sys_rst_n) begin//state machine to decide what to do next
    if(sys_rst_n == 1'b0)

    if(state == GAME_START)    

    if(state == IN_GAME)

    if(state == GAME_END)

end
endmodule