module main(
	input           sys_clk             ,
	input           sys_rst_n			,
    //Key Input
	input           key_up				,
	input           key_down			,
	input           key_left			,
	input           key_right			,
	//IR Remote Input
	input           remote_in			,
	
	//vgaport
	output          vga_hs				,
	output          vga_vs				,
	output  [15:0]  vga_rgb			    ,
    //hdmi port
    output wire       ddc_scl           ,
    output wire       ddc_sda           ,
    output wire       tmds_clk_p        , // HDMI Clock
    output wire       tmds_clk_n        ,
    output wire [2:0] tmds_data_p       , // HDMI Data
    output wire [2:0] tmds_data_n       ,
	//segment display
	output [ 5:0]     seg_sel              ,
    output [ 7:0]     seg_led              ,
    //Buzzer
    output            beep_en             
);

	wire        		 vga_clk_w		; //25Mhz Clock
    wire     		     hdmi_clk_5x_w	; //P125Mhz Clock
	wire        		 locked_w		; //PLL Lock signal
	wire        		 rst_n_w		; //内部复位信号
	wire [15:0] 		 pixel_data_w	; //pixel ir_ in Hex color
	wire [ 9:0] 		 pixel_xpos_w	; //pixel coord
	wire [ 9:0] 		 pixel_ypos_w	; //pixel coord   

    wire hsync_in                       ; //Internal
    wire vsync_in                       ; //Internal
    wire [15:0] rgb_in                  ; //Internal
    wire rgb_valid                      ; //vga valid signal

	wire        		ir_repeat_en	; //Repeat Signal
	wire        		ir_data_en		; //IR Data Valid
	wire [7:0]  		ir_data			; //IR Data
	
	wire [19:0] 		seg_score		;
	wire        		seg_en			;
	wire        		seg_sign		;
	wire [5:0]  		seg_point		;
	
	wire        		key_l			;
	wire        		key_r			;
	wire        		key_u			;
	wire        		key_d			;

	wire        		ky_right		;
	wire        		ky_left			;
	wire        		ky_up			;
	wire        		ky_down			;

	wire        		beep_clk		;
	wire                beep_en_eat     ;

    wire [9:0]          food_coord [1:0];
    wire [14:0]         snake_x[20:0];
    wire [14:0]         snake_y[20:0];
    wire [12:0]         snake_cur_len;





//待PLL输出稳定之后，停止复位
assign rst_n_w = sys_rst_n && locked_w;

assign vga_rgb = rgb_in;
   
clk_gen	clk_gen_inst(                      //时钟分频模块
	//in
	.inclk0         (sys_clk),    
	.areset         (~sys_rst_n),
    
	//out
	.c0             (vga_clk_w),          //VGA时钟 25M
	.locked         (locked_w),
    .c1             (hdmi_clk_5x_w)          //HDMI时钟 25M
	); 

vga_ctrl vga_ctrl_inst(
	//in
    .vga_clk        (vga_clk_w),    
    .sys_rst_n      (rst_n_w),  
	.pix_data       (pixel_data_w),  

	//out
    .hsync          (hsync_in),
    .vsync          (vsync_in),
    .rgb            (rgb_in),
    .rgb_valid      (rgb_valid),
    .pix_x          (pixel_xpos_w), 
    .pix_y          (pixel_ypos_w)
    ); 

game_logic game_logic_inst(
    //in
    .game_clk      (vga_clk_w),
    .sys_rst_n     (res_n_w),
    .key_down      (key_d),
	.kf_down       (kf_down),
	.key_up        (key_u),
	.kf_up         (kf_up),
	.key_left      (key_l),
	.kf_left       (kf_left),
	.key_right     (key_r),
	.kf_right      (kf_right),
    .ir_flag       (ir_),
    // out
    .seg_en        (seg_en	 ),
    .seg_point     (seg_sign ),
    .seg_sign      (seg_point),
    .beep_clk      (beep_clk   ),
    .beep_en_eat   (beep_en_eat),
    .food_x        (food_coord[0]),
    .food_y        (food_coord[1]),
    .snake_x       (snake_x),
    .snake_y       (snake_y),
    .snake_cur_len (snake_cur_len),
    .score         (seg_score)
);

pixel_renderer renderer_inst(
	//in
    .vga_clk        (vga_clk_w),
    .sys_rst_n      (rst_n_w),
    .pixel_xpos     (pixel_xpos_w),
    .pixel_ypos     (pixel_ypos_w),
    .food_x         (food_coord[0]),
    .food_y         (food_coord[1]),
    .snake_x        (snake_x),
    .snake_y        (snake_y),
    .snake_cur_len  (snake_cur_len),
    //out
    .pixel_data     (pixel_data_w)
);

/*
//Buzzer
beep u_beep(
	//in
    .sys_clk         (vga_clk_w),
	.sys_rst_n       (sys_rst_n),
	.beep_en_eat     (beep_en_eat),

	//OUT
	// .enb             (beep_clk),
	.beep_en         (beep_en)
	);
*/

//led闪烁
led led_inst(
    // .sys_clk(sys_clk),  
	.sys_clk(vga_clk_w),     
    .sys_rst_n(sys_rst_n),    

    .trigger(beep_en_eat),    // 连接触发LED闪烁的信号

    .led(led)              // 连接到LED的第一个输出
);

remote_rcv remote_rcv_inst(
    .sys_clk         (sys_clk),
	.sys_rst_n       (sys_rst_n),
	 
	.remote_in       (remote_in),
	.ir_       (ir_),
	.ir_data_en         (ir_data_en),
	.ir_            (ir_)
);	 

seg_led seg_led_inst(
    .clk         (sys_clk),
	.rst_n       (sys_rst_n),
	
	.ir_            (score),
	.en              (en),
	.point           (point),
	.sign            (sign),
	
	.seg_led         (seg_led),
	.seg_sel         (seg_sel)
);











	



//以下是按键触发代码
key_debounce u_left(
	//in
    .sys_clk         (vga_clk_w),
	.sys_rst_n       (sys_rst_n),
	
	.key             (key_left),

	//out
	.key_value       (key_l),//向左
	.key_flag        (kf_left)
);

key_debounce u_right(
	//in
    .sys_clk         (vga_clk_w),
	.sys_rst_n       (sys_rst_n),
	
	.key             (key_right),
	
	//out
	.key_value       (key_r),//向右
	.key_flag        (kf_right)
);	

key_debounce u_up(
	//in
    .sys_clk         (vga_clk_w),
	.sys_rst_n       (sys_rst_n),
	
	.key             (key_up),
	
	//out
	.key_value       (key_u),//向上
	.key_flag        (kf_up)
);

key_debounce u_down(
	//in
    .sys_clk         (vga_clk_w),
	.sys_rst_n       (sys_rst_n),
	
	.key             (key_down),
	
	//out
	.key_value       (key_d),//向下
	.key_flag        (kf_down)
);

//------------- hdmi_ctrl_inst -------------
hdmi_ctrl hdmi_ctrl_inst
(
.clk_1x (vga_clk_w ), //输入系统时钟
.clk_5x (hdmi_clk_5x_w), //输入5倍系统时钟
.sys_rst_n (rst_n_w ), //复位信号,低有效
.rgb_blue ({rgb_in[4:0],3'b0} ), //蓝色分量
.rgb_green ({rgb_in[10:5],2'b0} ), //绿色分量
.rgb_red ({rgb_in[15:11],3'b0} ), //红色分量
.hsync (hsync_in ), //行同步信号
.vsync (vsync_in ), //场同步信号
.de (rgb_valid ), //使能信号
.hdmi_clk_p (tmds_clk_p ),
.hdmi_clk_n (tmds_clk_n ), //时钟差分信号
.hdmi_r_p (tmds_data_p[2] ),
.hdmi_r_n (tmds_data_n[2] ), //红色分量差分信号
.hdmi_g_p (tmds_data_p[1] ),
.hdmi_g_n (tmds_data_n[1] ), //绿色分量差分信号
.hdmi_b_p (tmds_data_p[0] ),
.hdmi_b_n (tmds_data_n[0] ) //蓝色分量差分信号
);
endmodule 