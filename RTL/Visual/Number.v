module number
(
    number_i        ,
    number_x        ,
    number_y        ,
    scan_x          ,
    number          ,
    number_o        ,
    pix_x           ,
    pix_y
);

input   [3:0]   number_i     ;//number input
input   [3:0]   number_x     ;//x coordinate of pixel with respect to number
input   [3:0]   number_y     ;//y coordinate of pixel with respect to number

output  [0:0]   number_o     ;//number output

reg             scan_x       ;

                                //0          //1          //2          //3          //4          //5          //6          //7          //8          //9
assign          number[0] <= {8'b00111000, 8'b00011000, 8'b01111100, 8'b01111110, 8'b00011100, 8'b11111100, 8'b00111100, 8'b11111110, 8'b01111000, 8'b01111100};
assign          number[1] <= {8'b01001100, 8'b00111000, 8'b11000110, 8'b00001100, 8'b00111100, 8'b11000000, 8'b01100000, 8'b11000110, 8'b11000100, 8'b11000110};
assign          number[2] <= {8'b11000110, 8'b00011000, 8'b00001110, 8'b00011000, 8'b01101100, 8'b11111100, 8'b11000000, 8'b00001100, 8'b11100100, 8'b11000110};
assign          number[3] <= {8'b11000110, 8'b00011000, 8'b00111100, 8'b00111100, 8'b11001100, 8'b00000110, 8'b11111100, 8'b00011000, 8'b01111000, 8'b01111110};
assign          number[4] <= {8'b11000110, 8'b00011000, 8'b01111000, 8'b00000110, 8'b11111110, 8'b00000110, 8'b11000110, 8'b00110000, 8'b10000110, 8'b00000110};
assign          number[5] <= {8'b01100100, 8'b00011000, 8'b11100000, 8'b11000110, 8'b00001100, 8'b11000110, 8'b11000110, 8'b00110000, 8'b10000110, 8'b00001100};
assign          number[6] <= {8'b00111000, 8'b01111110, 8'b11111110, 8'b01111100, 8'b00001100, 8'b01111100, 8'b01111100, 8'b00110000, 8'b01111100, 8'b01111000};
assign          number[7] <= {8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000};


always@(*)
begin
    scan_x = number_x + number_i*8;
    number_o = number[number_y][scan_x];
end

endmodule  