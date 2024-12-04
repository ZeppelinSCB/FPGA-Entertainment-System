`timescale 1ns/1ns
module tb_key_in();

////
//\* Parameter and Internal Signal \//
////

//parameter define
/* In this simulation, the numbers are reduced to
   relative small numbers to reduce the simulation time */
 parameter CNT_1MS = 20'd19 ,
 CNT_11MS = 21'd69 ,
 CNT_41MS = 22'd149 ,
 CNT_51MS = 22'd199 ,
 CNT_60MS = 22'd249 ;

 //wire define
 wire key_flag ; //output
 wire [0:1] direction;
 //reg define
 reg sys_clk ;
 reg sys_rst_n ;
 reg key_up        ;
 reg key_down      ;
 reg key_left      ;
 reg key_right     ;
 reg key_in ; 
 reg [21:0] tb_cnt ;


 ////
 //\* Main Code \//
 ////

 //Init input signal
 initial begin
	 sys_clk = 1'b1;
	 sys_rst_n <= 1'b0;
	 key_up <= 1'b1;
	 key_down <= 1'b1;
	 key_left <= 1'b1;
	 key_right <= 1'b1;
	 #20
	 sys_rst_n <= 1'b1;
 end

 //System clock: 50MHz
 always #10 sys_clk = ~sys_clk;

 //Simulate jitter process
 always@(posedge sys_clk or negedge sys_rst_n) begin
	 if(sys_rst_n == 1'b0)
		tb_cnt <= 22'b0;
	 else if(tb_cnt == CNT_60MS)
		//The counter counts to CNT_60MS to complete 
		// the entire process from pressing to releasing a key.
		tb_cnt <= 22'b0;
	 else
		tb_cnt <= tb_cnt + 1'b1;
 end


 always@(posedge sys_clk or negedge sys_rst_n) begin
	 if(sys_rst_n == 1'b0)begin
		key_down <= 1'b1;
		key_up <= 1'b1;
		key_right <= 1'b1;
		key_left <= 1'b1;
	 end 
	 else if((tb_cnt >= CNT_1MS && tb_cnt <= CNT_11MS) || (tb_cnt >= CNT_41MS && tb_cnt <= CNT_51MS))begin
		 //Generate non-negative random numbers 0 and 1 in the counting interval 
		 //to simulate 10ms of pre-jitter and 10ms of post-jitter
		 key_up <= #20000 {$random} % 2;
		 key_down <= #20000 {$random} % 2;
		 key_left <= #20000 {$random} % 2;
		 key_right <= #20000 {$random} % 2;
	 end
	 else if(tb_cnt >= CNT_11MS && tb_cnt <= CNT_41MS)begin
		 key_up <= #20000 {$random} % 2;
		 key_down <= #20000 {$random} % 2;
		 key_left <= #20000 {$random} % 2;
		 key_right <= #20000 {$random} % 2;
	 end
		 //After 10ms of pre-jitter, the key is stabilized at a low level, 
		 //and the duration must be greater than CNT_MAX
	 else begin
		key_down <= 1'b1;
		key_up <= 1'b1;
		key_right <= 1'b1;
		key_left <= 1'b1; 
	 end
 end
 
 //------------------------------------------------------------
 //Get the internal variables of the instance "key_filter"
 wire [19:0] cnt_20ms = key_in_inst.cnt_20ms;
 //-------------------------------------------------------------

 ////
 //\* Instantiation \//
 ////

 //------------------------key_filter_inst------------------------
 key_in
 #(
 .CNT_MAX (20'd24 )
 /*
 Because the numbers are reduced, the parameter in the module also 
 should be changed. CNT_MAX must be smaller than CNT_41MS - CNT_11MS
 */
 )
 key_in_inst
 (
 .sys_clk (sys_clk ), //input sys_clk
 .sys_rst_n (sys_rst_n ), //input sys_rst_n
 .key_up (key_up ),
 .key_down (key_down ),
 .key_left (key_left ),
 .key_right (key_right ),

 .key_flag (key_flag ) //output key_flag
 );

 endmodule