module algoritm_booth
#(	parameter WIDTH = 4 )
(
	input enable,
	input clock,
	input [WIDTH - 1 : 0] mpd, //MultiPlicanD
	input [WIDTH - 1 : 0] mpr, //MultiPlieR
	output reg [ (2 * WIDTH) - 1 : 0] res,
	output reg [WIDTH - 1 : 0] cnt,
	output reg [2 * WIDTH  : 0] A,
	output reg [2 * WIDTH  : 0] S,
	output reg [2 * WIDTH  : 0] P
);

	parameter START = 2'b00;
	parameter RUN = 2'b01;
	parameter SHIFT = 2'b10;
	parameter RESULT = 2'b11;
	
	reg [1:0] state_current;
	reg [1:0] state_next;
	
	//reg [WIDTH - 1 : 0] cnt;
	//reg [2 * WIDTH  : 0] A;
	//reg [2 * WIDTH  : 0] S;
	//reg [2 * WIDTH  : 0] P;
	
	wire [WIDTH - 1 : 0] mpd_neg;
	
	always @ ( posedge clock ) begin
		if( !enable ) begin
			state_current <= START;
		end
		else begin
			state_current <= state_next;
		end
	end
	
	always @ ( * ) begin
		case( state_current )
			START: begin
				if (enable) begin
					state_next = RUN;
				end
				else begin
					state_next = START;
				end
				
			end
			
			RUN: begin
				state_next = SHIFT;
			end
			
			SHIFT: begin
				if( cnt ==  (WIDTH - 1) ) begin
					state_next = RESULT;
				end	
				else begin
					state_next = RUN;
				end
			end
			
			RESULT: begin
				state_next = START;
			end
			
		endcase
	end
	
	assign mpd_neg = -mpd;
	
	always @ ( posedge clock ) begin
		
		case( state_current )
		
			START: begin
				A <= { mpd, { (WIDTH + 1){1'b0} } };
				S <= { mpd_neg, { (WIDTH+1){1'b0} } };
				P <= { { (WIDTH){1'b0} }, mpr, 1'b0};
				cnt  <= 1'b0;
			end
			
			RUN: begin
				case(P[1:0])
					2'b01: begin
						P <= P + A;
					end
					
					2'b10: begin
						P <= P + S;	
					end
				endcase
			end
			
			SHIFT: begin
				P <= {P[2 * WIDTH], P[2 * WIDTH : 1]};
				cnt <= cnt + 1'b1;
			end
			
			RESULT: begin
				res <= P[(2 * WIDTH) : 1];
			end
			
		endcase
		
	end
		
endmodule
