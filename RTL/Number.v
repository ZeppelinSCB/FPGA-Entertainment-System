always@(posedge vga_clk) begin
               //0          //1          //2          //3          //4          //5          //6          //7          //8          //9
    number[0] <= {8'b00111000, 8'b00011000, 8'b01111100, 8'b01111110, 8'b00011100, 8'b11111100, 8'b00111100, 8'b11111110, 8'b01111000, 8'b01111100}
    number[1] <= {8'b01001100, 8'b00111000, 8'b11000110, 8'b00001100, 8'b00111100, 8'b11000000, 8'b01100000, 8'b11000110, 8'b11000100, 8'b11000110}
    number[2] <= {8'b11000110, 8'b00011000, 8'b00001110, 8'b00011000, 8'b01101100, 8'b11111100, 8'b11000000, 8'b00001100, 8'b11100100, 8'b11000110}
    number[3] <= {8'b11000110, 8'b00011000, 8'b00111100, 8'b00111100, 8'b11001100, 8'b00000110, 8'b11111100, 8'b00011000, 8'b01111000, 8'b01111110}
    number[4] <= {8'b11000110, 8'b00011000, 8'b01111000, 8'b00000110, 8'b11111110, 8'b00000110, 8'b11000110, 8'b00110000, 8'b10000110, 8'b00000110}
    number[5] <= {8'b01100100, 8'b00011000, 8'b11100000, 8'b11000110, 8'b00001100, 8'b11000110, 8'b11000110, 8'b00110000, 8'b10000110, 8'b00001100}
    number[6] <= {8'b00111000, 8'b01111110, 8'b11111110, 8'b01111100, 8'b00001100, 8'b01111100, 8'b01111100, 8'b00110000, 8'b01111100, 8'b01111000}
    number[7] <= {8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000}  
end





