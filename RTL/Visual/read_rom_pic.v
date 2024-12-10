module read_rom_pic
(
input wire vga_clk , //VGA working clock, 25MHz
input wire sys_rst_n , //Reset signal. Low level is effective
input wire [9:0] pix_x , //x coordinate of current pixel
input wire [9:0] pix_y , //y coordinate of current pixel

output wire [15:0] pix_data_out //color information

);

////
//\* Parameter and Internal Signal \//
////

parameter 
H_VALID = 10'd640 , //Maximum x value
V_VALID = 10'd480 ; //Maximum y value

parameter 
    /*
    H_PIC   = 10'd240 , //Length of image
    W_PIC   = 10'd320 , //Width of image
PIC_SIZE= 19'd76800 ; //Total pixel number
    */
    
    H_PIC   =10'd100,
    W_PIC   =10'd100,
    H_DISP  =10'd100,
    W_DISP  =10'd100,
    PIC_SIZE=20'd10000;
    

parameter 
RED = 16'hF800, //RED
ORANGE = 16'hFC00, //Orange
YELLOW = 16'hFFE0, //Yellow
GREEN = 16'h07E0, //Green
CYAN = 16'h07FF, //Cyan
BLUE = 16'h001F, //Blue
PURPPLE = 16'hF81F, //Purple
BLACK = 16'h0000, //Black
WHITE = 16'hFFFF, //White
GRAY = 16'hD69A; //Grey

//wire define
wire rd_en ; //ROM read enable
wire [15:0] rom_data ; //data from ROM

//reg define
reg [19:0] rom_addr ; //ROM address
reg pic_valid ; //picture valid signal
reg [15:0] pix_data ; //beckground data
reg [15:0] map_data ; //rendered

////
//\* Main Code \//
////

//Generate read enable signal
assign rd_en = (((pix_x >= (((H_VALID - H_PIC)/2) - 1'b1))
&& (pix_x < (((H_VALID - H_PIC)/2) + H_PIC - 1'b1)))
&&((pix_y >= ((V_VALID - W_PIC)/2))
&& ((pix_y < (((V_VALID - W_PIC)/2) + W_PIC)))));

//Generate picture valid signal
always@(posedge vga_clk or negedge sys_rst_n) begin
	if(sys_rst_n == 1'b0)
		pic_valid <= 1'b1;
	else
		pic_valid <= rd_en;
end

//Generate final output color signal
assign pix_data_out = (pic_valid == 1'b1) ? rom_data : pix_data;

always@(*)
    map_data <= rom_data;

//Generate background color data
always@(posedge vga_clk or negedge sys_rst_n) begin
	if(sys_rst_n == 1'b0)
		pix_data <= 16'd0;
	else if((pix_x >= 0) && (pix_x < (H_VALID/10)*1))
		pix_data <= RED;
	else if((pix_x >= (H_VALID/10)*1) && (pix_x < (H_VALID/10)*2))
		pix_data <= ORANGE;
	else if((pix_x >= (H_VALID/10)*2) && (pix_x < (H_VALID/10)*3))
		pix_data <= YELLOW;
	else if((pix_x >= (H_VALID/10)*3) && (pix_x < (H_VALID/10)*4))
		pix_data <= GREEN;
	else if((pix_x >= (H_VALID/10)*4) && (pix_x < (H_VALID/10)*5))
		pix_data <= CYAN;
	else if((pix_x >= (H_VALID/10)*5) && (pix_x < (H_VALID/10)*6))
		pix_data <= BLUE;
	else if((pix_x >= (H_VALID/10)*6) && (pix_x < (H_VALID/10)*7))
		pix_data <= PURPPLE;
	else if((pix_x >= (H_VALID/10)*7) && (pix_x < (H_VALID/10)*8))
		pix_data <= BLACK;
	else if((pix_x >= (H_VALID/10)*8) && (pix_x < (H_VALID/10)*9))
		pix_data <= WHITE;
	else if((pix_x >= (H_VALID/10)*9) && (pix_x < H_VALID))
		pix_data <= GRAY;
	else
		pix_data <= BLACK;
end

//Generate ROM address signal
always@(posedge vga_clk or negedge sys_rst_n) begin
	if(sys_rst_n == 1'b0)
		rom_addr <= 19'd0;
	else if(rom_addr == (PIC_SIZE - 1'b1))
		rom_addr <= 19'd0;
	else if(rd_en == 1'b1)
		rom_addr <= rom_addr + 1'b1;
end

////
 //\* Instantiation \//
 ////

 //------------- rom_pic_inst -------------
rom_pic rom_pic_inst
(
.address (rom_addr ), //ROM address,14 bits
.clock (vga_clk ), //Working clock
.rden (rd_en ), //read enable signal

.q (rom_data ) //Output data, 16 bits
);

 endmodule