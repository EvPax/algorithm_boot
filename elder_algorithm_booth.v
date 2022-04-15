module algoritm_booth
#(	parameter WIDTH = 4 )
(
	input enable,
	input clock,
	input [WIDTH - 1 : 0] mpd, //MultiPlicanD
	input [WIDTH - 1 : 0] mpr, //MultiPlieR
	output reg [ (2 * WIDTH) - 1 : 0] res
);
	
	reg [WIDTH - 1 : 0] cnt;
	reg [2 * WIDTH + 1 : 0] A;
	reg [2 * WIDTH + 1 : 0] S;
	reg [2 * WIDTH + 1 : 0] P;
	reg flag1;
	reg shift;
	
	always @ ( posedge clock ) begin
		
		if( 1'b1 == enable ) begin
			A <= {mpd[WIDTH - 1], mpd, { (WIDTH + 1){1'b0} } };
			S <= {mpd[WIDTH - 1], mpd, { WIDTH{1'b0} } };
			P <= { { (WIDTH + 1){1'b0} }, mpr, 1'b0};
			cnt  <= 1'b0;
			flag1 <= 1'b0;
			shift <= 1'b0;
		end
		
		if( 1'b0 == enable ) begin
			flag1 <= 1'b1;
		end
		
		if( 1'b0 == flag1 ) begin
		
			if(cnt < WIDTH) begin
			
				if( !shift ) begin
				
					case(P[1:0])
						default:
							begin
								P <= P >> 1;
								cnt <= cnt + 1'b1;
							end
							
						2'b01:
							begin
								P <= P + A;
								shift <= 1'b1;
							end
						
						2'b10:
							begin
								P <= P + S;
								shift <= 1'b1;
							end
					endcase
				end
				
				if( shift ) begin
					P <= P >> 1;
					cnt <= cnt + 1'b1;
					shift <= 1'b0;
				end
			end
			
			if( cnt >= WIDTH ) begin
				res <= P[(2 * WIDTH) : 1];
			end
		end
	end
		
endmodule
