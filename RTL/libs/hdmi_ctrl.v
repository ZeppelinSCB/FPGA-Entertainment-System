module hdmi_ctrl
(
input wire clk_1x , //input system clock
input wire clk_5x , //input 5x system clock
input wire sys_rst_n , //reset
input wire [7:0] rgb_blue , //blue
input wire [7:0] rgb_green , //green
input wire [7:0] rgb_red , //red
input wire hsync , //horizontal sync
input wire vsync , //vertical sync
input wire de , //enable signal

output wire hdmi_clk_p ,
output wire hdmi_clk_n , //clock differential signal
output wire hdmi_r_p ,
output wire hdmi_r_n , //red differential signal
output wire hdmi_g_p ,
output wire hdmi_g_n , //green differential signal
output wire hdmi_b_p ,
output wire hdmi_b_n //blue differential signal
);

////
//\* Parameter and Internal Signal \//
////
wire [9:0] red ; //8b to 10b red component
wire [9:0] green ; //8b to 10b green component
wire [9:0] blue ; //8b to 10b blue component

////
//\* Instantiate \//
////
//------------- encode_inst0 -------------
encode encode_inst0
(
.sys_clk (clk_1x ),
.sys_rst_n (sys_rst_n ),
.data_in (rgb_blue ),
.c0 (hsync ),
.c1 (vsync ),
.de (de ),
.data_out (blue )
);

//------------- encode_inst1 -------------
encode encode_inst1
(
.sys_clk (clk_1x ),
.sys_rst_n (sys_rst_n ),
.data_in (rgb_green ),
.c0 (hsync ),
.c1 (vsync ),
.de (de ),
.data_out (green )
);

//------------- encode_inst2 -------------
encode encode_inst2
(
.sys_clk (clk_1x ),
.sys_rst_n (sys_rst_n ),
.data_in (rgb_red ),
.c0 (hsync ),
.c1 (vsync ),
.de (de ),
.data_out (red )
);

//------------- par_to_ser_inst0 -------------
par_to_ser par_to_ser_inst0
(
.clk_5x (clk_5x ),
.par_data (blue ),

.ser_data_p (hdmi_b_p ),
.ser_data_n (hdmi_b_n )
);

//------------- par_to_ser_inst1 -------------
par_to_ser par_to_ser_inst1
(
.clk_5x (clk_5x ),
.par_data (green ),

.ser_data_p (hdmi_g_p ),
.ser_data_n (hdmi_g_n )
);

//------------- par_to_ser_inst2 -------------
par_to_ser par_to_ser_inst2
(
.clk_5x (clk_5x ),
.par_data (red ),

.ser_data_p (hdmi_r_p ),
.ser_data_n (hdmi_r_n )
);

//------------- par_to_ser_inst3 -------------
 par_to_ser par_to_ser_inst3
 (
 .clk_5x (clk_5x ),
 .par_data (10'b1111100000),

 .ser_data_p (hdmi_clk_p ),
 .ser_data_n (hdmi_clk_n )
 );

 endmodule