module game_time
(   
    sys_clk         ,
    time_rst        ,   
    counter         ,
    time_1s         ,
    time_10s        ,
    time_100s       ,
    time_max_flag
);

input wire                  sys_clk      ;
input wire                  time_rst     ;

output          [ 3:0]      time_1s      ;  
output          [ 3:0]      time_10s     ;
output          [ 3:0]      time_100s    ;
output          [ 0:0]      time_max_flag;

reg             [24:0]      counter      ;



always@(posedge sys_clk or negedge sys_rst_n)//Time counter
begin 
	//One should use or to connect 
	if((time_rst == 1'b0)||(game_over = 1'b1))
    begin
		counter <= 0;
        time_1s   [3:0] <= 4'b0;
        time_10s  [3:0] <= 4'b0;
        time_100s [3:0] <= 4'b0;
	end
	else if(counter == 0)
	begin
		counter = 2499_9999; // 2499_9999;
        if(time_max_flag == 1'b0)
        begin
            time_1s [3:0] = time_1s [3:0] + 1'b1;
            if(time_1s == 4'b1010)
            begin
                time_1s <= 0;
                time_10s <= time_10s + 1'b1;
                if(time_10s == 4'b1010)
                begin
                    time_10s <= 0;
                    time_100s <= time_100s + 1'b1;
                    if(time_100s == 4'b1010)
                    begin
                        time_max_flag <= 1'b1;
                    end
                    else
                    begin
                        time_max_flag <= 1'b0;
                    end
                end
                else
                begin
                    time_10s <= time_10s;
                    time_100s <= time_100s;
                end
            end
            else
            begin
                time_1s <= time_1s;
                time_10s <= time_10s;
            end
        end
        else
        begin
            time_1s <= time_1s;
            time_10s <= time_10s;
            time_100s <= time_100s;
        end
	end
	else
	begin
		counter <= counter - 1'b1;
	end
end


endmodule