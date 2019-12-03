//	==================================================
//	Copyright (c) 2019 Sookmyung Women's University.
//	--------------------------------------------------
//	FILE 			: digital_clock.v
//	DEPARTMENT		: EE
//	AUTHOR			: WOONG CHOI
//	EMAIL			: woongchoi@sookmyung.ac.kr
//	--------------------------------------------------
//	RELEASE HISTORY
//	--------------------------------------------------
//	VERSION			DATE
//	0.0			2019-11-18
//	--------------------------------------------------
//	PURPOSE			: Digital Clock
//	==================================================

//	--------------------------------------------------
//	Numerical Controlled Oscillator
//	Hz of o_gen_clk = Clock Hz / num
//	--------------------------------------------------

// 609??	.i_nco_num	( 32'd500000	),
// modify nco_num to vibrate 60 times a second.


module	nco(	
		o_gen_clk,
		i_nco_num,
		clk,
		rst_n);

output		o_gen_clk	;	// 1Hz CLK

input	[31:0]	i_nco_num	;
input		clk		;	// 50Mhz CLK
input		rst_n		;

reg	[31:0]	cnt		;
reg		o_gen_clk	;

always @(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt		<= 32'd0;
		o_gen_clk	<= 1'd0	;
	end else begin
		if(cnt >= i_nco_num/2-1) begin
			cnt 	<= 32'd0;
			o_gen_clk	<= ~o_gen_clk;
		end else begin
			cnt <= cnt + 1'b1;
		end
	end
end

endmodule

//	--------------------------------------------------
//	Flexible Numerical Display Decoder
//	--------------------------------------------------
module	fnd_dec(
		o_seg,
		i_num);

output	[6:0]	o_seg		;	// {o_seg_a, o_seg_b, ... , o_seg_g}

input	[3:0]	i_num		;
reg	[6:0]	o_seg		;
//making
always @(i_num) begin 
 	case(i_num) 
 		4'd0:	o_seg = 7'b111_1110; 
 		4'd1:	o_seg = 7'b011_0000; 
 		4'd2:	o_seg = 7'b110_1101; 
 		4'd3:	o_seg = 7'b111_1001; 
 		4'd4:	o_seg = 7'b011_0011; 
 		4'd5:	o_seg = 7'b101_1011; 
 		4'd6:	o_seg = 7'b101_1111; 
 		4'd7:	o_seg = 7'b111_0000; 
 		4'd8:	o_seg = 7'b111_1111; 
 		4'd9:	o_seg = 7'b111_0011; 
		default:o_seg = 7'b000_0000; 
	endcase 
end


endmodule

//	--------------------------------------------------
//	0~59 --> 2 Separated Segments
//	--------------------------------------------------
module	double_fig_sep(
		o_left,
		o_right,
		i_double_fig);

output	[3:0]	o_left		;
output	[3:0]	o_right		;

input	[5:0]	i_double_fig	;

assign		o_left	= i_double_fig / 10	;
assign		o_right	= i_double_fig % 10	;

endmodule

//	--------------------------------------------------
//	0~59 --> 2 Separated Segments
//	--------------------------------------------------
module	led_disp(
		o_seg,
		o_seg_dp,
		o_seg_enb,
		i_six_digit_seg,
		clk,
		i_mode,
		i_position,
		rst_n,
		i_alarm_en );    //add i_mode & i_position --> to make new i_six_dp
  
output	[5:0]	o_seg_enb		;
output		     o_seg_dp		 ;
output	[6:0]	o_seg		    ;
	
input	[41:0]	i_six_digit_seg		;
input	[1:0]	 i_position		     ;
input	[1:0]	 i_mode			        ;
input		clk			                 ;
input		rst_n			               ;
input  i_alarm_en             ;

wire		gen_clk			;	
nco		u_nco(
		.o_gen_clk	( gen_clk	),
		.i_nco_num	( 32'd5000	),
		.clk		( clk		),
		.rst_n		( rst_n		));


reg	[3:0]	cnt_common_node		;

always @(posedge gen_clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt_common_node <= 4'd0;
	end else begin
		if(cnt_common_node >= 4'd5) begin
			cnt_common_node <= 4'd0;
		end else begin
			cnt_common_node <= cnt_common_node + 1'b1;
		end
	end
end

wire		clk_1hz			;
nco		u1_nco(
		.o_gen_clk	( clk_1hz	),
		.i_nco_num	( 32'd50000000	),
		.clk		( clk		),
		.rst_n		( rst_n		));

wire clk_2  ;
nco		u2_nco(
		.o_gen_clk	( clk_2	),
		.i_nco_num	( 32'd5000000	),
		.clk		( clk		),
		.rst_n		( rst_n		));		
		
reg	[5:0]	o_seg_enb		;
reg count1;
reg count2;
reg count3;


		
always @(posedge clk_2 or negedge rst_n) begin
  if(rst_n == 1'b0) begin
    count1 = 1'b0;
    count2 = 1'b0;
    count3 = 1'b0;
  end else begin
    count1 <= count1 + 1'b1;
    count2 <= count2 + 1'b1;
    count3 <= count3 + 1'b1;
  end
end

always @(cnt_common_node,i_mode,i_position,count1,count2,count3) begin
  if((i_mode == 2'b01) || (i_mode == 2'b10))begin
    case ( i_position  )
      2'b00 : begin
        if( count1 == 1'b0 ) begin
            case (cnt_common_node)
		          4'd0:	o_seg_enb = 6'b111111;
		          4'd1:	o_seg_enb = 6'b111111;
		          4'd2:	o_seg_enb = 6'b111011;
		          4'd3:	o_seg_enb = 6'b110111;
		          4'd4:	o_seg_enb = 6'b101111;
		          4'd5:	o_seg_enb = 6'b011111;
		          default:o_seg_enb = 6'b111111;	
	           endcase
	        end else begin
	           case (cnt_common_node)
		          4'd0:	o_seg_enb = 6'b111110;
		          4'd1:	o_seg_enb = 6'b111101;
		          4'd2:	o_seg_enb = 6'b111011;
		          4'd3:	o_seg_enb = 6'b110111;
		          4'd4:	o_seg_enb = 6'b101111;
		          4'd5:	o_seg_enb = 6'b011111;
		          default:o_seg_enb = 6'b111111;	
	          endcase
	       end
	   end
	   2'b01 : begin
	       if( count2 == 1'b0) begin
              case (cnt_common_node)
		          4'd0:	o_seg_enb = 6'b111110;
		          4'd1:	o_seg_enb = 6'b111101;
		          4'd2:	o_seg_enb = 6'b111111;
		          4'd3:	o_seg_enb = 6'b111111;
		          4'd4:	o_seg_enb = 6'b101111;
		          4'd5:	o_seg_enb = 6'b011111;
		          default:o_seg_enb = 6'b111111;	
	            endcase
	       end else begin
	          case (cnt_common_node)
		          4'd0:	o_seg_enb = 6'b111110;
		          4'd1:	o_seg_enb = 6'b111101;
		          4'd2:	o_seg_enb = 6'b111011;
		          4'd3:	o_seg_enb = 6'b110111;
		          4'd4:	o_seg_enb = 6'b101111;
		          4'd5:	o_seg_enb = 6'b011111;
		          default:o_seg_enb = 6'b111111;	
	            endcase
	      end
	  end
	  2'b10 : begin
	      if(count3 == 1'b0) begin
              case (cnt_common_node)
		          4'd0:	o_seg_enb = 6'b111110;
		          4'd1:	o_seg_enb = 6'b111101;
		          4'd2:	o_seg_enb = 6'b111011;
		          4'd3:	o_seg_enb = 6'b110111;
		          4'd4:	o_seg_enb = 6'b111111;
		          4'd5:	o_seg_enb = 6'b111111;
		          default:o_seg_enb = 6'b111111;	
	            endcase
	        end else begin
	          case (cnt_common_node)
		          4'd0:	o_seg_enb = 6'b111110;
		          4'd1:	o_seg_enb = 6'b111101;
		          4'd2:	o_seg_enb = 6'b111011;
		          4'd3:	o_seg_enb = 6'b110111;
		          4'd4:	o_seg_enb = 6'b101111;
		          4'd5:	o_seg_enb = 6'b011111;
		          default:o_seg_enb = 6'b111111;	
	            endcase
	        end
	  end 
	 endcase
	end else begin   
	   case (cnt_common_node)
		    4'd0:	o_seg_enb = 6'b111110;
		    4'd1:	o_seg_enb = 6'b111101;
		    4'd2:	o_seg_enb = 6'b111011;
		    4'd3:	o_seg_enb = 6'b110111;
		    4'd4:	o_seg_enb = 6'b101111;
		    4'd5:	o_seg_enb = 6'b011111;
		    default:o_seg_enb = 6'b111111;	
	  endcase
 end
end


reg 	[5:0]	i_six_dp		;	  
reg			     o_seg_dp		; //add


//ADD CONDITION : decide i_six_dp when i_mode is 2'b01 and 2'b10 
     
reg  [1:0] find_alarm = 2'b00;
reg  [1:0] find_alarm_x = 2'b00;


always @(posedge clk) begin
  find_alarm_x = find_alarm ;
end

		
always @(posedge clk_1hz or negedge rst_n) begin
  if(rst_n == 1'b0) begin
    find_alarm = 2'b00;
  end else begin
    find_alarm = {find_alarm_x[0],i_alarm_en};
  end
end
always @(i_mode,i_position, find_alarm) begin
	    if ( i_mode == 2'b01 ) begin
	       case (i_position)
		      2'b00:	  i_six_dp = 6'b000001;
		      2'b01:	  i_six_dp = 6'b000100;
		      2'b10:	  i_six_dp = 6'b010000;
		      default: i_six_dp = 6'b000000;
		     endcase
	     end else begin
	         if ( i_mode == 2'b10 ) begin
	           case (i_position)
		          2'b00:	  i_six_dp = 6'b000010;
		          2'b01:	  i_six_dp = 6'b001000;
		          2'b10:	  i_six_dp = 6'b100000;
		          default: i_six_dp = 6'b000000;
		         endcase
		       end else begin
		            i_six_dp = 6'b000000;
		       end
		     //i_mode is not 2'b10 and 2'b01, i_six_dp have to be 6'b000000
    if( (find_alarm == 2'b01)||(find_alarm == 2'b10) ) begin
           i_six_dp = 6'b111111;        
      end 
	end 
	  
end


 //if i_alarm_en ==1 and find_alarm == 0, i_six_dp = 111111 and find_alarm is increasement.... so, find_alarm == 0 > find_alarm ==>1
		      // if i_alarm_en ==1 but find_alarm ==1, i_six_dp is not changed. 


always @(cnt_common_node) begin
		case (cnt_common_node)
			4'd0:	o_seg_dp = i_six_dp[0];
			4'd1:	o_seg_dp = i_six_dp[1];
			4'd2:	o_seg_dp = i_six_dp[2];
			4'd3:	o_seg_dp = i_six_dp[3];
			4'd4:	o_seg_dp = i_six_dp[4];
			4'd5:	o_seg_dp = i_six_dp[5];
			default:o_seg_dp = 1'b0;
		endcase
end

reg	[6:0]	o_seg			            ;

always @(cnt_common_node) begin
	case (cnt_common_node)
		4'd0:	o_seg = i_six_digit_seg[6:0];
		4'd1:	o_seg = i_six_digit_seg[13:7];
		4'd2:	o_seg = i_six_digit_seg[20:14];
		4'd3:	o_seg = i_six_digit_seg[27:21];
		4'd4:	o_seg = i_six_digit_seg[34:28];
		4'd5:	o_seg = i_six_digit_seg[41:35];
		default:o_seg = 7'b111_1110; // 0 display
	endcase
end

endmodule


//	--------------------------------------------------
//	HMS(Hour:Min:Sec) Counter
//	--------------------------------------------------
module	hms_cnt(
		o_hms_cnt,
		o_max_hit,
		i_max_cnt,
		clk,
		rst_n);

output	[5:0]	o_hms_cnt		;
output		     o_max_hit		;

input	[5:0]	i_max_cnt		 ;
input		     clk			      ;
input		     rst_n			    ;

reg	[5:0]	o_hms_cnt		   ;
reg		     o_max_hit		;



always @(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_hms_cnt <= 6'd0;
		o_max_hit <= 1'b0;
	end else begin
		if(o_hms_cnt >= i_max_cnt) begin
			o_hms_cnt <= 6'd0;
			o_max_hit <= 1'b1;
		end else begin
			o_hms_cnt <= o_hms_cnt + 1'b1;
			o_max_hit <= 1'b0;
		end
	end
end

endmodule

module  debounce(
		o_sw,
		i_sw,
		clk);
output		o_sw			;

input		i_sw			;
input		clk			;

reg		dly1_sw			;
always @(posedge clk) begin
	dly1_sw <= i_sw;
end

reg		dly2_sw			;
always @(posedge clk) begin
	dly2_sw <= dly1_sw;
end

assign		o_sw = dly1_sw | ~dly2_sw;

endmodule

//	--------------------------------------------------
//	Clock Controller
//	--------------------------------------------------
module	controller(
		o_mode,
		o_position,
		o_world_position,
		o_timer_position,				// add
		o_alarm_en,
		o_secc_clk,
		o_sec_clk,
		o_min_clk,
		o_hou_clk,
		o_alarm_sec_clk,
		o_alarm_min_clk,
		o_alarm_hou_clk,
		o_timer_sec_clk,
		o_timer_min_clk,
		o_timer_hou_clk,
		i_max_hit_secc,
		i_max_hit_sec,
		i_max_hit_min,
		i_max_hit_hou,
		i_sw0,
		i_sw1,
		i_sw2,
		i_sw3,
		i_sw4,
		i_sw5,							// add
		clk,
		rst_n);


output	[1:0]	o_mode			;
output	[1:0]	o_position		;
output [1:0] o_world_position ;
output	[1:0]	o_timer_position	;		// add
output		o_alarm_en		;
output		o_secc_clk		;
output		o_sec_clk		;
output		o_min_clk		;
output		o_hou_clk		;
output		o_alarm_sec_clk		;
output		o_alarm_min_clk		;
output		o_alarm_hou_clk		;
output		o_timer_sec_clk		;
output		o_timer_min_clk		;
output		o_timer_hou_clk		;

input		i_max_hit_secc		;
input		i_max_hit_sec		;
input		i_max_hit_min		;
input		i_max_hit_hou		;

input		i_sw0			;
input		i_sw1			;
input		i_sw2			;
input		i_sw3			;
input		i_sw4			;
input		i_sw5			;						// add

input		clk			;
input		rst_n			;

parameter	MODE_CLOCK	= 3'b000	;
parameter	MODE_SETUP	= 3'b001	;
parameter	MODE_ALARM	= 3'b010	;
parameter	MODE_WORLD	= 3'b011 ;
parameter	MODE_TIMER	= 3'b100	;
parameter	POS_SEC		  = 2'b00	;
parameter	POS_MIN		  = 2'b01	;
parameter POS_HOU  	 = 2'b10 ;
parameter WOR_USA    = 2'b00 ; //TIME OF USA
parameter WOR_ENG    = 2'b01 ; //TIME OF ENGLAND
parameter WOR_AUS    = 2'b10 ; //TIME OF AUSTRALIA
parameter	SECC_SW	= 2'b00	;
parameter	SEC_SW	= 2'b01	;
parameter	MIN_SW	= 2'b10	;

wire		clk_100hz		;
nco		u0_nco(
		.o_gen_clk	( clk_100hz	),
		.i_nco_num	( 32'd500000	),
		.clk		( clk		),
		.rst_n		( rst_n		));

wire		sw0			;
debounce	u0_debounce(
		.o_sw		( sw0		),
		.i_sw		( i_sw0		),
		.clk		( clk_100hz	));

wire		sw1			;
debounce	u1_debounce(
		.o_sw		( sw1		),
		.i_sw		( i_sw1		),
		.clk		( clk_100hz	));

wire		sw2			;
debounce	u2_debounce(
		.o_sw		( sw2		),
		.i_sw		( i_sw2		),
		.clk		( clk_100hz	));

wire		sw3			;
debounce	u3_debounce(
		.o_sw		( sw3		),
		.i_sw		( i_sw3		),
		.clk		( clk_100hz	));

wire		sw4			;
debounce	u4_debounce(
		.o_sw		( sw4		),
		.i_sw		( i_sw4		),
		.clk		( clk_100hz	));
		
wire		sw5			;
debounce	u5_debounce(
		.o_sw		( sw5		),
		.i_sw		( i_sw5		),
		.clk		( clk_100hz	));

reg	[1:0]	o_mode			;
always @(posedge sw0 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_mode <= MODE_CLOCK;
	end else begin
		if(o_mode >= MODE_TIMER) begin
			o_mode <= MODE_CLOCK;
		end else begin
			o_mode <= o_mode + 1'b1;
		end
	end
end

reg	[1:0]	o_position		;
always @(posedge sw1 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_position <= POS_SEC;
	end else begin
		if(o_position >= POS_HOU) begin
			o_position <= POS_SEC;
		end else begin
			o_position <= o_position + 1'b1;
		end
	end
end

reg		o_alarm_en		;
always @(posedge sw3 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_alarm_en <= 1'b0;
	end else begin
		o_alarm_en <= o_alarm_en + 1'b1;
	end
end

reg	[1:0]	o_world_position		; //ADD TIME OF OTHER COUNTRIES WITH NEW BUTTON sw4 

always @(posedge sw4 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_world_position <= WOR_USA;
	end else begin
		if(o_world_position >= WOR_AUS) begin
			o_world_position <= WOR_USA;
		end else begin
			o_world_position <= o_world_position + 1'b1;
		end
	end
end


reg	[1:0]	o_timer_position		; //ADD TIMER WITH NEW BUTTON sw5 

always @(posedge sw5 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_timer_position <= SECC_SW;
	end else begin
		if(o_timer_position >= MIN_SW) begin
			o_timer_position <= SECC_SW;
		end else begin
			o_timer_position <= o_timer_position + 1'b1;
		end
	end
end

wire		clk_1hz			;
nco		u1_nco(
		.o_gen_clk	( clk_1hz	),
		.i_nco_num	( 32'd50000000	),
		.clk		( clk		),
		.rst_n		( rst_n		));
		
wire		clk_60hz			;
nco		u2_nco(
		.o_gen_clk	( clk_60hz	),
		.i_nco_num	( 32'd500000	),	// modify nco_num to vibrate 60 times a second.
		.clk		( clk		),
		.rst_n		( rst_n		));

reg		o_secc_clk		;
reg		o_sec_clk		;
reg		o_min_clk		;
reg  o_hou_clk  		;
reg		o_alarm_sec_clk		;
reg		o_alarm_min_clk		;
reg  o_alarm_hou_clk 	;
always @(*) begin
	case(o_mode)
		MODE_CLOCK : begin
			o_sec_clk = clk_1hz;
			o_min_clk = i_max_hit_sec;
			o_hou_clk = i_max_hit_min;
			o_alarm_sec_clk = 1'b0;
			o_alarm_min_clk = 1'b0;
			o_alarm_hou_clk = 1'b0;
		end
		MODE_SETUP : begin
			case(o_position)
				POS_SEC : begin
					o_sec_clk = ~sw2;
					o_min_clk = 1'b0;
					o_hou_clk = 1'b0;
					o_alarm_sec_clk = 1'b0;
					o_alarm_min_clk = 1'b0;
					o_alarm_hou_clk = 1'b0;
				end
				POS_MIN : begin
					o_sec_clk = 1'b0;
					o_min_clk = ~sw2;
					o_hou_clk = 1'b0;
					o_alarm_sec_clk = 1'b0;
					o_alarm_min_clk = 1'b0;
					o_alarm_hou_clk = 1'b0;
				end
				POS_HOU : begin
				  o_sec_clk = 1'b0;
					o_min_clk = 1'b0;
					o_hou_clk = ~sw2;
					o_alarm_sec_clk = 1'b0;
					o_alarm_min_clk = 1'b0;
					o_alarm_hou_clk = 1'b0;
				end
			endcase
		end
		MODE_ALARM : begin
			case(o_position)
				POS_SEC : begin
					o_sec_clk = clk_1hz;
					o_min_clk = i_max_hit_sec;
					o_hou_clk = i_max_hit_min;
					o_alarm_sec_clk = ~sw2;
					o_alarm_min_clk = 1'b0;
					o_alarm_hou_clk = 1'b0;
				end
				POS_MIN : begin
					o_sec_clk = clk_1hz;
					o_min_clk = i_max_hit_sec;
					o_hou_clk = i_max_hit_min;
					o_alarm_sec_clk = 1'b0;
					o_alarm_min_clk = ~sw2;
					o_alarm_hou_clk = 1'b0;
				end
				POS_HOU : begin
				  o_sec_clk = clk_1hz;
					o_min_clk = i_max_hit_sec;
					o_hou_clk = i_max_hit_min;
					o_alarm_sec_clk = 1'b0;
					o_alarm_min_clk = 1'b0;
					o_alarm_hou_clk = ~sw2;
				end
			endcase
		end
		MODE_WORLD : begin
		  o_sec_clk = clk_1hz;
			o_min_clk = i_max_hit_sec;
			o_hou_clk = i_max_hit_min;
			o_alarm_sec_clk = 1'b0;
			o_alarm_min_clk = 1'b0;
			o_alarm_hou_clk = 1'b0;
		end  
		default: begin
			o_sec_clk = 1'b0;
			o_min_clk = 1'b0;
			o_hou_clk = 1'b0;
			o_alarm_sec_clk = 1'b0;
			o_alarm_min_clk = 1'b0;
			o_alarm_hou_clk = 1'b0;
		end
		MODE_TIMER : begin
			case(o_position)
				SECC_SW : begin
					o_secc_clk = clk_60hz;			//???? 60hz
					o_sec_clk = i_max_hit_secc;
					o_min_clk = i_max_hit_sec;
					o_alarm_sec_clk = 1'b0;
					o_alarm_min_clk = 1'b0;
					o_alarm_hou_clk = 1'b0;
				end
				SEC_SW : begin
					o_secc_clk = clk_60hz;			//???? 60hz
					o_sec_clk = i_max_hit_secc;
					o_min_clk = i_max_hit_sec;
					o_alarm_sec_clk = 1'b0;
					o_alarm_min_clk = 1'b0;
					o_alarm_hou_clk = 1'b0;
				end
				MIN_SW : begin
					o_secc_clk = clk_60hz;			//???? 60hz
					o_sec_clk = i_max_hit_secc;
					o_min_clk = i_max_hit_sec;
					o_alarm_sec_clk = 1'b0;
					o_alarm_min_clk = 1'b0;
					o_alarm_hou_clk = 1'b0;
				end
			endcase
		end
	endcase
end

endmodule

//	--------------------------------------------------
//	HMS(Hour:Min:Sec) Counter
//	--------------------------------------------------
module	houminsec(	
		o_secc,
		o_sec,
		o_min,
		o_hou,
		o_max_hit_secc,
		o_max_hit_sec,
		o_max_hit_min,
		o_max_hit_hou,
		o_alarm,
		i_mode,
		i_position,
		i_world_position,
		i_timer_position,			// add
		i_secc_clk,					// add
		i_sec_clk,
		i_min_clk,
		i_hou_clk,
		i_alarm_sec_clk,
		i_alarm_min_clk,
		i_alarm_hou_clk,
		i_timer_secc_clk,			// add x3
		i_timer_sec_clk,
		i_timer_min_clk,
		i_alarm_en,
		clk,
		rst_n);

output	[5:0]	o_secc	;
output	[5:0]	o_sec		;
output	[5:0]	o_min		;
output [5:0]	o_hou  		;
output		o_max_hit_secc	;
output		o_max_hit_sec	;
output		o_max_hit_min	;
output  	o_max_hit_hou 	;
output		o_alarm		;

input	[1:0]i_mode		;
input	[1:0]i_position	;
input [1:0]i_world_position ;
input [1:0]i_timer_position ;
input				i_secc_clk	;
input			   i_sec_clk	;
input			   i_min_clk	;
input 	    i_hou_clk 	;
input			   i_alarm_sec_clk	;
input			   i_alarm_min_clk	;
input  	   i_alarm_hou_clk ;
input			   i_timer_secc_clk	;
input			   i_timer_sec_clk	;
input				i_timer_min_clk ;
input			   i_alarm_en	;

input		clk		  ;
input		rst_n		;


parameter	MODE_CLOCK	= 3'b000	;
parameter	MODE_SETUP	= 3'b001	;
parameter	MODE_ALARM	= 3'b010	;
parameter	MODE_WORLD	= 3'b011 ;
parameter	MODE_TIMER	= 3'b100	;
//parameter	POS_SECC		= 2'b11	;
parameter	POS_SEC		  = 2'b00	;
parameter	POS_MIN		  = 2'b01	;
parameter POS_HOU  	 = 2'b10 ;
parameter WOR_USA    = 2'b00 ;
parameter WOR_ENG    = 2'b01 ;
parameter WOR_AUS    = 2'b10 ;
parameter	SECC_SW	= 2'b00	;
parameter	SEC_SW	= 2'b01	;
parameter	MIN_SW	= 2'b10	;


//	MODE_CLOCK
wire	[5:0]	sec		;
wire		max_hit_sec	;
hms_cnt		u_hms_cnt_sec(
		.o_hms_cnt	( sec			),
		.o_max_hit	( o_max_hit_sec		),
		.i_max_cnt	( 6'd59			),
		.clk		( i_sec_clk		),
		.rst_n		( rst_n			));

wire	[5:0]	min		;
wire		max_hit_min	;
hms_cnt		u_hms_cnt_min(
		.o_hms_cnt	( min			),
		.o_max_hit	( o_max_hit_min		),
		.i_max_cnt	( 6'd59			),
		.clk		( i_min_clk		),
		.rst_n		( rst_n			));
		
wire 	[5:0] 	hou  		;
wire  		max_hit_hou 	;
hms_cnt		u_hms_cnt_hou(
		.o_hms_cnt	( hou			),
		.o_max_hit	( o_max_hit_hou		),
		.i_max_cnt	( 6'd23			),
		.clk		( i_hou_clk		),
		.rst_n		( rst_n			));
		
//	MODE_ALARM
wire	[5:0]	alarm_sec	;
hms_cnt		u_hms_cnt_alarm_sec(
		.o_hms_cnt	( alarm_sec		),
		.o_max_hit	( 			),
		.i_max_cnt	( 6'd59			),
		.clk		( i_alarm_sec_clk	),
		.rst_n		( rst_n			));

wire	[5:0]	alarm_min	;
hms_cnt		u_hms_cnt_alarm_min(
		.o_hms_cnt	( alarm_min		),
		.o_max_hit	( 			),
		.i_max_cnt	( 6'd59			),
		.clk		( i_alarm_min_clk	),
		.rst_n		( rst_n			));

wire	[5:0]	alarm_hou	;
hms_cnt		u_hms_cnt_alarm_hou(
		.o_hms_cnt	( alarm_hou		),
		.o_max_hit	( 			),
		.i_max_cnt	( 6'd23			),
		.clk		( i_alarm_hou_clk	),
		.rst_n		( rst_n			));
		
//	MODE_TIMER

// The part of the watch that increases its secc part
wire	[5:0]	secc		;
wire		max_hit_secc	;
hms_cnt		u_hms_cnt_secc(
		.o_hms_cnt	( secc			),
		.o_max_hit	( o_max_hit_secc		),
		.i_max_cnt	( 6'd59			),
		.clk		( i_secc_clk		),
		.rst_n		( rst_n			));

wire	[5:0]	timer_secc	;
hms_cnt		u_hms_cnt_timer_secc(
		.o_hms_cnt	( timer_secc		),
		.o_max_hit	( 			),
		.i_max_cnt	( 6'd59			),
		.clk		( i_timer_secc_clk	),
		.rst_n		( rst_n			));

wire	[5:0]	timer_sec	;
hms_cnt		u_hms_cnt_timer_sec(
		.o_hms_cnt	( timer_sec	),
		.o_max_hit	( 			),
		.i_max_cnt	( 6'd59			),
		.clk		( i_timer_sec_clk	),
		.rst_n		( rst_n			));

wire	[5:0]	timer_min	;
hms_cnt		u_hms_cnt_timer_min(
		.o_hms_cnt	( timer_min		),
		.o_max_hit	( 			),
		.i_max_cnt	( 6'd59			),
		.clk		( i_timer_min_clk	),
		.rst_n		( rst_n			));


reg	[5:0]	o_secc	;
reg	[5:0]	o_sec		;
reg	[5:0]	o_min		;
reg 	[5:0] o_hou 		;

always @ (*) begin
	case(i_mode)
		MODE_CLOCK: begin
			o_sec	= sec;
			o_min	= min;
			o_hou = hou;
		end
		MODE_SETUP:	begin
			o_sec	= sec;
			o_min	= min;
			o_hou = hou;
		end
		MODE_ALARM:	begin
			o_sec	= alarm_sec;
			o_min	= alarm_min;
			o_hou = alarm_hou;
		end
		MODE_WORLD: begin //MODE OF TIME OF OTHER COUNTRIES
		    case(i_world_position)
		      WOR_USA : begin //TIME OF USA --> TIME DIFFERENCE OF 14 HOUR
		        o_sec	= sec;
			      o_min	= min;
			      o_hou = hou + 6'd14 ;
			    end
			    WOR_ENG : begin //TIME OF ENGLAND --> TIME DIFFERENCE OF 9 HOUR
			      o_sec	= sec;
			      o_min	= min;
			      o_hou = hou + 6'd09 ;
			    end
			    WOR_AUS : begin //TIME OF AUSTRALIA --> TIME DIFFERENCE OF 2 HOUR
			      o_sec	= sec;
			      o_min	= min;
			      o_hou = hou + 6'd02 ;
			    end
			  endcase
		end
		MODE_TIMER: begin
			o_secc	= secc;
			o_sec		= sec;
			o_min		= min;
		end
	endcase
end

reg		o_alarm		;
always @ (posedge clk or negedge rst_n) begin
	if ((rst_n == 1'b0)) begin
		o_alarm <= 1'b0;
	    end else begin
		    if( (sec == alarm_sec) && (min == alarm_min) && (hou == alarm_hou)) begin
		  	   o_alarm <= 1'b1 & i_alarm_en;
		    end else begin
			     o_alarm <= o_alarm & i_alarm_en;
			   end
	end
end

endmodule

module	buzz(
		o_buzz,
		i_buzz_en,
		clk,
		rst_n);

output		o_buzz		;

input		i_buzz_en	;
input		clk		     ;
input		rst_n		   ;

parameter	C = 191113	;
parameter	D = 170262	;
parameter	E = 151686	;
parameter	F = 143173	;
parameter	G = 63776	;
parameter	A = 56818	;
parameter	B = 50619	;

wire		clk_beat		;
nco	u_nco_bit(	
		.o_gen_clk	( clk_beat	),
		.i_nco_num	( 25000000	),
		.clk		( clk		),
		.rst_n		( rst_n		));

reg	[4:0]	cnt		;
always @ (posedge clk_beat or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt <= 5'd0;
	end else begin
		if(cnt >= 5'd24) begin
			cnt <= 5'd0;
		end else begin
			cnt <= cnt + 1'd1;
		end
	end
end

reg	[31:0]	nco_num		;
always @ (*) begin
	case(cnt)
		5'd00: nco_num = E	;
		5'd01: nco_num = D	;
		5'd02: nco_num = C	;
		5'd03: nco_num = D	;
		5'd04: nco_num = E	;
		5'd05: nco_num = E	;
		5'd06: nco_num = E	;
		5'd07: nco_num = D	;
		5'd08: nco_num = D	;
		5'd09: nco_num = D	;
		5'd10: nco_num = E	;
		5'd11: nco_num = E	;
		5'd12: nco_num = E	;
		5'd13: nco_num = E	;
		5'd14: nco_num = D	;
		5'd15: nco_num = C	;
		5'd16: nco_num = D	;
		5'd17: nco_num = E	;
		5'd18: nco_num = E	;
		5'd19: nco_num = E	;
		5'd20: nco_num = D	;
		5'd21: nco_num = D	;
		5'd22: nco_num = E	;
		5'd23: nco_num = D	;
		5'd24: nco_num = C	;
	endcase
end

wire		buzz		;
nco	u_nco_buzz(	
		.o_gen_clk	( buzz		),
		.i_nco_num	( nco_num	),
		.clk		( clk		),
		.rst_n		( rst_n		));

assign		o_buzz = buzz & i_buzz_en;

endmodule



//	--------------------------------------------------
//	Stopwatch
//	--------------------------------------------------


module stopwatch(
		clk,
		i_sw1,
		i_sw5,
		o_secc_sw,
		o_sec_sw,
		o_min_sw	);
		
input					clk		;
input		[1:0]		i_sw5	;
input		[1:0]		i_sw1	;

output	[3:0]		o_secc_sw;
output	[5:0]		o_sec_sw	;
output	[5:0]		o_min_sw	;

reg		[6:0]		o_secc_sw;
reg		[5:0]		o_sec_sw	;
reg		[5:0]		o_min_sw	;
reg		[3:0]		count		;
reg		[6:0]		v_secc	;
reg		[5:0]		v_sec		;
reg		[5:0]		v_min		;

initial begin
	count		= 4'b0000;
	v_secc	= 7'b0000000;
	v_sec		= 6'b000000;
	v_min		= 6'b000000;
end

always @(posedge clk) begin
	if( i_sw5 == 2'b01 && i_sw1 == 2'b01 ) begin
		count = count + 1;
	end else begin
		if( count == 4'b1010 ) begin
			v_secc = v_secc + 1;
			count = 4'b0000;
			end else begin
			if( v_secc == 7'b1100100 ) begin
				v_sec = v_sec + 1;
				v_secc = 7'b0000000;
			end else begin
				if( v_sec == 6'b111100 ) begin
					v_min = v_min + 1;
					v_sec = 6'b000000;
				end else begin
					if( v_min == 6'b111100 ) begin
						v_min = 6'b000000;
					end else begin
						if( i_sw5 == 2'b01 && i_sw1 == 2'b00 ) begin
							count = 4'b0000;
							v_secc = 7'b0000000;
							v_sec = 6'b000000;
							v_min = 6'b000000;
						end
					end
				end
			end
		end	
		o_secc_sw = v_secc;
		o_sec_sw = v_sec;
		o_min_sw = v_min;
	end
end

endmodule		


/*
module stopwatch(
    i_clock,
    i_reset,
    i_start,
    a, b, c, d, e, f, g,
	 dp,
    an			);
 
input i_clock	;
input i_reset	;
input i_start	;

output	a	;
output	b	;
output	c	;
output	d	;
output	e	;
output	f	;
output	g	;
output	dp	;
output [3:0] an 	;
 
reg [3:0] reg_d0, reg_d1, reg_d2, reg_d3; //registers that will hold the individual counts
reg [22:0] count; //23 bits needed to count up to 5M bits

wire click;
 
//the mod 5M clock to generate a tick ever 0.1 second
always @ (posedge i_clock or posedge i_reset)	begin
	case (i_sw2)
		i_reset: begin
			count <= 0;
			if (count == 5000000) begin //if it reaches the desired max value reset it
				count <= 0;
			end
		end
		i_start: begin		//only start if the input is set high
			count <= count + 1;
		end
	endcase
end

assign click = ((count == 5000000) ? 1'b1 : 1'b0); //click to be assigned high every 0.1 second

always @ (posedge i_clock or posedge i_reset) begin

 case (i_sw2)
	i_reset: begin
		reg_d0 <= 0;
		reg_d1 <= 0;
		reg_d2 <= 0;
		reg_d3 <= 0;
	end
 	i_click: begin //increment at every click
		if(reg_d0 == 9) begin //xxx9 - the 0.1 second digit, if_1
			reg_d0 <= 0;
			
		end else begin
			if (reg_d1 == 9) begin //xx99, if_2
				reg_d1 <= 0;
				
			end else begin
				if (reg_d2 == 5) begin //x599 - the two digit seconds digits, if_3
					reg_d2 <= 0;
					
				end else begin
					if(reg_d3 == 9) begin //9599 - The minute digit
						reg_d3 <= 0;
						
					end else begin
						reg_d3 <= reg_d3 + 1;
						reg_d2 <= reg_d2 + 1;
						reg_d1 <= reg_d1 + 1;
						reg_d0 <= reg_d0 + 1;
					end
				end
			end
		end
	endcase
end
*/
/*		
     else //else_3
      reg_d2 <= reg_d2 + 1;
    end
     
    else //else_2
     reg_d1 <= reg_d1 + 1;
   end
    
   else //else_1
    reg_d0 <= reg_d0 + 1;
  end
end
*/
/*
//The Circuit for Multiplexing - Look at my other post for details on this
 
localparam N = 18;
 
reg [N-1:0]	count2;
 
always @ (posedge i_clock or posedge i_reset)
 begin
  if (i_reset)
   count2 <= 0;
  else
   count2 <= count2 + 1;
 end
 
reg [6:0]sseg;
reg [3:0]an_temp;
reg reg_dp;

always @ (*) begin
  case(count2[N-1:N-2])
   2'b00 : begin
     sseg = reg_d0;
     an_temp = 4'b1110;
     reg_dp = 1'b1;
   end  
   2'b01: begin
     sseg = reg_d1;
     an_temp = 4'b1101;
     reg_dp = 1'b0;
   end
   2'b10: begin
     sseg = reg_d2;
     an_temp = 4'b1011;
     reg_dp = 1'b1;
   end  
   2'b11: begin
     sseg = reg_d3;
     an_temp = 4'b0111;
     reg_dp = 1'b0;
   end
  endcase
end
 
assign an = an_temp;
 
reg [6:0] sseg_temp; 
always @ (*) begin
  case(sseg)
   4'd0 : sseg_temp = 7'b1000000;
   4'd1 : sseg_temp = 7'b1111001;
   4'd2 : sseg_temp = 7'b0100100;
   4'd3 : sseg_temp = 7'b0110000;
   4'd4 : sseg_temp = 7'b0011001;
   4'd5 : sseg_temp = 7'b0010010;
   4'd6 : sseg_temp = 7'b0000010;
   4'd7 : sseg_temp = 7'b1111000;
   4'd8 : sseg_temp = 7'b0000000;
   4'd9 : sseg_temp = 7'b0010000;
   default : sseg_temp = 7'b0111111; //dash
  endcase
end

assign {g, f, e, d, c, b, a} = sseg_temp; 
assign dp = reg_dp;
 
endmodule
*/

// First Screen
module scrolling_name(
	input clk,
	input rst_n,
	output a,
	output b,
	output c,
	output d,
	output e,
	output f,
	output g,
	output dp,
	output [5:0] an	);
 
reg [28:0] ticker; //to hold a count of 50M

wire click;
reg [5:0] sixth, fifth, fourth, third, second, first; // registers to hold the LED values
 
always @ (posedge clk or posedge rst_n) begin		//always block for the ticker
	if(rst_n == 0)
		ticker <= 0;
	end else begin
		if(ticker == 50000000) begin	 //reset after 1 second
			ticker <= 0;
		end else begin
			ticker <= ticker + 1;
		end
	end
end
 
reg [5:0] clickcount;	//register to hold the count upto 9. That is why a 4 bit register is used. 3 bit would not have been enough.
 
assign click = ((ticker == 50000000) ? 1'b1 : 1'b0);	//click every second
 
always @ (posedge click or posedge rst_n) begin
	if(rst_n)
		clickcount <= 0;
	end else begin
		if(clickcount == 8) begin
			clickcount <= 0;
		end else begin
			clickcount <= clickcount + 1;
		end
	end
end
 
always @ (*) begin		//always block that will scroll or move the text. Accomplished with case
	case(clickcount)
		0: begin
			sixth = 4;	// H
			fifth = 3;	// E
			fourth = 7;	// L
			third = 7;	// L
			second = 0;	// O
			first = 2;	// -
		end

		1: begin
			sixth = 3;	// E
			fifth = 7;	// L
			fourth = 7;	// L
			third = 0;	// O
			second = 2;	// -
			first = 1;	// T
		end

		2: begin
			sixth = 7;	// L
			fifth = 7;	// L
			fourth = 0;	// O
			third = 2;	// -
			second = 1;	// T
			first = 4;	// H
		end

		3: begin
			sixth = 7;	// L
			fifth = 0;	// O
			fourth = 2;	// -
			third = 1;	// T
			second = 4;	// H
			first = 3;	// E
		end

		4: begin
			sixth = 0;	// O
			fifth = 2;	// -
			fourth = 1;	// T
			third = 4;	// H
			second = 3;	// E
			first = 8;	// R
		end

		5: begin
			sixth = 2;	// -
			fifth = 1;	// T
			fourth = 4;	// H
			third = 3;	// E
			second = 8;	// R
			first = 3;	// E
		end

		6: begin
			sixth = 1;	// T
			fifth = 4;	// H
			fourth = 3;	// E
			third = 8;	// R
			second = 3;	// E
			first = 2;	// -
		end
	endcase
end
 
//see my other post on explanation of LED multiplexing.
 
parameter N = 18;
 
reg [N-1:0]count;
 
always @ (posedge clk or posedge rst_n) begin
	if (rst_n)
		count <= 0;
	end else begin
		count <= count + 1;
	end
end
 
reg [6:0] sseg;
reg [5:0] an_temp;
 
always @ (*) begin
	case(count[N-1:N-2])
		3?b000 : begin
			sseg = first;
			an_temp = 6?b111110;
		end

		3?b001 : begin
			sseg = second;
			an_temp = 6?b111101;
		end

		3?b010 : begin
			sseg = third;
			an_temp = 6?b111011;
		end

 		3?b011 : begin
			sseg = fourth;
			an_temp = 6?b110111;
		end

		3?b100 : begin
			sseg = fifth;
			an_temp = 6?b101111;
		end

		3?b101 : begin
			sseg = sixth;
			an_temp = 6?b011111;
		end
	endcase
end

assign an = an_temp;
 
reg [6:0] sseg_temp; 
always @ (*) begin
  case(sseg)
   4 : sseg_temp = 7'b0001001; //to display H
   3 : sseg_temp = 7'b0000110; //to display E
   7 : sseg_temp = 7'b1000111; //to display L
   0 : sseg_temp = 7'b1000000; //to display O
   1 : sseg_temp = 7'b0000111; //to display T
   8 : sseg_temp = 7'b0001000; //to display R
    
   default : sseg_temp = 7'b1111111; //blank
  endcase
 end
assign {g, f, e, d, c, b, a} = sseg_temp;
assign dp = 1'b1;

endmodule
//


module	digital_clock(
		o_seg_enb,
		o_seg_dp,
	 	o_seg,
		o_alarm,
		i_sw0,
		i_sw1,
		i_sw2,
		i_sw3,
		i_sw4,
		i_sw5,
		clk,
		rst_n);
    
output	[5:0]	o_seg_enb	;
output	     	o_seg_dp	;
output	[6:0]	o_seg		  ;
output	     	o_alarm		;

input		i_sw0		;
input		i_sw1		;
input		i_sw2		;
input		i_sw3		;
input		i_sw4		;
input		i_sw5		;
input		clk		  ;
input		rst_n		;

wire		max_hit_secc		;
wire 		 max_hit_min     ;
wire		  max_hit_sec     ;
wire  		max_hit_hou     ;
wire  		hou_clk         ;
wire		  min_clk         ;
wire		  sec_clk         ;
wire			secc_clk			;

wire  		alarm_en        ;
wire  		alarm_min       ;
wire  		alarm_sec       ;
wire  		alarm_hou       ;

wire  		timer_secc       ;
wire  		timer_sec       ;
wire  		timer_min       ;

wire  		[1:0]position   ;
wire  		[1:0]mode       ;
wire			[1:0]	world_position;
wire			[1:0]	timer_position;

controller u_ctrl (
			.o_mode(mode),
			.o_position(position),
			.o_world_position(world_position),
			.o_timer_position(timer_position),
			.o_alarm_en(alarm_en),
			.o_secc_clk(secc_clk),
			.o_sec_clk(sec_clk),
			.o_min_clk(min_clk),
			.o_hou_clk(hou_clk),
			.o_alarm_sec_clk(alarm_sec),
			.o_alarm_min_clk(alarm_min),
			.o_alarm_hou_clk(alarm_hou),
			.o_timer_sec_clk(timer_sec),
			.o_timer_min_clk(timer_min),
			.o_timer_hou_clk(timer_hou),
			.i_max_hit_secc(max_hit_secc),
			.i_max_hit_sec(max_hit_sec),
			.i_max_hit_min(max_hit_min),
			.i_max_hit_hou(max_hit_hou),
			.i_sw0(i_sw0),
			.i_sw1(i_sw1),
			.i_sw2(i_sw2),
			.i_sw3(i_sw3),
			.i_sw4(i_sw4),
			.i_sw5(i_sw5),
			.clk(clk),
			.rst_n(rst_n));		

wire		[5:0]		secc			;
wire    [5:0]   min            ;
wire    [5:0]   sec            ;
wire    [5:0]   hou            ;


wire    buzz                    ;
  
houminsec u_houminsec (
			.o_secc(secc),
			.o_sec(sec),
			.o_min(min),
			.o_hou(hou),
			.o_max_hit_secc(max_hit_secc),
			.o_max_hit_sec(max_hit_sec),
			.o_max_hit_min(max_hit_min),
			.o_max_hit_hou(max_hit_hou),
			.o_alarm(buzz),
			.i_mode(mode),
			.i_position(position),
			.i_world_position(world_position),
			.i_timer_position(timer_position),
			.i_secc_clk(secc_clk),
			.i_sec_clk(sec_clk),
			.i_min_clk(min_clk),
			.i_hou_clk(hou_clk),
			.i_alarm_sec_clk(alarm_sec),
			.i_alarm_min_clk(alarm_min),
			.i_timer_secc_clk(timer_secc),
			.i_timer_sec_clk(timer_sec),
			.i_timer_min_clk(timer_min),
			.i_alarm_hou_clk(alarm_hou),
			.i_alarm_en(alarm_en),
			.clk(clk),
			.rst_n(rst_n));

buzz   u_buzz(
		  .o_buzz(o_alarm),
		  .i_buzz_en(buzz),
		  .clk(clk),
		  .rst_n(rst_n));

wire    [3:0]   sec_left_num   ;
wire    [3:0]   sec_right_num  ;
wire    [6:0]   sec_left       ;
wire    [6:0]   sec_right      ;

double_fig_sep u0_dfs(
			.o_left(sec_left_num),
			.o_right(sec_right_num),
			.i_double_fig(sec));
	
fnd_dec u0_fnd_dec(
			.o_seg(sec_left),
			.i_num(sec_left_num));

fnd_dec u1_fnd_dec(
			.o_seg(sec_right),
			.i_num(sec_right_num));


wire    [3:0]   min_left_num   ;
wire    [3:0]   min_right_num  ;
wire    [6:0]   min_left       ;
wire    [6:0]   min_right      ;

double_fig_sep u1_dfs(
			.o_left(min_left_num),
			.o_right(min_right_num),
			.i_double_fig(min));

fnd_dec u2_fnd_dec(
			.o_seg(min_left),
			.i_num(min_left_num));

fnd_dec u3_fnd_dec(
			.o_seg(min_right),
			.i_num(min_right_num));

wire    [3:0]   hou_left_num   ;
wire    [3:0]   hou_right_num  ;
wire    [6:0]   hou_left       ;
wire    [6:0]   hou_right      ;

double_fig_sep u2_dfs(
			.o_left(hou_left_num),
			.o_right(hou_right_num),
			.i_double_fig(hou));

fnd_dec u4_fnd_dec(
			.o_seg(hou_left),
			.i_num(hou_left_num));

fnd_dec u5_fnd_dec(
			.o_seg(hou_right),
			.i_num(hou_right_num));
			
wire	secc_sw	;
wire	sec_sw	;
wire	min_sw	;

/*			
stopwatch		u_sw(
			.clk			( clk		),
			.i_sw1		( i_sw1	),
			.i_sw5		( i_sw5	),
			.o_secc_sw	( secc_sw),
			.o_sec_sw	( sec_sw	),
			.o_min_sw	( min_sw	));
*/
			
//wire [41:0] six_digit_seg_sw	;
//assign six_digit_seg_sw = {};

			
wire [41:0] six_digit_seg	;
assign six_digit_seg = {hou_left,hou_right,min_left,min_right,sec_left,sec_right};

led_disp u_led_disp (
			.o_seg(o_seg),
			.o_seg_dp(o_seg_dp),
			.o_seg_enb(o_seg_enb),
			.i_six_digit_seg(six_digit_seg),
			.i_mode(mode),
			.i_position(position),
			.i_alarm_en(alarm_en),
			.clk(clk),
			.rst_n(rst_n));

scrolling_name u_scr_name(
			.clk		( clk		),
			.rst_n	( rst_n	),
			.a,
			.b,
			.c,
			.d,
			.e,
			.f,
			.g,
			.dp,
			.an	);

/*			
stopwatch	u_sw(
    .i_clock	( clk	),
    .i_reset	( i_sw1	),
    .i_start	( i_sw2	),
    .a			( 	),
	 .b			( 	),
	 .c			( 	),
	 .d			( 	),
	 .e			( 	),
	 .f			( 	),
	 .g			( 	),
	 .dp			( 	),
    .an			( 	));
	 */

endmodule

  