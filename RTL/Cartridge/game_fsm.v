`include "../libs/define.vh"

module game_fsm (
    iClk             ,
    iRst_n           ,
    iKey_up              , 
    iKey_down            , 
    iKey_left            , 
    iKey_right           ,
    iGame_won            ,
    iGame_over           ,
    oState
);

input             iClk            ;
input             iRst_n          ;
input             iKey_up         ;
input             iKey_down       ;
input             iKey_left       ;
input             iKey_right      ;
input             iGame_won       ;
input             iGame_over      ;
output wire [2:0] oState          ;

reg [2:0] next_state;
reg       key_press;

always@(posedge iClk or negedge iRst_n) begin
    if(iRst_n == 1'b0)
        key_press <= 1'b0;
    else if (iKey_up || iKey_down || iKey_left || iKey_right)
        key_press <= 1'b1;
    else
        key_press <= 1'b0;
end

assign oState = next_state;

always@(posedge iClk or negedge iRst_n) begin//oState machine to decide what to do next
    if(iRst_n == 1'b0)
	    next_state <= `STATE_START; 
    else
    case(oState)
        `STATE_START:
            if(key_press) begin
                next_state <= `STATE_INGAME;
                end
            else begin
                next_state <= `STATE_START;
                end
        `STATE_INGAME:
            if(iGame_won==1'b1) begin//Currently ignore game won
                next_state <= `STATE_INGAME;
                end
            else if(iGame_over==1'b1) begin
                next_state <= `STATE_OVER;
                end
            else begin
                next_state <= `STATE_INGAME;
                end
        `STATE_WON:
            if(key_press==1'b1) begin
                next_state <= `STATE_START;
                end
            else begin
                next_state <= `STATE_WON;
                end
        `STATE_OVER:
            if(key_press==1'b1) begin
                next_state <= `STATE_START;
                end
            else begin
                next_state <= `STATE_OVER;
                end
        default: 
            next_state <= oState;
    endcase
end
endmodule