module vga_ctrl(
    input  wire         vga_clk     , //VGA working clock, 25MHz
    input  wire         sys_rst_n   , //Reset signal. Low level is effective
    input  wire [15:0]  pix_data    , //Color information

    output wire [10:0]  pix_x       , //X coordinate
    output wire [10:0]  pix_y       , //Y coordinate
    output wire         hsync       , //Line sync signal
    output wire         vsync       , //Field sync signal
    output wire [15:0]  rgb         , //RGB565 data
    output wire         rgb_valid   //image valid signal
);

////
//\* Parameter and Internal Signal \//
////

//parameter define based on VGA timing diagram
parameter H_SYNC = 10'd96 ; //pixel clock cycles requested by line sync
parameter H_BACK = 10'd48 ; //pixel clock cycles requested by back edge of line sync
parameter H_VALID = 10'd640 ; //pixel clock cycles requested by valid data of line sync
parameter H_FRONT = 10'd16 ; //pixel clock cycles requested by front edge of line sync
parameter H_TOTAL = 10'd800 ; //total pixel clock cycles requested by line sync 
parameter V_SYNC = 10'd2 ; //line sync cycles requested by field sync
parameter V_BACK = 10'd33 ; //line sync cycles requested by back edge of field sync
parameter V_VALID = 10'd480 ; //line sync cycles requested by valid data of field sync
parameter V_FRONT = 10'd10 ; //line sync cycles requested by front edge of field sync
parameter V_TOTAL = 10'd525 ; //total line sync cycles requested by field sync

//wire define
wire pix_data_req ; //image request signal

//reg define
reg [11:0] cnt_h ; //counter for line sync
reg [11:0] cnt_v ; //counter for field sync

 ////
 //\* Main Code \//
 ////

 //Counter for line sync
 always@(posedge vga_clk or negedge sys_rst_n) begin
	 if(sys_rst_n == 1'b0)
		cnt_h <= 11'd0 ;
	 else if(cnt_h == H_TOTAL - 1'd1)
		cnt_h <= 11'd0 ;
	 else
		cnt_h <= cnt_h + 1'd1 ;
 end

 //Generate line sync signal 
 assign hsync = (cnt_h <= H_SYNC - 1'd1) ? 1'b1 : 1'b0 ;

 //Counter for field sync
 always@(posedge vga_clk or negedge sys_rst_n) begin
	 if(sys_rst_n == 1'b0)
		cnt_v <= 11'd0 ;
	 else if((cnt_v == V_TOTAL - 1'd1) && (cnt_h == H_TOTAL-1'd1))
		cnt_v <= 11'd0 ;
	 else if(cnt_h == H_TOTAL - 1'd1)
		cnt_v <= cnt_v + 1'd1 ;
	 else
		cnt_v <= cnt_v ;
 end

 //Generate field sync signal
 assign vsync = (cnt_v <= V_SYNC - 1'd1) ? 1'b1 : 1'b0 ;

 //Generate image valid signal
 assign rgb_valid = (((cnt_h >= H_SYNC + H_BACK)
 && (cnt_h < H_SYNC + H_BACK + H_VALID))
 &&((cnt_v >= V_SYNC + V_BACK)
 && (cnt_v < V_SYNC + V_BACK + V_VALID)))
 ? 1'b1 : 1'b0;

 //Generate pixel request signal
 assign pix_data_req = (((cnt_h >= H_SYNC + H_BACK - 1'b1)
 && (cnt_h<H_SYNC + H_BACK + H_VALID - 1'b1))
 &&((cnt_v >= V_SYNC + V_BACK)
 && (cnt_v < V_SYNC + V_BACK+ V_VALID)))
 ? 1'b1 : 1'b0;

 //Generate x and y coordinate of current pixel
 assign pix_x = (pix_data_req == 1'b1)
 ? (cnt_h - (H_SYNC + H_BACK - 1'b1)) : 10'h3ff;
 assign pix_y = (pix_data_req == 1'b1)
 ? (cnt_v - (V_SYNC + V_BACK)) : 10'h3ff;

 //Generate RGB signal
  assign rgb = (rgb_valid == 1'b1) ? pix_data : 16'hffff ;
//    assign rgb = 16'b0;

 endmodule