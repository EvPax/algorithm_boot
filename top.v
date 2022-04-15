module top
(	
	input MAX_CLK1_50,
	input [ 8:0 ] SW,
	output [ 8:0 ] LED,
	output [ 7:0 ] HEX0,
	output [ 7:0 ] HEX1
);
	
	wire [ 7:0 ] res_tmp;
	
	assign LED = SW;
	
	algoritm_booth #(	.WIDTH (4) ) multiplication
	(
		.enable ( SW[0] ),
		.clock ( MAX_CLK1_50 ),
		.mpd ( SW[ 8:5 ] ), 
		.mpr ( SW[ 4:1 ] ),
		.res ( res_tmp )
	);
	
	seven_seg_digit result_h
(
    .dig ( res_tmp[ 7:4 ] ),
    .hex ( HEX1 )
);

	seven_seg_digit result_l
(
    .dig ( res_tmp[ 3:0 ] ),
    .hex ( HEX0 )
);
	

endmodule
