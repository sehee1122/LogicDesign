# Lab_10

## 실습 내용

### **IR Controller**

> Practice 09 - IR 리모컨을 눌렀을 때, 24비트 데이터가 전달되도록 설계
	: Cable Connection & Pin Planner
``` verilog
//	--------------------------------------------------
//	Top Module
//	--------------------------------------------------
module	top(
		o_seg_enb,
		o_seg_dp,
		o_seg,
		i_ir_rxb,
		clk,
		rst_n);

output	[5:0]	o_seg_enb	;
output		o_seg_dp	;
output	[6:0]	o_seg		;

input		i_ir_rxb	;
input		clk		;
input		rst_n		;

wire	[31:0]	data		;

ir_rx		u_ir(	
		.o_data		( data		),
		.i_ir_rxb	( i_ir_rxb	),
		.clk		( clk		),
		.rst_n		( rst_n		));

wire	[6:0]	seg_0		;
wire	[6:0]	seg_1		;
wire	[6:0]	seg_2		;
wire	[6:0]	seg_3		;
wire	[6:0]	seg_4		;
wire	[6:0]	seg_5		;

fnd_dec		u_fnd_dec_0(
		.o_seg		( seg_0		),
		.i_num		( data [3:0]	));

fnd_dec		u_fnd_dec_1(
		.o_seg		( seg_1		),
		.i_num		( data [7:4]	));

fnd_dec		u_fnd_dec_2(
		.o_seg		( seg_2		),
		.i_num		( data [11:8]	));

fnd_dec		u_fnd_dec_3(
		.o_seg		( seg_3		),
		.i_num		( data [15:12]	));

fnd_dec		u_fnd_dec_4(
		.o_seg		( seg_4		),
		.i_num		( data [19:16]	));

fnd_dec		u_fnd_dec_5(
		.o_seg		( seg_5		),
		.i_num		( data [23:20]	));

wire	[41:0]	six_digit_seg	;
assign		six_digit_seg = { seg_5, seg_4, seg_3, seg_2, seg_1, seg_0 };

led_disp	u_led_disp(
		.o_seg		( o_seg		),
		.o_seg_dp	( o_seg_dp	),
		.o_seg_enb	( o_seg_enb	),
		.i_six_digit_seg( six_digit_seg	),
		.i_six_dp	( i_six_dp 	),
		.clk		( clk		),
		.rst_n		( rst_n		));

endmodule
```

#### **Intro** 
	: nco, fnd_dec, double_fig_sep, led_disp, ir_rx module 

#### **Submodule 1_Module nco** 
	: Numerical Controlled Oscillator
	: Hz of o_gen_clk = Clock Hz / num 으로
	  input인 clock을 50MHz, output인 general clock을 1MHz로 지정

#### **Submodule 2_Module fnd_dec** 
	:  Flexible Numerical Display Decoder
	: output인 segment를 7 bit로 나눔 (a, b, c, d, e, f, g)
	: o_seg의 각 4'dn (n은 0 이상 15 이하의 정수)에 7 - Segment Display를 나타냄
	: 4'd10 ~ 4'd15 사이는 16진법을 고려하여 알파벳 순서대로 나타내도록 함
	: n = 10, 12, 14, 15인 경우는 대문자, n = 11, 13인 경우는 소문자 (-> A, b, C, d, E, F)

#### **Submodule 3_Module double_fig_sep** 
	:  0~59 -> 2 Separated Segments
	: output의 left는 input인 double_fig의 몫을 나타냄 (-> o_left = i_double_fig / 10; )
	: output의 right는 input인 double_fig의 나머지를 나타냄 (-> o_right = i_double_fig % 10; )

#### **Submodule 4_Module led_disp** 
	:  0~59 -> 2 Separated Segments
	: 초가 적당한 시간대에 일정하게 증가하도록 nco_num 값 할당
#####	01) o_seg_enb
	: 시, 분, 초를 나타내는 세그먼트 활성화 부분이 각각 2개씩 존재
	: 6 bit로 지정하여 기본값은 전류가 흐르지 않도록 고정된 default값 설정 (-> o_seg_enb = 6'b111111; )
#####	02) o_seg_dp
	: 각 6자리 부분 오른쪽 아래에 display point 존재
	: o_seg_enb와 동일한 수를 가짐
#####	03) o_seg
	: 6 자리의 각 부분에 할당된 7 bit의 on/off 부분
	: input인 six_digit_segment의 7 bit와 동일한 크기로, o_seg_enb의 하위 변수

#### **Submodule 5_Module ir_rx** 
	:  IR Rx Module: Note : Inverted IR Rx Signal
	: wave가 시작되는 초기에 9ms를 high, 4.5ms를 low로 설정하면 이후 정상 작동 (-> LEADCODE)
	: IDLE = 2'b00; LEADCODE = 2'b01; DATACODE = 2'b10; COMPLETE = 2'b11; (-> parameter 설정)
	: 1M Clock = 1 us Reference Time, 순차적인 Rx bits 고려
	: count signal의 high & low, state machine, 32 bit custom & data code

#### **Top Module** 
	: Top Block Diagram

> IR Controller_Pin Planner
![](https://github.com/sehee1122/LogicDesign/blob/master/Practice10/figure/10-5_IR%20Controller.%20Pin%20Planner%20(19-11-26).png)

> IR Controller_RTL Viewer
![](https://github.com/sehee1122/LogicDesign/blob/master/Practice10/figure/10-6_IR%20Controller.%20RTL%20Viewer%20(19-11-26).png)

## 결과
### **Top Module 의 DUT/TestBench Code 및 Waveform 검증**

![](https://github.com/sehee1122/LogicDesign/blob/master/Practice10/figure/10-1_IR%20Controller.%20Wave%20(19-11-26).png)
![](https://github.com/sehee1122/LogicDesign/blob/master/Practice10/figure/10-2_IR%20Controller.%20Wave%20(19-11-26).png)
![](https://github.com/sehee1122/LogicDesign/blob/master/Practice10/figure/10-3_IR%20Controller.%20Wave%20(19-11-26).png)
![](https://github.com/sehee1122/LogicDesign/blob/master/Practice10/figure/10-4_IR%20Controller.%20Wave%20(19-11-26).png)

### **FPGA 동작 사진 - IR Controller 각 버튼의 수신 값 중 전원 버튼 value: 0xFD00FF**

![](https://github.com/sehee1122/LogicDesign/blob/master/Practice10/figure/10-7_IR%20Controller.%20FPGA%20(19-11-26).jpg)


