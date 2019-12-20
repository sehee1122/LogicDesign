//   ==================================================
//   Copyright (c) 2019 Sookmyung Women's University.
//   --------------------------------------------------
//   FILE          : digital_clock.v
//   DEPARTMENT      : EE
//   AUTHOR         : kimsubin,parksehee,parkjungeun
//   EMAIL         : x
//   --------------------------------------------------
//   RELEASE HISTORY
//   --------------------------------------------------
//   VERSION         DATE
//   FINAL         2019-12-10
//   --------------------------------------------------
//   PURPOSE         : Digital Clock
//   ==================================================

//   --------------------------------------------------
//   Numerical Controlled Oscillator
//   Hz of o_gen_clk = Clock Hz / num
//   --------------------------------------------------
module   nco(   
      o_gen_clk,
      i_nco_num,
      clk,
      rst_n);

output      o_gen_clk   ;   // 1Hz CLK

input   [31:0]   i_nco_num   ;
input      clk      ;   // 50Mhz CLK
input      rst_n      ;

reg   [31:0]   cnt      ;
reg      o_gen_clk   ;

always @(posedge clk or negedge rst_n) begin
   if(rst_n == 1'b0) begin
      cnt      <= 32'd0;
      o_gen_clk   <= 1'd0   ;
   end else begin
      if(cnt >= i_nco_num/2-1) begin
         cnt    <= 32'd0;
         o_gen_clk   <= ~o_gen_clk;
      end else begin
         cnt <= cnt + 1'b1;
      end
   end
end

endmodule
//   --------------------------------------------------
//   generate welcome expression
//   --------------------------------------------------

module  generate_hello(
         before_clk,
         o_six_digit_seg);


input  [3:0]  before_clk   ;

output [41:0] o_six_digit_seg   ;

reg    [41:0] six_digit_seg   ;


always @(before_clk) begin
   if( before_clk <= 4'd5 ) begin
      six_digit_seg [6:0]   = 7'b111_1110;
      six_digit_seg [13:7]  = 7'b000_1110;
      six_digit_seg [20:14] = 7'b000_1110;
      six_digit_seg [27:21] = 7'b100_1111;
      six_digit_seg [34:28] = 7'b011_0111; 
      six_digit_seg [41:35] = 7'b000_0000; 
   end else begin
      six_digit_seg [6:0]   = 7'b011_0111;
      six_digit_seg [13:7]  = 7'b100_1110;
      six_digit_seg [20:14] = 7'b000_1111;
      six_digit_seg [27:21] = 7'b111_0111;
      six_digit_seg [34:28] = 7'b011_1110; 
      six_digit_seg [41:35] = 7'b011_1110;
   end
end

assign o_six_digit_seg = six_digit_seg;


endmodule


//   --------------------------------------------------
//   Flexible Numerical Display Decoder
//   --------------------------------------------------

module   fnd_dec(
      o_seg,
      i_num);

output   [6:0]   o_seg      ;   // {o_seg_a, o_seg_b, ... , o_seg_g}

input   [3:0]   i_num      ;
reg   [6:0]   o_seg      ;

//making
always @(i_num) begin 
   case(i_num) 
      4'd0:   o_seg = 7'b111_1110;
      4'd1:   o_seg = 7'b011_0000;
      4'd2:   o_seg = 7'b110_1101; 
      4'd3:   o_seg = 7'b111_1001; 
      4'd4:   o_seg = 7'b011_0011; 
      4'd5:   o_seg = 7'b101_1011; 
      4'd6:   o_seg = 7'b101_1111; 
      4'd7:   o_seg = 7'b111_0000; 
      4'd8:   o_seg = 7'b111_1111; 
      4'd9:   o_seg = 7'b111_0011; 
      default:o_seg = 7'b000_0000; 
   endcase 
end

endmodule




//   --------------------------------------------------
//   0~59 --> 2 Separated Segments
//   --------------------------------------------------
module   double_fig_sep(
      o_left,
      o_right,
      i_double_fig);

output   [3:0]   o_left      ;
output   [3:0]   o_right      ;

input   [6:0]   i_double_fig   ;

assign   o_left   = i_double_fig / 10   ;
assign   o_right   = i_double_fig % 10   ;

endmodule

////start blink module
module startblink (  
               i_six_digit_seg,
               o_six_digit_seg,
               clk,
               rst_n,
               create_hello);
                 
              
   
input   [41:0]   i_six_digit_seg         ;       
input          clk               ;
input          rst_n               ;
input          create_hello         ;

output [41:0]   o_six_digit_seg         ;   

  

wire      start_clk      ;   

nco      u_nco( 
      .o_gen_clk  ( start_clk   ),
      .i_nco_num   ( 32'd50000000   ),
      .clk      ( clk      ),
      .rst_n      ( rst_n      ));

reg [41:0] o_six_digit_seg;

reg      count1         ;

always @(posedge start_clk or negedge rst_n) begin
   if(rst_n == 1'b0) begin
      count1 = 1'b0;
   end else begin
      count1 <= count1 + 1'b1;
   end
end

always @(posedge start_clk or negedge rst_n) begin
  if((rst_n == 1'b0) )begin
     o_six_digit_seg [41:0] = 42'd0                    ;
   end else begin
     if (create_hello == 1'b1) begin
		o_six_digit_seg [41:0] = 42'd0 ;
      end else begin
           if(count1 == 1'b0) begin
         o_six_digit_seg = i_six_digit_seg              ;
              end else begin
             o_six_digit_seg [41:0] = 42'd0;
         end
         end
   end
end

endmodule

//   --------------------------------------------------
//   generate welcome expression
//   --------------------------------------------------
module world_name(
                      i_world_position,
                      o_world_name,
                      i_mode);


output [41:0] o_world_name ;

input [1:0] i_world_position;
input [2:0] i_mode ;
reg [41:0] o_world_name ;

always @(i_mode) begin
  if(i_mode == 3'b011) begin
    case (i_world_position)
      2'b00 : begin
        o_world_name [6:0]   = 7'b111_0111;
        o_world_name [13:7]  = 7'b101_1011;
        o_world_name [20:14] = 7'b011_1110;
        o_world_name [41:21] = 21'd0;
      end
      2'b01 : begin
        o_world_name [6:0]   = 7'b101_1111;
        o_world_name [13:7]  = 7'b111_0110;
        o_world_name [20:14] = 7'b100_1111;
        o_world_name [41:21] = 21'd0;
      end
      2'b10 : begin
        o_world_name [6:0]   = 7'b101_1011;
        o_world_name [13:7]  = 7'b011_1110;
        o_world_name [20:14] = 7'b111_0111;
        o_world_name [41:21] = 21'd0;
      end
      
   endcase
 end
end


endmodule
 

//   --------------------------------------------------
//   blink (Add blink : six_digit_seg blink & dp blink
//   --------------------------------------------------
module blink (
      i_mode,
      i_position,
      i_six_digit_seg,
      o_six_digit_seg,
      clk,
      rst_n,
      o_six_dp,
      i_alarm_en,
      create_hello);

input   [1:0]   i_position      ;
input   [2:0]   i_mode         ;
   
input   [41:0]   i_six_digit_seg      ;       
input      clk         ;
input      rst_n         ;
input      i_alarm_en      ;
input      create_hello      ;

output   [41:0]   o_six_digit_seg      ;
output   [5:0]   o_six_dp      ;

wire      gen_clk         ;   

nco      u_nco(
      .o_gen_clk   ( gen_clk   ),
      .i_nco_num   ( 32'd5000   ),
      .clk      ( clk      ),
      .rst_n      ( rst_n      ));

wire      clk_1hz         ;
nco      u1_nco(
      .o_gen_clk   ( clk_1hz   ),
      .i_nco_num   ( 32'd50000000   ),
      .clk      ( clk      ),
      .rst_n      ( rst_n      ));

wire      clk_2         ;

nco      u2_nco(
      .o_gen_clk   ( clk_2      ),
      .i_nco_num   ( 32'd5000000   ),
      .clk      ( clk      ),
      .rst_n      ( rst_n      ));      
      
reg   [5:0]   o_seg_enb      ;
reg      count1         ;

always @(posedge clk_2 or negedge rst_n) begin
   if(rst_n == 1'b0) begin
      count1 = 1'b0;
   end else begin
      count1 <= count1 + 1'b1;
   end
end

reg [41:0] o_six_digit_seg;

always @(i_mode, i_position, count1) begin
 if(create_hello == 1'b0) begin
   o_six_digit_seg = 42'd0;
   end else begin
   if((i_mode == 3'b001) || (i_mode == 3'b010))begin
      case (i_position)
         2'b00 : begin
            if(count1 == 1'b0) begin
               o_six_digit_seg [13:0] = 14'd0            ;
               o_six_digit_seg [41:14] = i_six_digit_seg [41:14]   ;
            end else begin
               o_six_digit_seg = i_six_digit_seg          ;
            end
         end
         2'b01 : begin
            if(count1 == 1'b0) begin
               o_six_digit_seg [13:0]  = i_six_digit_seg [13:0]   ;
               o_six_digit_seg [27:14] = 14'd0            ;
               o_six_digit_seg [41:28] = i_six_digit_seg [41:28]   ;
            end else begin
               o_six_digit_seg = i_six_digit_seg         ;
            end
         end
         2'b10 : begin
            if(count1 == 1'b0) begin
               o_six_digit_seg [27:0]  = i_six_digit_seg [27:0]   ;
               o_six_digit_seg [41:28] = 14'd0            ;
            end else begin
               o_six_digit_seg = i_six_digit_seg         ;
            end
         end
      endcase
   end else begin
      o_six_digit_seg = i_six_digit_seg   ;
   end
    end
end
     
reg   [1:0]   find_alarm = 2'b00   ;
reg   [1:0]   find_alarm_x = 2'b00   ;

always @(posedge clk) begin
   find_alarm_x = find_alarm   ;
end
      
always @(posedge clk_1hz or negedge rst_n) begin
   if(rst_n == 1'b0) begin
      find_alarm = 2'b00;
   end else begin
      find_alarm = {find_alarm_x[0],i_alarm_en};
   end
end

reg   [5:0]   o_six_dp      ;     

always @(i_mode,i_position) begin
 if(create_hello == 1'b0) begin
   o_six_dp = 6'd0;
   end else begin
   if (i_mode == 3'b001) begin
      case (i_position)
         2'b00:   o_six_dp = 6'b000001;
         2'b01:   o_six_dp = 6'b000100;
         2'b10:   o_six_dp = 6'b010000;
         default:o_six_dp = 6'b000000;
      endcase
   end else begin
      if (i_mode == 3'b010) begin
         case (i_position)
            2'b00:   o_six_dp = 6'b000010;
            2'b01:   o_six_dp = 6'b001000;
            2'b10:   o_six_dp = 6'b100000;
            default:o_six_dp = 6'b000000;
         endcase
      end else begin
         o_six_dp = 6'b000000;
      end
      //i_mode is not 2'b10 and 2'b01, i_six_dp have to be 6'b000000
   end 
   if( (find_alarm == 2'b01)||(find_alarm == 2'b10) ) begin
      o_six_dp = 6'b111111;
   end
    end
end

endmodule


//   --------------------------------------------------
//   0~59 --> 2 Separated Segments
//   --------------------------------------------------
module   led_disp(
      o_seg,
      o_seg_dp,
      o_seg_enb,
      i_six_digit_seg_1,
      i_six_digit_seg_2,
      i_six_dp,
      clk,
      rst_n,
      create_hello,
      i_world_name,
      i_mode,
      i_world_position);    //add i_mode & i_position --> to make new i_six_dp

output   [5:0]   o_seg_enb      ;
output           o_seg_dp       ;  
output   [6:0]   o_seg          ;

input   [41:0]   i_six_digit_seg_1   ;
input   [41:0]   i_six_digit_seg_2   ;
input   [5:0]    i_six_dp            ;
input   [3:0]    i_mode              ;
input   [41:0]   i_world_name        ;
input   [1:0]    i_world_position    ; 
input      clk         ;
input      rst_n         ;
input      create_hello      ;


wire      gen_clk         ;   

nco      u_nco(
      .o_gen_clk   ( gen_clk   ),
      .i_nco_num   ( 32'd5000   ),
      .clk      ( clk      ),
      .rst_n      ( rst_n      ));


wire      gen_world_name_clk         ;   

nco      u_nco1(
      .o_gen_clk   ( gen_world_name_clk   ),
      .i_nco_num   ( 32'd5000000   ),
      .clk      ( clk      ),
      .rst_n      ( rst_n      ));
      
reg   [3:0]   cnt_common_node      ;

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

reg [5:0] count1 ;
reg [5:0] count2 ;
reg [5:0] count3 ;
reg       dec_world_name ;


always@(posedge gen_world_name_clk or negedge rst_n) begin
  if(rst_n == 1'b0) begin
      count1 <= 6'd0;
      count2 <= 6'd0;
      count3 <= 6'd0;
  end else begin
    if(i_mode == 3'b011)begin
      case(i_world_position)
       2'b00 : begin 
        if(count1 < 6'd15)begin
         count1 <= count1 + 1'b1;
         dec_world_name <= 1'b0;
        end else begin
         count1 <= 6'd15;
         dec_world_name <= 1'b1;
        end
        count2 <= 6'd0;
        count3 <= 6'd0;
      end
      2'b01 : begin
        if(count2 < 6'd15)begin
         count2 <= count2 + 1'b1;
         dec_world_name <= 1'b0;
        end else begin
         count2 <= 6'd15;
         dec_world_name <= 1'b1;
        end
        count1 <= 6'd0;
        count3 <= 6'd0; 
      end
      2'b10 : begin
        if(count3 < 6'd15)begin
         count3 <= count3 + 1'b1;
         dec_world_name <= 1'b0;
        end else begin
         count3 <= 6'd15;
         dec_world_name <= 1'b1;
        end 
        count1 <= 6'd0;
        count2 <= 6'd0;
      end
     endcase
    end else begin
      count1 <= 6'd0;
      count2 <= 6'd0;
      count3 <= 6'd0;
    end
  end
end

reg    [41:0] six_digit_seg ;

always @(create_hello) begin
    if( create_hello == 1'b0 ) begin
      six_digit_seg <= i_six_digit_seg_1;
    end else begin
      six_digit_seg <= i_six_digit_seg_2;
    end
    if((i_mode == 3'b011) && (dec_world_name == 1'b0)) begin
      six_digit_seg <= i_world_name ;
    end
end


reg   [5:0]   o_seg_enb      ;

always @(cnt_common_node) begin
   case (cnt_common_node)
      4'd0:   o_seg_enb = 6'b111110;
      4'd1:   o_seg_enb = 6'b111101;
      4'd2:   o_seg_enb = 6'b111011;
      4'd3:   o_seg_enb = 6'b110111;
      4'd4:   o_seg_enb = 6'b101111;
      4'd5:   o_seg_enb = 6'b011111;
      default:o_seg_enb = 6'b111111;
   endcase
end

reg      o_seg_dp      ; //add

always @(cnt_common_node) begin
   case (cnt_common_node)
      4'd0:   o_seg_dp = i_six_dp[0];
      4'd1:   o_seg_dp = i_six_dp[1];
      4'd2:   o_seg_dp = i_six_dp[2];
      4'd3:   o_seg_dp = i_six_dp[3];
      4'd4:   o_seg_dp = i_six_dp[4];
      4'd5:   o_seg_dp = i_six_dp[5];
      default:o_seg_dp = 1'b0;
   endcase
end

//i_mode = 1, find_alarm = 1 or i_mode = 0

reg   [6:0]   o_seg         ;

always @(cnt_common_node) begin
   case (cnt_common_node)
      4'd0:   o_seg = six_digit_seg[6:0];
      4'd1:   o_seg = six_digit_seg[13:7];
      4'd2:   o_seg = six_digit_seg[20:14];
      4'd3:   o_seg = six_digit_seg[27:21];
      4'd4:   o_seg = six_digit_seg[34:28];
      4'd5:   o_seg = six_digit_seg[41:35];
      default:o_seg = 7'b111_1110; // 0 display
   endcase
end

endmodule


//   --------------------------------------------------
//   HMS(Hour:Min:Sec) Counter
//   --------------------------------------------------
module   hms_cnt(
      o_hms_cnt,
      o_max_hit,
      i_max_cnt,
      clk,
      rst_n,
      create_hello);

output   [5:0]   o_hms_cnt      ;
output      o_max_hit      ;

input   [5:0]   i_max_cnt      ;
input      clk         ;
input      rst_n         ;
input      create_hello      ;

reg   [5:0]      o_hms_cnt      ;
reg         o_max_hit      ;

always @(posedge clk or negedge rst_n ) begin
   if((rst_n == 1'b0))begin
      o_hms_cnt <= 6'd0;
      o_max_hit <= 1'b0;
   end else begin
   if ((create_hello == 1'b0)) begin
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
end

endmodule

module   hms_cntdwn(
      o_hms_cnt,
      o_min_hit,
      i_max_cnt,
      clk,
      i_cntdwn_mode,
      rst_n,
      find_cntdwn,
      create_hello);

output   [5:0]   o_hms_cnt      ;
output      o_min_hit      ;

input   [5:0]   i_max_cnt      ;
input      clk         ;
input      rst_n         ;
input   [1:0]   i_cntdwn_mode      ;
input      find_cntdwn      ;
input      create_hello      ;


reg   [5:0]   o_hms_cnt      ;
reg      o_min_hit      ;

always @(posedge clk or negedge rst_n ) begin
   if((rst_n == 1'b0))begin
      o_hms_cnt <= 6'd0;
      o_min_hit <= 1'b0;
   end else begin
   if ((create_hello == 1'b0)) begin
      o_hms_cnt <= 6'd0;
      o_min_hit <= 1'b0;
   end else begin
      if(find_cntdwn == 1'b1 ) begin
         o_hms_cnt <= 6'd0;
         o_min_hit <= 1'b0;
      end else begin
         case(i_cntdwn_mode)
            2'b00 : begin
               o_hms_cnt = 6'd0;
               o_min_hit = 1'b0;
            end
            2'b01 : begin
               if(o_hms_cnt >= i_max_cnt) begin
               o_hms_cnt <= 6'd0;
            end else begin
               o_hms_cnt <= o_hms_cnt + 1'b1;
            end
         end
            2'b10 : begin
               if(o_hms_cnt == 6'd0) begin
                  o_hms_cnt <= i_max_cnt;
                  o_min_hit <= 1'b1;
               end else begin  
                  o_hms_cnt <= o_hms_cnt - 1'b1;
                  o_min_hit <= 1'b0;
               end
            end
         endcase
      end
   end
    end
end

endmodule


module   hms_cntup(
      o_hms_cnt,
      o_max_hit,
      i_max_cnt,
      clk,
      i_cntup_mode,
      rst_n,
      create_hello);

output   [6:0]   o_hms_cnt      ;
output      o_max_hit      ;

input   [6:0]   i_max_cnt      ;
input      clk         ;
input      rst_n         ;
input   [1:0]   i_cntup_mode      ;
input      create_hello      ;
reg   [6:0]   o_hms_cnt      ;
reg      o_max_hit      ;

always @(posedge clk or negedge rst_n ) begin
   if((rst_n == 1'b0))begin
      o_hms_cnt <= 7'd0;
      o_max_hit <= 1'b0;
   end else begin
   if ((create_hello == 1'b0)) begin
      o_hms_cnt <= 7'd0;
      o_max_hit <= 1'b0;
   end else begin
      case(i_cntup_mode)
         2'b00 : begin
            o_hms_cnt = 7'd0;
            o_max_hit = 1'b0;
         end
         2'b01 : begin
            if(o_hms_cnt >= i_max_cnt) begin
               o_hms_cnt <= 7'd0;
               o_max_hit <= 1'b1;
            end else begin
               o_hms_cnt <= o_hms_cnt + 1'b1;
               o_max_hit <= 1'b0;
            end
         end
         2'b10 : begin
            o_hms_cnt <= o_hms_cnt;
            o_max_hit <= 1'b0;
         end
      endcase
   end
    end
end

endmodule


module  debounce(
      o_sw,
      i_sw,
      clk);
output      o_sw         ;

input      i_sw         ;
input      clk         ;

reg      dly1_sw         ;

always @(posedge clk) begin
   dly1_sw <= i_sw;
end

reg      dly2_sw         ;
always @(posedge clk) begin
   dly2_sw <= dly1_sw;
end

assign      o_sw = dly1_sw | ~dly2_sw;

endmodule


//   --------------------------------------------------
//   Clock Controller
//   --------------------------------------------------
module   controller(
      o_mode,
      o_position,
      o_world_position,
      o_alarm_en,
      o_timer_en,
      o_stwat_en,
      o_sec_clk,
      o_min_clk,
      o_hou_clk,
      o_alarm_sec_clk,
      o_alarm_min_clk,
      o_alarm_hou_clk,
      o_timer_sec_clk,
      o_timer_min_clk,
      o_timer_hou_clk,
      o_stwat_sec_clk,
      o_stwat_min_clk,
      o_stwat_msec_clk,
      i_max_hit_sec,
      i_max_hit_min,
      i_max_hit_hou,
      i_min_hit_sec,
      i_min_hit_min,
      i_min_hit_hou,
      i_max_hit_cnt_sec,
      i_max_hit_cnt_min,
      i_max_hit_cnt_msec,
      i_sw0,
      i_sw1,
      i_sw2,
      i_sw3,
      i_sw4,
      i_sw5,
      i_sw6,
      clk,
      rst_n);

output   [2:0]   o_mode         ;
output   [1:0]   o_position      ;
output   [1:0]   o_world_position   ;
output   [1:0]   o_timer_en      ;
output   [1:0]   o_stwat_en      ;
output      o_alarm_en      ;
output      o_sec_clk      ;
output      o_min_clk      ;
output      o_hou_clk      ;
output      o_alarm_sec_clk      ;
output      o_alarm_min_clk      ;
output      o_alarm_hou_clk      ;
output      o_timer_sec_clk      ;
output      o_timer_min_clk      ;
output      o_timer_hou_clk      ;
output      o_stwat_msec_clk   ;
output      o_stwat_sec_clk      ;
output      o_stwat_min_clk      ;

input      i_max_hit_sec      ;
input      i_max_hit_min      ;
input      i_max_hit_hou      ;
input      i_min_hit_sec      ;
input      i_min_hit_min      ;
input      i_min_hit_hou      ;
input      i_max_hit_cnt_msec   ;
input      i_max_hit_cnt_sec   ;
input      i_max_hit_cnt_min   ;

input      i_sw0         ;
input      i_sw1         ;
input      i_sw2         ;
input      i_sw3         ;
input      i_sw4         ;
input      i_sw5         ;
input      i_sw6         ;

input      clk         ;
input      rst_n         ;

parameter   MODE_CLOCK   = 3'b000;
parameter   MODE_SETUP   = 3'b001;
parameter   MODE_ALARM   = 3'b010;
parameter   MODE_WORLD   = 3'b011;
parameter   MODE_TIMER   = 3'b100;   //MODE COUNTDOWN
parameter   MODE_STWAT   = 3'b101;   //MODE COUNTUP
parameter   POS_SEC      = 2'b00   ;
parameter   POS_MIN      = 2'b01   ;
parameter   POS_HOU     = 2'b10   ;
parameter   WOR_USA      = 2'b00   ;   //TIME OF USA
parameter   WOR_ENG      = 2'b01   ;   //TIME OF ENGLAND
parameter   WOR_AUS      = 2'b10   ;   //TIME OF AUSTRALIA
parameter   CNTDWN_RESET   = 2'b00   ;
parameter   CNTDWN_SETUP   = 2'b01   ;
parameter   CNTDWN_GODWN   = 2'b10   ;
parameter   CNTUP_RESET   = 2'b00   ;
parameter   CNTUP_SETUP   = 2'b01   ;
parameter   CNTUP_GOUP   = 2'b10   ;

wire      clk_100hz      ;
nco      u0_nco(
      .o_gen_clk   ( clk_100hz   ),
      .i_nco_num   ( 32'd500000   ),
      .clk      ( clk      ),
      .rst_n      ( rst_n      ));

wire      sw0         ;
debounce   u0_debounce(
      .o_sw      ( sw0      ),
      .i_sw      ( i_sw0      ),
      .clk      ( clk_100hz   ));

wire      sw1         ;
debounce   u1_debounce(
      .o_sw      ( sw1      ),
      .i_sw      ( i_sw1      ),
      .clk      ( clk_100hz   ));

wire      sw2         ;
debounce   u2_debounce(
      .o_sw      ( sw2      ),
      .i_sw      ( i_sw2      ),
      .clk      ( clk_100hz   ));

wire      sw3         ;
debounce   u3_debounce(
      .o_sw      ( sw3      ),
      .i_sw      ( i_sw3      ),
      .clk      ( clk_100hz   ));

wire      sw4         ;
debounce   u4_debounce(
      .o_sw      ( sw4      ),
      .i_sw      ( i_sw4      ),
      .clk      ( clk_100hz   ));

wire      sw5         ;
debounce   u5_debounce(
      .o_sw      ( sw5      ),
      .i_sw      ( i_sw5      ),
      .clk      ( clk_100hz   ));

wire      sw6         ;
debounce   u6_debounce(
      .o_sw      ( sw6      ),
      .i_sw      ( i_sw6      ),
      .clk      ( clk_100hz   ));

reg   [2:0]   o_mode         ;
always @(posedge sw0 or negedge rst_n) begin
   if(rst_n == 1'b0) begin
      o_mode <= MODE_CLOCK;
   end else begin
      if(o_mode >= MODE_STWAT) begin
         o_mode <= MODE_CLOCK;
      end else begin
         o_mode <= o_mode + 1'b1;
      end
   end
end

reg   [1:0]   o_position      ;
always @(posedge sw1 or negedge rst_n or negedge sw0) begin
   if(rst_n == 1'b0) begin
      o_position <= POS_SEC;
   end else begin 
		  if(sw0 == 1'b0) begin
			 o_position <= POS_SEC;
			end else begin
        if(o_position >= POS_HOU) begin
            o_position <= POS_SEC;
          end else begin
            o_position <= o_position + 2'b1;
          end 
         end
    end
end

reg      o_alarm_en      ;
always @(posedge sw3 or negedge rst_n) begin
   if(rst_n == 1'b0) begin
      o_alarm_en <= 1'b0;
   end else begin
      o_alarm_en <= o_alarm_en + 1'b1;
   end
end

reg   [1:0]   o_world_position   ;   //ADD TIME OF OTHER COUNTRIES WITH NEW BUTTON sw4 

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

reg   [1:0]   o_timer_en      ;
reg   [6:0]   o_hms_cnt      ;
reg      	  o_max_hit      ;
reg   [6:0]   i_max_cnt      ;

always @(posedge sw5 or negedge rst_n) begin
   if(rst_n == 1'b0) begin
      o_timer_en <= 1'b0;
      o_hms_cnt <= 6'd0;
      o_max_hit <= 1'b0;
   end else begin
      if(o_timer_en >= CNTDWN_GODWN ) begin
         o_timer_en <= CNTDWN_RESET;
      end else begin
         o_timer_en <= o_timer_en + 1'b1;
      end
   end
end

reg   [1:0]   o_stwat_en      ;

always @(posedge sw6 or negedge rst_n) begin
   if(rst_n == 1'b0) begin
      o_stwat_en <= 1'b0;
      o_hms_cnt <= 7'd0;
      o_max_hit <= 1'b0;
   end else begin
      if(o_stwat_en >= CNTUP_GOUP ) begin
         o_stwat_en <= CNTUP_RESET;
      end else begin
         o_stwat_en <= o_stwat_en + 1'b1;
      end
   end
end

wire      clk_1hz         ;
nco      u1_nco(
      .o_gen_clk   ( clk_1hz   ),
      .i_nco_num   ( 32'd50000000   ),
      .clk      ( clk      ),
      .rst_n      ( rst_n      ));

reg      o_sec_clk      ;
reg      o_min_clk      ;
reg      o_hou_clk      ;
reg      o_alarm_sec_clk      ;
reg      o_alarm_min_clk      ;
reg      o_alarm_hou_clk    ;
reg      o_timer_sec_clk      ;
reg      o_timer_min_clk      ;
reg      o_timer_hou_clk      ;
reg      o_stwat_msec_clk   ;
reg      o_stwat_sec_clk      ;
reg      o_stwat_min_clk      ;

always @(*) begin
   case(o_mode)
      MODE_CLOCK : begin
         o_sec_clk = clk_1hz;
         o_min_clk = i_max_hit_sec;
         o_hou_clk = i_max_hit_min;
         o_alarm_sec_clk = 1'b0;
         o_alarm_min_clk = 1'b0;
         o_alarm_hou_clk = 1'b0;
         o_timer_sec_clk = 1'b0;
         o_timer_min_clk = 1'b0;
         o_timer_hou_clk = 1'b0;
         o_stwat_msec_clk = 1'b0;
         o_stwat_sec_clk = 1'b0;
         o_stwat_min_clk = 1'b0;
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
               o_timer_sec_clk = 1'b0;
               o_timer_min_clk = 1'b0;
               o_timer_hou_clk = 1'b0;
               o_stwat_msec_clk = 1'b0;
               o_stwat_sec_clk = 1'b0;
               o_stwat_min_clk = 1'b0;
            end
            POS_MIN : begin
               o_sec_clk = 1'b0;
               o_min_clk = ~sw2;
               o_hou_clk = 1'b0;
               o_alarm_sec_clk = 1'b0;
               o_alarm_min_clk = 1'b0;
               o_alarm_hou_clk = 1'b0;
               o_timer_sec_clk = 1'b0;
               o_timer_min_clk = 1'b0;
               o_timer_hou_clk = 1'b0;
               o_stwat_msec_clk = 1'b0;
               o_stwat_sec_clk = 1'b0;
               o_stwat_min_clk = 1'b0;
            end
            POS_HOU : begin
               o_sec_clk = 1'b0;
               o_min_clk = 1'b0;
               o_hou_clk = ~sw2;
               o_alarm_sec_clk = 1'b0;
               o_alarm_min_clk = 1'b0;
               o_alarm_hou_clk = 1'b0;
               o_timer_sec_clk = 1'b0;
               o_timer_min_clk = 1'b0;
               o_timer_hou_clk = 1'b0;
               o_stwat_msec_clk = 1'b0;
               o_stwat_sec_clk = 1'b0;
               o_stwat_min_clk = 1'b0;
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
               o_timer_sec_clk = 1'b0;
               o_timer_min_clk = 1'b0;
               o_timer_hou_clk = 1'b0;
               o_stwat_msec_clk = 1'b0;
               o_stwat_sec_clk = 1'b0;
               o_stwat_min_clk = 1'b0;
            end
            POS_MIN : begin
               o_sec_clk = clk_1hz;
               o_min_clk = i_max_hit_sec;
               o_hou_clk = i_max_hit_min;
               o_alarm_sec_clk = 1'b0;
               o_alarm_min_clk = ~sw2;
               o_alarm_hou_clk = 1'b0;
               o_timer_sec_clk = 1'b0;
               o_timer_min_clk = 1'b0;
               o_timer_hou_clk = 1'b0;
               o_stwat_msec_clk = 1'b0;
               o_stwat_sec_clk = 1'b0;
               o_stwat_min_clk = 1'b0;
            end
            POS_HOU : begin
               o_sec_clk = clk_1hz;
               o_min_clk = i_max_hit_sec;
               o_hou_clk = i_max_hit_min;
               o_alarm_sec_clk = 1'b0;
               o_alarm_min_clk = 1'b0;
               o_alarm_hou_clk = ~sw2;
               o_timer_sec_clk = 1'b0;
               o_timer_min_clk = 1'b0;
               o_timer_hou_clk = 1'b0;
               o_stwat_msec_clk = 1'b0;
               o_stwat_sec_clk = 1'b0;
               o_stwat_min_clk = 1'b0;
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
         o_timer_sec_clk = 1'b0;
         o_timer_min_clk = 1'b0;
         o_timer_hou_clk = 1'b0;
         o_stwat_msec_clk = 1'b0;
         o_stwat_sec_clk = 1'b0;
         o_stwat_min_clk = 1'b0;
      end
      MODE_TIMER : begin
         case ( o_timer_en )
            CNTDWN_RESET : begin
               o_sec_clk = clk_1hz;
               o_min_clk = i_max_hit_sec;
               o_hou_clk = i_max_hit_min;
               o_alarm_sec_clk = 1'b0;
               o_alarm_min_clk = 1'b0;
               o_alarm_hou_clk = 1'b0;
               o_timer_sec_clk = clk_1hz;
               o_timer_min_clk = clk_1hz;
               o_timer_hou_clk = clk_1hz;
               o_stwat_msec_clk = 1'b0;
               o_stwat_sec_clk = 1'b0;
               o_stwat_min_clk = 1'b0;
            end
            CNTDWN_SETUP : begin
               case(o_position)
                  POS_SEC : begin
                     o_sec_clk = clk_1hz;
                     o_min_clk = i_max_hit_sec;
                     o_hou_clk = i_max_hit_min;
                     o_alarm_sec_clk = 1'b0;
                     o_alarm_min_clk = 1'b0;
                     o_alarm_hou_clk = 1'b0;
                     o_timer_sec_clk = ~sw2;
                     o_timer_min_clk = 1'b0;
                     o_timer_hou_clk = 1'b0;
                     o_stwat_msec_clk = 1'b0;
                     o_stwat_sec_clk = 1'b0;
                     o_stwat_min_clk = 1'b0;
                  end
                  POS_MIN : begin
                     o_sec_clk = clk_1hz;
                     o_min_clk = i_max_hit_sec;
                     o_hou_clk = i_max_hit_min;
                     o_alarm_sec_clk = 1'b0;
                     o_alarm_min_clk = 1'b0;
                     o_alarm_hou_clk = 1'b0;
                     o_timer_sec_clk = 1'b0;
                     o_timer_min_clk = ~sw2;
                     o_timer_hou_clk = 1'b0;
                     o_stwat_msec_clk = 1'b0;
                     o_stwat_sec_clk = 1'b0;
                     o_stwat_min_clk = 1'b0;
                  end
                  POS_HOU : begin
                     o_sec_clk = clk_1hz;
                     o_min_clk = i_max_hit_sec;
                     o_hou_clk = i_max_hit_min;
                     o_alarm_sec_clk = 1'b0;
                     o_alarm_min_clk = 1'b0;
                     o_alarm_hou_clk = 1'b0;
                     o_timer_sec_clk = 1'b0;
                     o_timer_min_clk = 1'b0;
                     o_timer_hou_clk = ~sw2;
                     o_stwat_msec_clk = 1'b0;
                     o_stwat_sec_clk = 1'b0;
                     o_stwat_min_clk = 1'b0;
                  end
               endcase
            end
            CNTDWN_GODWN : begin
               o_sec_clk = clk_1hz;
               o_min_clk = i_max_hit_sec;
               o_hou_clk = i_max_hit_min;
               o_alarm_sec_clk = 1'b0;
               o_alarm_min_clk = 1'b0;
               o_alarm_hou_clk = 1'b0;
               o_timer_sec_clk = clk_1hz;
               o_timer_min_clk = i_min_hit_sec;
               o_timer_hou_clk = i_min_hit_min;
               o_stwat_msec_clk = 1'b0;
               o_stwat_sec_clk = 1'b0;
               o_stwat_min_clk = 1'b0;
            end
         endcase
      end
      MODE_STWAT : begin
         case(o_stwat_en)
            CNTUP_RESET : begin
               o_sec_clk = clk_1hz;
               o_min_clk = i_max_hit_sec;
               o_hou_clk = i_max_hit_min;
               o_alarm_sec_clk = 1'b0;
               o_alarm_min_clk = 1'b0;
               o_alarm_hou_clk = 1'b0;
               o_timer_sec_clk = 1'b0;
               o_timer_min_clk = 1'b0;
               o_timer_hou_clk = 1'b0;
               o_stwat_msec_clk = clk_100hz;
               o_stwat_sec_clk = clk_1hz;
               o_stwat_min_clk = clk_1hz;
            end
            CNTUP_SETUP : begin
               o_sec_clk = clk_1hz;
               o_min_clk = i_max_hit_sec;
               o_hou_clk = i_max_hit_min;
               o_alarm_sec_clk = 1'b0;
               o_alarm_min_clk = 1'b0;
               o_alarm_hou_clk = 1'b0;
               o_timer_sec_clk = 1'b0;
               o_timer_min_clk = 1'b0;
               o_timer_hou_clk = 1'b0;
               o_stwat_msec_clk = clk_100hz;
               o_stwat_sec_clk = i_max_hit_cnt_msec;
               o_stwat_min_clk = i_max_hit_cnt_sec;
            end
            CNTUP_GOUP : begin
               o_sec_clk = clk_1hz;
               o_min_clk = i_max_hit_sec;
               o_hou_clk = i_max_hit_min;
               o_alarm_sec_clk = 1'b0;
               o_alarm_min_clk = 1'b0;
               o_alarm_hou_clk = 1'b0;
               o_timer_sec_clk = 1'b0;
               o_timer_min_clk = 1'b0;
               o_timer_hou_clk = 1'b0;
               o_stwat_msec_clk = clk_100hz;
               o_stwat_sec_clk = clk_1hz;
               o_stwat_min_clk = clk_1hz;
            end
         endcase
      end 
      default: begin
         o_sec_clk = 1'b0;
         o_min_clk = 1'b0;
         o_hou_clk = 1'b0;
         o_alarm_sec_clk = 1'b0;
         o_alarm_min_clk = 1'b0;
         o_alarm_hou_clk = 1'b0;
         o_timer_sec_clk = 1'b0;
         o_timer_min_clk = 1'b0;
         o_timer_hou_clk = 1'b0;
         o_stwat_sec_clk = 1'b0;
         o_stwat_min_clk = 1'b0;
         o_stwat_msec_clk = 1'b0;
      end
   endcase
end

endmodule


//   --------------------------------------------------
//   HMS(Hour:Min:Sec) Counter
//   --------------------------------------------------
module   houminsec(   
      o_sec,
      o_min,
      o_hou,
      o_max_hit_sec,
      o_max_hit_min,
      o_max_hit_hou,
      o_min_hit_sec,
      o_min_hit_min,
      o_min_hit_hou,
      o_max_hit_cnt_sec,
      o_max_hit_cnt_min,
      o_max_hit_cnt_msec,
      o_alarm,
      o_timer,
      i_mode,
      i_position,
      i_world_position,
      i_sec_clk,
      i_min_clk,
      i_hou_clk,
      i_alarm_sec_clk,
      i_alarm_min_clk,
      i_alarm_hou_clk,
      i_alarm_en,
      i_timer_sec_clk,
      i_timer_min_clk,
      i_timer_hou_clk,
      i_timer_en,
      i_stwat_sec_clk,
      i_stwat_min_clk,
      i_stwat_msec_clk,
      i_stwat_en,
      clk,
      rst_n,
      create_hello);

output   [6:0]   o_sec      ;
output   [5:0]   o_min      ;
output   [5:0]   o_hou      ;
output      o_max_hit_sec   ;
output      o_max_hit_min   ;
output      o_max_hit_hou   ;
output      o_min_hit_sec   ;
output      o_min_hit_min   ;
output      o_min_hit_hou   ;
output      o_max_hit_cnt_sec   ;
output      o_max_hit_cnt_min   ;
output      o_max_hit_cnt_msec    ;
output      o_alarm         ;
output      o_timer         ;

input   [2:0]   i_mode      ;
input   [1:0]   i_position   ;
input   [1:0]   i_world_position;
input      i_sec_clk   ;
input      i_min_clk   ;
input      i_hou_clk   ;
input      i_alarm_sec_clk   ;
input      i_alarm_min_clk   ;
input      i_alarm_hou_clk   ;
input      i_alarm_en   ;
input      i_timer_sec_clk   ;
input      i_timer_min_clk   ;
input      i_timer_hou_clk   ;
input   [1:0]   i_timer_en   ;   
input      i_stwat_sec_clk   ;
input      i_stwat_min_clk   ;
input      i_stwat_msec_clk;
input   [1:0]   i_stwat_en   ;
input      create_hello   ;

input      clk      ;
input      rst_n      ;

parameter   MODE_CLOCK   = 3'b000;
parameter   MODE_SETUP   = 3'b001;
parameter   MODE_ALARM   = 3'b010;
parameter   MODE_WORLD   = 3'b011;
parameter   MODE_TIMER   = 3'b100;
parameter   MODE_STWAT   = 3'b101;
parameter   POS_SEC      = 2'b00   ;
parameter   POS_MIN      = 2'b01   ;
parameter   POS_HOU      = 2'b10   ;
parameter    WOR_USA      = 2'b00   ;
parameter    WOR_ENG      = 2'b01   ;
parameter    WOR_AUS      = 2'b10   ;

//   MODE_CLOCK
wire   [5:0]   sec      ;
wire      max_hit_sec   ;

hms_cnt      u_hms_cnt_sec(
      .o_hms_cnt   ( sec         ),
      .o_max_hit   ( o_max_hit_sec      ),
      .i_max_cnt   ( 6'd59         ),
      .clk      ( i_sec_clk      ),
      .rst_n      ( rst_n         ),
      .create_hello   (create_hello      ));

wire   [5:0]   min      ;
wire      max_hit_min   ;
hms_cnt      u_hms_cnt_min(
      .o_hms_cnt   ( min         ),
      .o_max_hit   ( o_max_hit_min      ),
      .i_max_cnt   ( 6'd59         ),
      .clk      ( i_min_clk      ),
      .rst_n      ( rst_n         ),
      .create_hello   (create_hello      ));

wire   [5:0]   hou      ;
wire      max_hit_hou   ;
hms_cnt      u_hms_cnt_hou(
      .o_hms_cnt   ( hou         ),
      .o_max_hit   ( o_max_hit_hou      ),
      .i_max_cnt   ( 6'd23         ),
      .clk      ( i_hou_clk      ),
      .rst_n      ( rst_n         ),
      .create_hello   (create_hello      ));

//   MODE_ALARM
wire   [5:0]   alarm_sec   ;
hms_cnt      u_hms_cnt_alarm_sec(
      .o_hms_cnt   ( alarm_sec      ),
      .o_max_hit   (          ),
      .i_max_cnt   ( 6'd59         ),
      .clk      ( i_alarm_sec_clk   ),
      .rst_n      ( rst_n         ),
      .create_hello   (create_hello      ));

wire   [5:0]   alarm_min   ;
hms_cnt      u_hms_cnt_alarm_min(
      .o_hms_cnt   ( alarm_min      ),
      .o_max_hit   (          ),
      .i_max_cnt   ( 6'd59         ),
      .clk      ( i_alarm_min_clk   ),
      .rst_n      ( rst_n         ),
      .create_hello   (create_hello      ));

wire	[5:0]		alarm_hou	;
hms_cnt      u_hms_cnt_alarm_hou(
      .o_hms_cnt   ( alarm_hou      ),
      .o_max_hit   (          ),
      .i_max_cnt   ( 6'd23         ),
      .clk      ( i_alarm_hou_clk   ),
      .rst_n      ( rst_n         ),
      .create_hello   (create_hello      ));

//MODE_COUNTDOWN

reg      find_cntdwn   ;

wire   [5:0]   timer_sec   ;

hms_cntdwn   u_hms_cntdwn_timer_sec(
      .o_hms_cnt   ( timer_sec      ),
      .o_min_hit   ( o_min_hit_sec      ),
      .i_max_cnt   ( 6'd59         ),
      .clk      ( i_timer_sec_clk   ),
      .i_cntdwn_mode   ( i_timer_en      ),
      .rst_n      ( rst_n         ),
      .find_cntdwn   ( find_cntdwn      ),
      .create_hello   (create_hello      ));
      
wire   [5:0]   timer_min   ;

hms_cntdwn   u_hms_cntdwn_timer_min(
      .o_hms_cnt   ( timer_min      ),
      .o_min_hit   ( o_min_hit_min      ),
      .i_max_cnt   ( 6'd59         ),
      .clk      ( i_timer_min_clk   ),
      .i_cntdwn_mode   ( i_timer_en      ),
      .rst_n      ( rst_n         ),
      .find_cntdwn   ( find_cntdwn      ),
      .create_hello   (create_hello      ));
      
wire   [5:0]   timer_hou   ;

hms_cntdwn   u_hms_cntdwn_timer_hou(
      .o_hms_cnt   ( timer_hou      ),
      .o_min_hit   ( o_min_hit_hou      ),
      .i_max_cnt   ( 6'd23         ),
      .clk      ( i_timer_hou_clk   ),
      .i_cntdwn_mode   ( i_timer_en      ),
      .rst_n      ( rst_n         ),
      .find_cntdwn   ( find_cntdwn      ),
      .create_hello   (create_hello      ));
      
//MODE COUNT UP
wire   [5:0]   stwat_sec   ;

hms_cntup   u_hms_cnt_stwat_sec(
      .o_hms_cnt   ( stwat_sec      ),
      .o_max_hit   ( o_max_hit_cnt_sec   ),
      .i_max_cnt   ( 6'd59         ),
      .clk      ( i_stwat_sec_clk   ),
      .i_cntup_mode   ( i_stwat_en      ),
      .rst_n      ( rst_n         ),
      .create_hello   (create_hello      ));
            
wire   [5:0]   stwat_min   ;

hms_cntup   u_hms_cnt_stwat_min(
      .o_hms_cnt   ( stwat_min      ),
      .o_max_hit   ( o_max_hit_cnt_min   ),
      .i_max_cnt   ( 6'd59         ),
      .clk      ( i_stwat_min_clk   ),
      .i_cntup_mode   ( i_stwat_en      ),
      .rst_n      ( rst_n         ),
      .create_hello   (create_hello      ));

wire   [6:0]   stwat_msec   ;

hms_cntup   u_hms_cnt_stwat_msec(
      .o_hms_cnt   ( stwat_msec      ),
      .o_max_hit   ( o_max_hit_cnt_msec   ),
      .i_max_cnt   ( 7'd99         ),
      .clk      ( i_stwat_msec_clk   ),
      .i_cntup_mode   ( i_stwat_en      ),
      .rst_n      ( rst_n         ),
      .create_hello   (create_hello      ));

reg   [6:0]   o_sec      ;
reg   [5:0]   o_min      ;
reg   [5:0]   o_hou      ;

always @ (*) begin
   case(i_mode)
      MODE_CLOCK: begin
         o_sec = sec;
         o_min = min;
         o_hou = hou;
      end
      MODE_SETUP: begin
         o_sec = sec;
         o_min = min;
         o_hou = hou;
      end
      MODE_ALARM: begin
         o_sec = alarm_sec;
         o_min = alarm_min;
         o_hou = alarm_hou;
      end
      MODE_WORLD: begin   //MODE OF TIME OF OTHER COUNTRIES
         case(i_world_position)
            WOR_USA : begin   //TIME OF USA --> TIME DIFFERENCE OF 14 HOUR
               o_sec = sec;
               o_min = min;
               o_hou = hou + 6'd14 ;
		          if(o_hou >= 6'd24) begin
			           o_hou <= o_hou - 6'd24 ;
              end
            end
            WOR_ENG : begin   //TIME OF ENGLAND --> TIME DIFFERENCE OF 9 HOUR
               o_sec = sec;
               o_min = min;
               o_hou = hou + 6'd09 ;
		           if(o_hou >= 6'd24) begin
			           o_hou <= o_hou - 6'd24 ;
               end
            end
            WOR_AUS : begin   //TIME OF AUSTRALIA --> TIME DIFFERENCE OF 2 HOUR
               o_sec = sec;
               o_min = min;
               o_hou = hou + 6'd02 ;
		            if(o_hou >= 6'd24) begin
			            o_hou <= o_hou - 6'd24 ;
                end
           end
         endcase
      end
      MODE_TIMER: begin
         o_sec = timer_sec;
         o_min = timer_min;
         o_hou = timer_hou;
         if(((6'd0 == timer_sec) && (6'd0 == timer_min) && (6'd0 == timer_hou)) && (i_timer_en == 2'b10)) begin
            o_sec <= 7'd0;
            o_min <= 6'd0;
            o_hou <= 6'd0;
         end
      end
      MODE_STWAT: begin
         o_sec = stwat_msec;
         o_min = stwat_sec;
         o_hou = stwat_min;
      end
   endcase
end

reg      o_alarm      ;

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

reg      o_timer      ;

always @(posedge clk or negedge rst_n) begin
   if ((rst_n == 1'b0)) begin
      o_timer <= 1'b0;
   end else begin
      if(((6'd0 == timer_sec) && (6'd0 == timer_min) && (6'd0 == timer_hou)) && (i_timer_en == 2'b10)) begin
         o_timer <= 1'b1;
         find_cntdwn <= 1'b1;
      end else begin
         o_timer <= 1'b0 ;
         find_cntdwn <= 1'b0;
      end
   end
end

endmodule


module	buzz(
		o_buzz,
		o_buzz_z,
		i_buzz_en,
		clk,
		rst_n,
		i_buzz_enz);

output		o_buzz		;
output		o_buzz_z		;

input		i_buzz_en	;
input		i_buzz_enz  ;
input		clk		;
input		rst_n		;

parameter	A = 28409	;
parameter	A_s = 26815	;
parameter	A_b = 107258;
parameter	C = 47778	;
parameter	D = 42566	;
parameter	E = 37922	;
parameter	F = 35793	;
parameter	G = 31888	;

wire		clk_bit		;
nco	u_nco_bit(	
		.o_gen_clk	( clk_bit	),
		.i_nco_num	( 25000000	),
		.clk		( clk		),
		.rst_n		( rst_n		));

reg	[6:0]	cnt		;
always @ (posedge clk_bit or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt <= 7'd00;
		end else begin
		if (i_buzz_en == 1'b0) begin
		cnt <= 7'd00;
		end else begin
		if(cnt >= 7'd87) begin
			cnt <= 7'd00;
		end else begin
			cnt <= cnt + 7'd01;
		end
		end
		if (i_buzz_enz == 1'b0) begin
		cnt <= 7'd00;
		end else begin
		if(cnt >= 7'd87) begin
			cnt <= 7'd00;
		end else begin
			cnt <= cnt + 7'd01;
		end
		end
	end
end

reg	[31:0]	nco_num		;
always @ (*) begin
	case(cnt)
		7'd00: nco_num = F	;
		7'd01: nco_num = G	;
		7'd02: nco_num = A	;
		7'd03: nco_num = F	;
		7'd04: nco_num = C/2	;
		7'd05: nco_num = C/2	;
		7'd06: nco_num = C/2	;
		7'd07: nco_num = A	;
		7'd08: nco_num = G	;
		7'd09: nco_num = G	;
		7'd10: nco_num = C/2	;
		7'd11: nco_num = C/2	;
		7'd12: nco_num = G	;
		7'd13: nco_num = G	;
		7'd14: nco_num = F	;
		7'd15: nco_num = D	;
		7'd16: nco_num = A	;
		7'd17: nco_num = A	;
		7'd18: nco_num = A	;
		7'd19: nco_num = F	;
		7'd20: nco_num = E	;
		7'd21: nco_num = E	;
		7'd22: nco_num = 0	;
		7'd23: nco_num = F	;
		7'd24: nco_num = E	;
		7'd25: nco_num = D	;
		7'd26: nco_num = D	;
		7'd27: nco_num = E	;
		7'd28: nco_num = E	;
		7'd29: nco_num = F	;
		7'd30: nco_num = G	;
		7'd31: nco_num = C	;
		7'd32: nco_num = C	;
		7'd33: nco_num = F	;
		7'd34: nco_num = F	;
		7'd35: nco_num = G	;
		7'd36: nco_num = A	;
		7'd37: nco_num = A_s	;
		7'd38: nco_num = A_s	;
		7'd39: nco_num = A_s	;
		7'd40: nco_num = A	;
		7'd41: nco_num = G	;
		7'd42: nco_num = F	;
		7'd43: nco_num = G	;
		7'd44: nco_num = G	;
		7'd45: nco_num = G	;
		7'd46: nco_num = 0	;
		7'd47: nco_num = F	;
		7'd48: nco_num = G	;
		7'd49: nco_num = A	;
		7'd50: nco_num = F	;
		7'd51: nco_num = C/2	;
		7'd52: nco_num = C/2	;
		7'd53: nco_num = C/2	;
		7'd54: nco_num = A	;
		7'd55: nco_num = G	;
		7'd56: nco_num = G	;
		7'd57: nco_num = C/2	;
		7'd58: nco_num = C/2	;
		7'd59: nco_num = G	;
		7'd60: nco_num = G	;
		7'd61: nco_num = F	;
		7'd62: nco_num = D	;
		7'd63: nco_num = D	;
		7'd64: nco_num = E	;
		7'd65: nco_num = F	;
		7'd66: nco_num = C	;
		7'd67: nco_num = C	;
		7'd68: nco_num = C	;
		7'd69: nco_num = 0	;
		7'd70: nco_num = C	;
		7'd71: nco_num = C	;
		7'd72: nco_num = D	;
		7'd73: nco_num = E	;
		7'd74: nco_num = F	;
		7'd75: nco_num = G	;
		7'd76: nco_num = C	;
		7'd77: nco_num = F	;
		7'd78: nco_num = G	;
		7'd79: nco_num = A	;
		7'd80: nco_num = A_s	;
		7'd81: nco_num = A_s	;
		7'd82: nco_num = A_s	;
		7'd83: nco_num = A	;
		7'd84: nco_num = G	;
		7'd85: nco_num = F	;
		7'd86: nco_num = F	;
		7'd87: nco_num = 0	;
		
	endcase
end

wire      buzz      ;
nco   u_nco_buzz(
      .o_gen_clk   ( buzz      ),
      .i_nco_num   ( nco_num   ),
      .clk      ( clk      ),
      .rst_n      ( rst_n      ));

assign      o_buzz = buzz & (i_buzz_en || i_buzz_enz) ;

endmodule


/*
module fnd_dec_2(
o_seg,
i_num);

output [6:0] o_seg;

input [3:0] i_num;
reg [6:0] o_seg;

always @(i_num) begin
case(i_num)
 4'd0:   o_seg = 7'b000_0000; 
 4'd1:   o_seg = 7'b011_0111; 
 4'd2:   o_seg = 7'b100_1111; 
 4'd3:   o_seg = 7'b000_1110; 
 4'd4:   o_seg = 7'b000_1110; 
 4'd5:   o_seg = 7'b111_1110; 
default:o_seg = 7'b000_0000; 

WAtCH
 4'd0:   o_seg = 7'b011_1110; 
 4'd1:   o_seg = 7'b011_1110; 
 4'd2:   o_seg = 7'b111_0111; 
 4'd3:   o_seg = 7'b000_1111; 
 4'd4:   o_seg = 7'b100_1110; 
 4'd5:   o_seg = 7'b011_0111; 
default:o_seg = 7'b000_0000; 
endcase
end
endmodule
*/

module   top(
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
      i_sw6,
      clk,
      rst_n);

output   [5:0]   o_seg_enb   ;
output      o_seg_dp   ;
output   [6:0]   o_seg      ;
output      o_alarm      ;

input      i_sw0      ;
input      i_sw1      ;
input      i_sw2      ;
input      i_sw3      ;
input      i_sw4      ;
input      i_sw5      ;
input      i_sw6      ;
input      clk      ;
input      rst_n      ;

wire      max_hit_min   ;
wire      max_hit_sec   ;
wire      max_hit_hou   ;

wire      min_hit_min   ;
wire      min_hit_sec   ;
wire      min_hit_hou   ;

wire      max_hit_cnt_min   ;
wire      max_hit_cnt_sec   ;
wire      max_hit_cnt_msec;

wire      hou_clk      ;
wire      min_clk      ;
wire      sec_clk      ;

wire      alarm_en   ;
wire      alarm_min   ;
wire      alarm_sec   ;
wire      alarm_hou   ;
wire   [1:0]   timer_en   ;
wire      timer_min   ;
wire      timer_sec   ;
wire      timer_hou   ;
wire   [1:0]   stwat_en   ;
wire      stwat_min   ;
wire      stwat_sec   ;
wire      stwat_msec   ;

wire   [1:0]   position   ;
wire   [2:0]   mode      ;
wire   [1:0]   world_position   ;


wire      start_clk   ;
nco      start_nco(
      .o_gen_clk   ( start_clk   ),
      .i_nco_num   ( 32'd50000000   ),
      .clk      ( clk      ),
      .rst_n      ( rst_n      ));

reg   [3:0]   before_clk   ;
reg      create_hello   ;

always @(posedge start_clk or negedge rst_n) begin
   if(rst_n == 1'b0) begin
      before_clk <= 4'b0;
   end else begin
      if(before_clk < 4'd10) begin
         before_clk <= before_clk + 4'b1 ;
         create_hello <= 1'b0   ;
      end else begin
         before_clk <= 4'd10   ;
         create_hello <= 1'b1   ;
      end
   end
end


controller u_ctrl (
         .o_mode         ( mode         ),
         .o_position      ( position      ),
         .o_world_position   ( world_position   ),
         .o_alarm_en      ( alarm_en      ),
         .o_timer_en      ( timer_en      ),
         .o_stwat_en      ( stwat_en      ),
         .o_sec_clk      ( sec_clk      ),
         .o_min_clk      ( min_clk      ),
         .o_hou_clk      ( hou_clk      ),
         .o_alarm_sec_clk   ( alarm_sec      ),
         .o_alarm_min_clk   ( alarm_min      ),
         .o_alarm_hou_clk   ( alarm_hou      ),
         .o_timer_sec_clk   ( timer_sec      ),
         .o_timer_min_clk   ( timer_min      ),
         .o_timer_hou_clk   ( timer_hou      ),
         .o_stwat_msec_clk   ( stwat_msec      ),
         .o_stwat_sec_clk   ( stwat_sec      ),
         .o_stwat_min_clk   ( stwat_min      ),
         .i_max_hit_sec      ( max_hit_sec      ),
         .i_max_hit_min      ( max_hit_min      ),
         .i_max_hit_hou      ( max_hit_hou      ),
         .i_min_hit_sec      ( min_hit_sec      ),
         .i_min_hit_min      ( min_hit_min      ),
         .i_min_hit_hou      ( min_hit_hou      ),
         .i_max_hit_cnt_msec   ( max_hit_cnt_msec   ),
         .i_max_hit_cnt_sec   ( max_hit_cnt_sec   ),
         .i_max_hit_cnt_min   ( max_hit_cnt_min   ),
         .i_sw0         ( i_sw0         ),
         .i_sw1         ( i_sw1         ),
         .i_sw2         ( i_sw2         ),
         .i_sw3         ( i_sw3         ),
         .i_sw4         ( i_sw4         ),
         .i_sw5         ( i_sw5         ),
         .i_sw6         ( i_sw6         ),
         .clk         ( clk         ),
         .rst_n         ( rst_n         ));

wire   [5:0]   min      ;
wire   [6:0]   sec      ;
wire   [5:0]   hou      ;

wire      buzz      ;
wire      buzz_z      ; 

houminsec u_houminsec (
         .o_sec         ( sec         ),
         .o_min         ( min         ),
         .o_hou         ( hou         ),
         .o_max_hit_sec      ( max_hit_sec      ),
         .o_max_hit_min      ( max_hit_min      ),
         .o_max_hit_hou      ( max_hit_hou      ),
         .o_min_hit_sec      ( min_hit_sec      ),
         .o_min_hit_min      ( min_hit_min      ),
         .o_min_hit_hou      ( min_hit_hou      ),
         .o_max_hit_cnt_msec   ( max_hit_cnt_msec   ),
         .o_max_hit_cnt_sec   ( max_hit_cnt_sec   ),
         .o_max_hit_cnt_min   ( max_hit_cnt_min   ),
         .o_alarm      ( buzz         ),
         .o_timer      ( buzz_z      ),
         .i_mode         ( mode         ),
         .i_position      ( position      ),
         .i_world_position   ( world_position   ),
         .i_sec_clk      ( sec_clk      ),
         .i_min_clk      ( min_clk      ),
         .i_hou_clk      ( hou_clk      ),
         .i_alarm_sec_clk   ( alarm_sec      ),
         .i_alarm_min_clk   ( alarm_min      ),
         .i_alarm_hou_clk   ( alarm_hou      ),
         .i_alarm_en      ( alarm_en      ),
         .i_timer_sec_clk   ( timer_sec      ),
         .i_timer_min_clk   ( timer_min      ),
         .i_timer_hou_clk   ( timer_hou      ),
         .i_timer_en      ( timer_en      ),
         .i_stwat_en      ( stwat_en      ),
         .i_stwat_msec_clk   ( stwat_msec      ),
         .i_stwat_sec_clk   ( stwat_sec      ),
         .i_stwat_min_clk   ( stwat_min      ),
         .clk         ( clk         ),
         .rst_n         ( rst_n         ),
         .create_hello      ( create_hello      ));

buzz   u_buzz(
         .o_buzz      ( o_alarm   ),
         .i_buzz_en   ( buzz      ),
         .clk      ( clk      ),
         .rst_n      ( rst_n      ),
         .i_buzz_enz   ( buzz_z   ));

wire   [3:0]   sec_left_num   ;
wire   [3:0]   sec_right_num   ;
wire   [6:0]   sec_left   ;
wire   [6:0]   sec_right   ;

wire   [41:0]  six_digit_seg_1 ;

generate_hello u_generate_hello(
         .before_clk   ( before_clk   ),
         .o_six_digit_seg( six_digit_seg_1));

double_fig_sep   u0_dfs(
         .o_left      ( sec_left_num   ),
         .o_right   ( sec_right_num   ),
         .i_double_fig   ( sec      ));
   
fnd_dec   u0_fnd_dec(
         .o_seg      ( sec_left   ),
         .i_num      ( sec_left_num   ));

fnd_dec   u1_fnd_dec(
         .o_seg      ( sec_right   ),
         .i_num      ( sec_right_num   ));

wire   [3:0]   min_left_num   ;
wire   [3:0]   min_right_num   ;
wire   [6:0]   min_left   ;
wire   [6:0]   min_right   ;

double_fig_sep   u1_dfs(
         .o_left      ( min_left_num   ),
         .o_right   ( min_right_num   ),
         .i_double_fig   ( min      ));

fnd_dec   u2_fnd_dec(
         .o_seg   ( min_left   ),
         .i_num   ( min_left_num   ));

fnd_dec   u3_fnd_dec(
         .o_seg   ( min_right   ),
         .i_num   ( min_right_num   ));

wire   [3:0]   hou_left_num   ;
wire   [3:0]   hou_right_num   ;
wire   [6:0]   hou_left   ;
wire   [6:0]   hou_right   ;

double_fig_sep   u2_dfs(
         .o_left      ( hou_left_num   ),
         .o_right   ( hou_right_num   ),
         .i_double_fig   ( hou      ));

fnd_dec   u4_fnd_dec(
         .o_seg      ( hou_left   ),
         .i_num      ( hou_left_num   ));
   
fnd_dec   u5_fnd_dec(
         .o_seg      ( hou_right   ),
         .i_num      ( hou_right_num   ));

wire   [41:0]   six_digit_seg_2   ;
assign      six_digit_seg_2 = {hou_left,hou_right,min_left,min_right,sec_left,sec_right};

wire   [41:0]   real_six_digit_seg_2   ;
wire   [5:0]   six_dp         ;    

blink   u_blink(  
         .i_mode      ( mode         ),
         .i_position   ( position      ),
         .i_six_digit_seg( six_digit_seg_2   ),
         .o_six_digit_seg( real_six_digit_seg_2   ),
         .clk      ( clk         ),
         .rst_n      ( rst_n         ),
         .o_six_dp   ( six_dp      ),
         .i_alarm_en   ( alarm_en      ),
         .create_hello   ( create_hello      ));

wire  [41:0]   real_six_digit_seg_1     ;
   
startblink u_startblink(  
                   .i_six_digit_seg( six_digit_seg_1   ),
                   .o_six_digit_seg( real_six_digit_seg_1  ),
                   .clk      (clk         ),
                   .rst_n      (rst_n         ),
                   .create_hello(create_hello));

wire [41:0] dis_world_name ;

world_name u_world_name(
                      .i_world_position(world_position),
                      .o_world_name(dis_world_name),
                      .i_mode(mode));
        
led_disp   u_led_disp (
         .o_seg      ( o_seg         ),
         .o_seg_dp   ( o_seg_dp      ),
         .o_seg_enb   ( o_seg_enb      ),
         .i_six_digit_seg_1(real_six_digit_seg_1 ),
         .i_six_digit_seg_2(real_six_digit_seg_2   ),
         .i_six_dp   ( six_dp      ),
         .clk      ( clk         ),
         .rst_n      ( rst_n         ),
			   .create_hello ( create_hello	),
			   .i_world_name (dis_world_name),
			   .i_mode(mode),
			   .i_world_position(world_position));

endmodule
