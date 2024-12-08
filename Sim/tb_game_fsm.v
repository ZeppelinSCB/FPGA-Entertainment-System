`timescale 1ns/1ns
module tb_game_fsm();
 //reg define
 reg sys_clk ;
 reg sys_rst_n ;
 reg key ;
 reg game_over;

 //wire define
 wire[2:0] state;
 wire[2:0] next_state;


 //Init inputs
 initial begin
 game_over = 1'b0;
 sys_clk = 1'b1;
 sys_rst_n <= 1'b0;
 #20
 sys_rst_n <= 1'b1;
 #60
 game_over = 1'b1;
 #60
    game_over = 1'b0;
 end

 //Simulate system clock (50M Hz)
 always #10 sys_clk = ~sys_clk;

 //Generate the random input
 always@(posedge sys_clk or negedge sys_rst_n)
 if(sys_rst_n == 1'b0)
 key <= 1'b0;
 else
 key <= {$random} % 2; //取模求余数，产生非负随机数0、1

 //------------------------------------------------------------
 //Get the internal variables of the instance "simple_fsm_inst"
 //-------------------------------------------------------------
assign next_state = game_fsm_inst.next_state;
game_fsm game_fsm_inst(
    .iClk         (sys_clk),    
    .iRst_n       (sys_rst_n),    
    .iKey_up      (0),    
    .iKey_down    (0),    
    .iKey_left    (0),    
    .iKey_right   (key),    
    .iGame_won    (0),    
    .iGame_over   (game_over),    
    .oState       (state)
);

 endmodule