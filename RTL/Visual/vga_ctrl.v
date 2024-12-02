module	VGA_Ctrl	(	//	Host Side
						iRGB        ,
						oCurrent_X  ,
						oCurrent_Y  ,
                        oVga_valid  ,
						//	VGA Side
						oVGA_RGB    ,
						oVGA_HS     ,
						oVGA_VS     ,
						//	Control Signal
						iCLK        ,
						reset       	
                    );
//	Host Side
input  [15:0]	iRGB;
output	[9:0]	oCurrent_X;
output	[9:0]	oCurrent_Y;
//	VGA Side
output [15:0] oVGA_RGB;
output reg    oVGA_HS;
output reg	  oVGA_VS;
output reg    oVga_valid;
//	Control Signal
input		iCLK;
input		reset;	
//	Internal Registers
reg		[9:0]	H_Cont;
reg		[9:0]	V_Cont;
////////////////////////////////////////////////////////////
// Following parameters produces a 640x480 60Hz 60 FPS image
//	Horizontal	Parameter

	localparam	H_FRONT	=	16;
	localparam	H_SYNC	=	96;
	localparam	H_BACK	=	48;
	localparam	H_ACT	=	640;
	localparam	H_BLANK	=	H_FRONT+H_SYNC+H_BACK;
	localparam	H_TOTAL	=	H_FRONT+H_SYNC+H_BACK+H_ACT;
////////////////////////////////////////////////////////////
//	Vertical Parameter

	localparam	V_FRONT	=	10;
	localparam	V_SYNC	=	2;
	localparam	V_BACK	=	33;
	localparam	V_ACT	=	480;
	parameter	V_BLANK	=	V_FRONT+V_SYNC+V_BACK;
	parameter	V_TOTAL	=	V_FRONT+V_SYNC+V_BACK+V_ACT;
////////////////////////////////////////////////////////////
	assign	oVGA_RGB    =	(oCurrent_X > 0) ?	iRGB : 0 ;
	
	assign	oCurrent_X	=	(H_Cont>=H_BLANK)	?	H_Cont-H_BLANK	:	10'h0	;
	assign	oCurrent_Y	=	(V_Cont>=V_BLANK)	?	V_Cont-V_BLANK	:	10'h0	;

//	Horizontal Generator: Refer to the pixel clock
	always@(posedge iCLK or posedge reset)
	begin
		if(reset)
		begin
			H_Cont		<=	0;
			oVGA_HS		<=	1;
		end
		else
		begin
			//Vertical sync
			if(H_Cont<H_TOTAL-1)
				H_Cont	<=	H_Cont+1'b1;
			else
				H_Cont	<=	0;
			//	Horizontal Sync
			if(H_Cont==H_FRONT-1)			//	Front porch end
				oVGA_HS	<=	1'b0;
			if(H_Cont==H_FRONT+H_SYNC-1)	//	Sync pulse end
				oVGA_HS	<=	1'b1;
		end
	end
	
//	Vertical Generator: Refer to the horizontal sync
	always@(posedge oVGA_HS or posedge reset)
	begin
		if(reset)
			begin
				V_Cont		<=	0;
				oVGA_VS		<=	1;
			end
		else
		begin
			if(V_Cont<V_TOTAL-1)
				V_Cont	<=	V_Cont+1'b1;
			else
				V_Cont	<=	0;
			//	Vertical Sync
			if(V_Cont==V_FRONT-1)			//	Front porch end
				oVGA_VS	<=	1'b0;
			if(V_Cont==V_FRONT+V_SYNC-1)	//	Sync pulse end
				oVGA_VS	<=	1'b1;
		end
	end
	
	
endmodule