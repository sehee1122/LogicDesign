module		tb_top_nco_cnt_disp	;

	parameter	tCK = 1000/50	;	// 50MHz Clock

	reg		clk		;
	reg		rst_n		;

	wire	[6:0]	seg	;
	wire		seg_dp	;
	wire	[5:0]	seg_enb	;

	initial			clk = 1'b0;
	always	#(tCK/2)	clk = ~clk;

// ----------
// instances
// ----------

led_disp	u_led_disp(
		.o_seg		( seg		),
		.o_seg_dp	( seg_dp	),
		.o_seg_enb	( seg_enb	),
		.i_six_digit_seg( six_digit_seg	),
		.i_six_dp	( 6'd0		),
		.clk		( clk		),
		.rst_n		( rst_n		));

initial begin
#(0*tCK)	rst_n = 1'b0;
#(1*tCK)	rst_n = 1'b1;
#(100000*tCK)	$finish;
end

endmodule
