module tb5	;
// ----------
// instances
// ----------

	reg		in0	;
	reg		in1	;
	reg		in2	;
	reg		in3	;
	reg	[1:0]	sel	;

	wire	out1	;
	wire	out2	;
	wire	out3	;

	mux4to1_cond	dut_1(	.out	( out1	),
				.in	( {in3, in2, in1, in0}	),
				.sel	( sel 	));

	mux4to1_if	dut_2(	.out	( out2	),
				.in0	( in0	),
				.in1	( in1	),
				.in2	( in2	),
				.in3	( in3	),
				.sel	( sel	));

	mux4to1_case	dut_3(	.out	( out3	),
				.in0	( in0	),
				.in1	( in1	),
				.in2	( in2	),
				.in3	( in3	),
				.sel	( sel	));

// ----------
// stimulus
// ----------
initial begin
	$display("Using Instances:	out");
	$display("Using Multi-bit:	out");
	$display("==================================================");
	$display(" sel in0 in1 in2 in3 out1 out2 out3 ");
	$display("==================================================");
	#(50)	{sel, in0, in1, in2, in3} = $random();	#(50)	$display(" %d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t ", sel, in0, in1, in2, in3, out1, out2, out3);
	#(50)	{sel, in0, in1, in2, in3} = $random();	#(50)	$display(" %d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t ", sel, in0, in1, in2, in3, out1, out2, out3);
	#(50)	{sel, in0, in1, in2, in3} = $random();	#(50)	$display(" %d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t ", sel, in0, in1, in2, in3, out1, out2, out3);
	#(50)	{sel, in0, in1, in2, in3} = $random();	#(50)	$display(" %d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t ", sel, in0, in1, in2, in3, out1, out2, out3);
	#(50)	{sel, in0, in1, in2, in3} = $random();	#(50)	$display(" %d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t ", sel, in0, in1, in2, in3, out1, out2, out3);
	#(50)	{sel, in0, in1, in2, in3} = $random();	#(50)	$display(" %d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t ", sel, in0, in1, in2, in3, out1, out2, out3);
	#(50)	{sel, in0, in1, in2, in3} = $random();	#(50)	$display(" %d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t ", sel, in0, in1, in2, in3, out1, out2, out3);
	#(50)	{sel, in0, in1, in2, in3} = $random();	#(50)	$display(" %d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t ", sel, in0, in1, in2, in3, out1, out2, out3);
	#(50)	{sel, in0, in1, in2, in3} = $random();	#(50)	$display(" %d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t ", sel, in0, in1, in2, in3, out1, out2, out3);
	#(50)	{sel, in0, in1, in2, in3} = $random();	#(50)	$display(" %d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t ", sel, in0, in1, in2, in3, out1, out2, out3);
	#(50)	$finish	;
	end
endmodule