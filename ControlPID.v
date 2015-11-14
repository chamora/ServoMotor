`timescale 1ns / 1ps

module ControlPID(dataf_oo,y_k_i,clk_i,dataf_i,reset,coeff_1,coeff_2,coeff_3, ref_i, servo_o
    );
	 
	 parameter WIDTH=12;
	 input wire clk_i;
	 input wire reset;
	
	 //input wire [11:0] arduino_i;
	 //output wire [11:0] LEDS_o;
	 //reg [11:0] intermedio, intermedio2;
	
	 reg dataf_o;
	 input wire dataf_i;
	 output wire dataf_oo;
	 output wire signed [WIDTH-1:0] servo_o;

	 input wire [WIDTH-1:0] y_k_i;
	 input signed [WIDTH-1:0] ref_i;
	 

	 input wire signed [WIDTH-1:0] coeff_1;
	 input wire signed [WIDTH-1:0] coeff_2;
	 input wire signed [WIDTH-1:0] coeff_3;
	 
	 
	 ////Asigno las salidas del sistema 
	 assign dataf_oo=dataf_o;
	 assign servo_o=Reg_servo;  ///Me estaba dando problemas 

	 //////////////////////////////////////registros////////////////////////////////////
	 wire overflow1, underflow1,overflow2,underflow2,overflow3,underflow3, overflow_mult, underflow_mult,overflowsum,underflowsum ;
	 reg signed [WIDTH-1:0] Regy_k_1,Regy_k,Reg_ref,Reg_servo;
	 reg signed [WIDTH-1:0]Reg_p,Reg_I,Reg_I_1,Reg_D,Reg_I_P;
	  
	 reg [1:0] muxselect1;
	 reg  muxselect2;
	 wire signed [2*WIDTH-1:0] result_mult_temp;
	 wire signed [WIDTH-1:0] result_res1,result_res2,result_mult,result_res3, result_res3_2, result_res2_2, result_res1_2, result_sum_t,result_sum;
	 //////////////////salida mux/////////////////
	 wire signed [WIDTH-1:0]out1,out2,out3,out4;  
	 /////////////////////////////////////////////
	 
	 //Module Arithmetic operation RESTA1
	 assign result_res1_2=  Regy_k-Regy_k_1;
	 //Module Arithmetic operation RESTA2
	 assign result_res2_2=  Reg_ref-Regy_k;
	 //Module Arithmetic operation RESTA Salida
	 assign result_res3_2=  out3-out4; //	 
	 //Module Arithmetic operation multiplicacion
	 assign result_mult_temp=  out1*out2;
	 ////////Module Arimetric SUMA ///////////////////
	 assign result_sum_t=result_mult+Reg_I_1;
	 ////////****************************************************************************************************///////////
	 //Module Arithmetic operation SALIDA RESTADOR 1/////////////////////////////////////////////////////
	 assign overflow1 = (~Regy_k[WIDTH-1]&Regy_k_1[WIDTH-1]&result_res1_2[WIDTH-1]) ? 1'b1  :  1'b0;
	 assign underflow1 = (Regy_k[WIDTH-1]&~Regy_k_1[WIDTH-1]&~result_res1_2[WIDTH-1]) ? 1'b1  :  1'b0;
	 //******************************OVER Y UNDER**********************************//
	 assign result_res1= (overflow1)  ? (12'sb011111111111) :
							   (underflow1) ? (12'sb111111111111) :
							   $signed(result_res1_2);	
	//**************************************************************************************************************///////	 
	 //Module Arithmetic operation TRUNCAMIENTO PARA SALIDA RESTADOR 2/////////////////////////////////////////////////////
	  assign overflow2 = (~Reg_ref[WIDTH-1]&Regy_k[WIDTH-1]&result_res2_2[WIDTH-1]) ? 1'b1  :  1'b0;
	 assign underflow2 = (Reg_ref[WIDTH-1]&~Regy_k[WIDTH-1]&~result_res2_2[WIDTH-1]) ? 1'b1  :  1'b0;
	 //******************************OVER Y UNDER**********************************//
	 assign result_res2= (overflow2)  ? (12'sb011111111111) :
							   (underflow2) ? (12'sb111111111111) :
							   $signed(result_res2_2);	
	 //Module Arithmetic operation TRUNCAMIENTO PARA SALIDA MULTIPLICADOR
	 assign overflow_mult = (~result_mult_temp[2*WIDTH-1] & |result_mult_temp[2*WIDTH-2:2*WIDTH-12]) ? 1'b1  :  1'b0;
	 assign underflow_mult = (result_mult_temp[2*WIDTH-1] & ~(&result_mult_temp[2*WIDTH-2:2*WIDTH-12])) ? 1'b1  :  1'b0;
	 ////////////****************trunc mult*********************///////////
	 assign result_mult= (overflow_mult) ?  (12'sb011111111111) :
							   (underflow_mult) ? (12'sb111111111111) :
						    	$signed({result_mult_temp[2*WIDTH-1],result_mult_temp[2*WIDTH-14:2*WIDTH-24]});//asigna al truncamiento los menos significativos	
	 
	 //Module Arithmetic operation TRUNCAMIENTO PARA SALIDA PRIMER RESTA FINAL////////////////////////////////////
	 assign overflow3 = (~out3[WIDTH-1]&out4[WIDTH-1]&result_res3_2[WIDTH-1]) ? 1'b1  :  1'b0;
	 assign underflow3 = (out3[WIDTH-1]&~out4[WIDTH-1]&~result_res3_2[WIDTH-1]) ? 1'b1  :  1'b0;
	 //******************************OVER Y UNDER**********************************//
	 assign result_res3= (overflow3)  ? (12'sb011111111111) :
							   (underflow3) ? (12'sb111111111111) :
							   $signed(result_res3_2);	
								
	////////****************************************************************************************************///////////
	 //Module Arithmetic operation SUMA/////////////////////////////////////////////////////
	 assign overflowsum = (~result_mult[WIDTH-1]&~Reg_I_1[WIDTH-1]&result_sum_t[WIDTH-1]) ? 1'b1  :  1'b0;
	 assign underflowsum = (result_mult[WIDTH-1]&Reg_I_1[WIDTH-1]&~result_sum_t[WIDTH-1]) ? 1'b1  :  1'b0;
	 //******************************OVER Y UNDER**********************************//
	 assign result_sum= (overflowsum)  ? (12'sb011111111111) :
							   (underflowsum) ? (12'sb111111111111) :
							   $signed(result_sum_t);	
	//**************************************************************************************************************///////	 
	 
	 /////////////////////////////////////////////////////////////////////////////////////////////////////////////	 
	 //////////////////////////MUXES///////////////////////////////
	assign out1= (muxselect1==2'b10) ? result_res1:
					  (muxselect1==2'b00) ? Regy_k:
					  (muxselect1==2'b01) ? result_res2:					 
					   12'sb0;
	 //////////////////////////MUXES///////////////////////////////
	assign out2= (muxselect1==2'b10) ? coeff_1:
					  (muxselect1==2'b00) ? coeff_2:
					  (muxselect1==2'b01) ? coeff_3:					 
					   12'sb0;
	//////////////////////////MUXES///////////////////////////////	
	assign out3= (muxselect2==1'b0) ? Reg_I:
					 (muxselect2==1'b1) ? Reg_I_P:					    					 
					  12'sb0;
   //////////////////////////MUXES///////////////////////////////	
	assign out4= (muxselect2==1'b0) ? Reg_p:
					  (muxselect2==1'b1) ? Reg_D:					    					 
					   12'sb0;
						
	/////////////////////////Parameter////////////////////////////
	
	 reg [3:0] state_reg, state_next;
	 
		localparam[3:0]
		state_start=4'b0000, 
		state_y_k=4'b0001, state_P1=4'b0010,
		state_P2=4'b0011,  state_I1=4'b0100,
		state_I2=4'b0101, state_D1=4'b0110, 
		state_D2=4'b0111, state_servo=4'b1000, state_Reg=4'b1001,
		state_s1=4'b1010, state_s2=4'b1011,
		state_s3=4'b1100, state_s4=4'b1101,
		state_s5=4'b1110, state_reset=4'b1111;
	//////////////////////////////////////////////////////////////
	
always @(posedge clk_i,posedge reset) 
			begin 
				if(reset)
					begin
						state_reg <=state_reset;
					end
				else
					state_reg  <= state_next;
			end	
	///////////////////////STATE MACHINE//////////////////////////
	always @* 
			begin
					//state_reg=state_next;
					state_next=state_reg;
					case(state_reg)
						state_reset: 
							begin
								dataf_o=1'b0;
								Reg_servo=12'b0;
								
								Reg_p=12'b0;
								Reg_I=12'b0;
								Reg_I_1=12'b0;
								Reg_D=12'b0;
								Reg_I_P=12'b0;
								
                        Regy_k=12'b0;
								Regy_k_1=12'b0;
								Reg_ref=ref_i;
								
								state_next=state_start;
							end					
						state_start: 
							begin
								dataf_o=1'b0;
								
								muxselect1=2'b00;
								muxselect2=1'b0;
								
								if(dataf_i)
									state_next=state_y_k;
								else
									state_next=state_start;
							end
						state_y_k:
							begin
								Regy_k=y_k_i;//MArcos....
								muxselect1=2'b00;
								
								state_next=state_P1;
							end
						state_P1:
							begin
								muxselect1=2'b00; // este estado no hace ni merga
								
								state_next=state_P2;
							end
						state_P2:
							begin
								Reg_p=result_mult;

								state_next=state_I1;
							end
						state_I1:
							begin
								muxselect1=2'b01;
								
								state_next=state_I2;
							end

						state_I2:
							begin
								Reg_I=result_sum;
								
								state_next=state_s1;
							end
						state_D1:
							begin
								muxselect2=1'b1;
								muxselect1=2'b10;
								
								state_next=state_D2;
							end
						state_D2:
							begin

								Reg_D=result_mult;

								state_next=state_servo;
							end
						state_servo:
							begin
								Reg_servo=result_res3;

								state_next=state_Reg;
							end
						state_Reg:
							begin
								dataf_o=1'b1;
								
                        Regy_k_1=Regy_k;
								Reg_I_1=Reg_I;
								
								
								state_next=state_start;
							end
						state_s1:
							begin
								Reg_I_P=result_res3;

								state_next=state_D1;
							end
						state_s2:
							begin

								state_next=state_start;
							end
						state_s3:
							begin

								state_next=state_start;
							end
							
						state_s4:
							begin

								state_next=state_start;
							end
						state_s5:
							begin
							
								state_next=state_start;
							end
					default state_next=state_start;
					endcase
			end
	
	//MARCOS ASIGNE LA ENTRADA Y_K EN EL REGISTRO REG_Y_K Y TAMBIEN LA ENTRADA DE REFERENCIA METERLA EN UN REGISTRO
	
	
endmodule 