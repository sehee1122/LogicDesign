module tb4	;
// ----------
// instances
// ----------


	reg	in0	;
	reg	in1	;
	reg	sel	;

	wire	out1	;
	wire	out2	;
	wire	out3	;

	mux2to1_cond	dut_1(	.out	( out1	),
				.in0	( in0	),
				.in1	( in1	),
				.sel	( sel	));

	mux2to1_if	dut_2(	.out	( out2	),
				.in0	( in0	),
				.in1	( in1	),
				.sel	( sel	));

	mux2to1_case	dut_3(	.out	( out3	),
				.in0	( in0	),
				.in1	( in1	),
				.sel	( sel	));

// ----------
// stimulus
// ----------

initial begin
	$display("Using Instances:	out");
	$display("Using Multi-bit:	out");
	$display("==================================================");
	$display(" sel in0 in1 out1 out2 out3 ");
	$display("==================================================");
	#(50)	{sel, in0, in1} = $random();	#(50)	$display(" %d\t%d\t%d\t%d\t%d\t%d\t ", sel, in0, in1, out1, out2, out3);
	#(50)	{sel, in0, in1} = $random();	#(50)	$display(" %d\t%d\t%d\t%d\t%d\t%d\t ", sel, in0, in1, out1, out2, out3);
	#(50)	{sel, in0, in1} = $random();	#(50)	$display(" %d\t%d\t%d\t%d\t%d\t%d\t ", sel, in0, in1, out1, out2, out3);
	#(50)	{sel, in0, in1} = $random();	#(50)	$display(" %d\t%d\t%d\t%d\t%d\t%d\t ", sel, in0, in1, out1, out2, out3);
	#(50)	{sel, in0, in1} = $random();	#(50)	$display(" %d\t%d\t%d\t%d\t%d\t%d\t ", sel, in0, in1, out1, out2, out3);
	#(50)	{sel, in0, in1} = $random();	#(50)	$display(" %d\t%d\t%d\t%d\t%d\t%d\t ", sel, in0, in1, out1, out2, out3);
	#(50)	{sel, in0, in1} = $random();	#(50)	$display(" %d\t%d\t%d\t%d\t%d\t%d\t ", sel, in0, in1, out1, out2, out3);
	#(50)	{sel, in0, in1} = $random();	#(50)	$display(" %d\t%d\t%d\t%d\t%d\t%d\t ", sel, in0, in1, out1, out2, out3);
	#(50)	{sel, in0, in1} = $random();	#(50)	$display(" %d\t%d\t%d\t%d\t%d\t%d\t ", sel, in0, in1, out1, out2, out3);
	#(50)	{sel, in0, in1} = $random();	#(50)	$display(" %d\t%d\t%d\t%d\t%d\t%d\t ", sel, in0, in1, out1, out2, out3);
	#(50)	$finish	;
	end

endmodule