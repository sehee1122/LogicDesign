module block(	q,
		d,
		clk);

	output	q	;
	input	d	;
	input	clk	;

	reg	n1	;
	reg	q	;

	always @(posedge clk) begin
		n1 = d;		// blocking
		q  = n1;	// blocking
	end


endmodule

module nonblock(	q,
			d,
			clk);

	output	q	;
	input	d	;
	input	clk	;

	reg	n2	;
	reg	q	;

	always @(posedge clk) begin
		n2 <= d;	// nonblocking
		q  <= n2;	// nonblocking
	end

endmodule
