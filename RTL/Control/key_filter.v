module key_filter
#(
parameter CNT_MAX = 20'd999_999 //The maximum counter number
)
(
input wire sys_clk , //System clock, 50MHz
input wire sys_rst_n , //Reset signal
input wire key_in , //Key input signal

output reg key_flag //Output. Thge rising edge means the key is pressed 
);

////
//\* Parameter and Internal Signal \//
////
//reg define
reg [19:0] cnt_20ms ; //counter

////
//\* Main Code \//
////

// When the key is pressed, start counter
always@(posedge sys_clk or negedge sys_rst_n) begin
	if(sys_rst_n == 1'b0)
		cnt_20ms <= 20'b0;
	else if(key_in == 1'b1)
		cnt_20ms <= 20'b0;
	else if(cnt_20ms == CNT_MAX && key_in == 1'b0)
		cnt_20ms <= cnt_20ms;
	else
		cnt_20ms <= cnt_20ms + 1'b1;
end

// When the counter reaches CNT_MAX - 1, output is 1
always@(posedge sys_clk or negedge sys_rst_n) begin
	if(sys_rst_n == 1'b0)
		key_flag <= 1'b0;
	else if(cnt_20ms == CNT_MAX - 1'b1)
		key_flag <= 1'b1;
	else
		key_flag <= 1'b0;
end

endmodule