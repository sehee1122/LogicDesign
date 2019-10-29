module tb7;

	reg		d		;
	reg		clk		;

	wire		q1		;
	wire		q2		;

	initial		clk = 1'b0	;
	always #(20)	clk = ~clk	;

// ----------
// instances
// ----------

	block		dut0(	.q	( q1	),
				.d	( d	),
				.clk	( clk	));

	nonblock	dut1(	.q	( q2	),
				.d	( d	),
				.clk	( clk	));

//----------
//stimulus
//----------

initial begin

	$display("==================================================");
	$display(" d q1 q2 ");
	$display("==================================================");
	#(0)	{d} = 1'b0;
	#(50)	{d} = 1'b0; #(50) $display(" %b\t%b\t%b\t%b\t", d, clk, q1, q2);
	#(50)	{d} = 1'b1; #(50) $display(" %b\t%b\t%b\t%b\t", d, clk, q1, q2);
	#(50)	{d} = 1'b0; #(50) $display(" %b\t%b\t%b\t%b\t", d, clk, q1, q2);
	#(50)	{d} = 1'b1; #(50) $display(" %b\t%b\t%b\t%b\t", d, clk, q1, q2);
	#(50)	{d} = 1'b0; #(50) $display(" %b\t%b\t%b\t%b\t", d, clk, q1, q2);
	#(50)	{d} = 1'b1; #(50) $display(" %b\t%b\t%b\t%b\t", d, clk, q1, q2);

	$finish	;
	end
endmodule
