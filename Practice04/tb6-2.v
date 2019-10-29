module tb6_sequeltial;

//	wire		dec3to8_shift		;
//	wire		dec3to8_case		;

	reg	[2:0]	in		;
	reg		en		;

	wire	[7:0]	out1		;
	wire	[7:0]	out2		;

// ----------
// instances
// ----------

	dec3to8_shift	dut0(	.out	( out1		),
				.in	( in		),
				.en	( en		));

	dec3to8_case	dut1(	.out	( out2		),
				.in	( in		),
				.en	( en		));

//----------
//stimulus
//----------

initial begin

	$display("Using shift:	in, en");
	$display("Using case:	in, en");

	$display("==================================================");
	$display(" en in out1 out2 ");
	$display("==================================================");
	#(50)	{en, in} = 4'b0000; #(50) $display(" %b\t%b\t%b\t%b\t", en, in, out1, out2);
	#(50)	{en, in} = 4'b0001; #(50) $display(" %b\t%b\t%b\t%b\t", en, in, out1, out2);
	#(50)	{en, in} = 4'b0010; #(50) $display(" %b\t%b\t%b\t%b\t", en, in, out1, out2);
	#(50)	{en, in} = 4'b0011; #(50) $display(" %b\t%b\t%b\t%b\t", en, in, out1, out2);
	#(50)	{en, in} = 4'b0100; #(50) $display(" %b\t%b\t%b\t%b\t", en, in, out1, out2);
	#(50)	{en, in} = 4'b0101; #(50) $display(" %b\t%b\t%b\t%b\t", en, in, out1, out2);
	#(50)	{en, in} = 4'b0110; #(50) $display(" %b\t%b\t%b\t%b\t", en, in, out1, out2);
	#(50)	{en, in} = 4'b0111; #(50) $display(" %b\t%b\t%b\t%b\t", en, in, out1, out2);
	#(50)	{en, in} = 4'b1000; #(50) $display(" %b\t%b\t%b\t%b\t", en, in, out1, out2);
	#(50)	{en, in} = 4'b1001; #(50) $display(" %b\t%b\t%b\t%b\t", en, in, out1, out2);
	#(50)	{en, in} = 4'b1010; #(50) $display(" %b\t%b\t%b\t%b\t", en, in, out1, out2);
	#(50)	{en, in} = 4'b1011; #(50) $display(" %b\t%b\t%b\t%b\t", en, in, out1, out2);
	#(50)	{en, in} = 4'b1100; #(50) $display(" %b\t%b\t%b\t%b\t", en, in, out1, out2);
	#(50)	{en, in} = 4'b1101; #(50) $display(" %b\t%b\t%b\t%b\t", en, in, out1, out2);
	#(50)	{en, in} = 4'b1110; #(50) $display(" %b\t%b\t%b\t%b\t", en, in, out1, out2);
	#(50)	{en, in} = 4'b1111; #(50) $display(" %b\t%b\t%b\t%b\t", en, in, out1, out2);

	$finish	;
	end
endmodule