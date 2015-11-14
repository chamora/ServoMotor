`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:57:26 11/13/2015 
// Design Name: 
// Module Name:    Top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Top(clk_i, reset, ADC_i, PWM_o, dataf_i, ref_i, LEDS_o
    );
	parameter WIDTH=12;
	input clk_i, reset;
	input [WIDTH-1:0] ADC_i;
	input dataf_i;
	output PWM_o;
	input [WIDTH-1:0] ref_i;
	output wire [WIDTH-1:0] LEDS_o;
	
	assign LEDS_o=ADC_i;
	wire dataf_int1;
	wire [WIDTH-1:0] datos1, datos2;
	reg banderainutil1;
	///Coeff p= 288 = 000100100000
	// coeff i = 112= 000001110000
	/// coef d =2400= 100101100000
	
	ControlPID ins1(.dataf_oo(),.y_k_i(datos1),.clk_i(clk_i),.dataf_i(dataf_int1),.reset(reset),.coeff_1(12'b000100100000),.coeff_2(12'b000001110000),.coeff_3(12'b100101100000), .ref_i(ref_i), .servo_o(datos2));
	TOP_Module ins2(.Datos(datos2),.rst(reset),.clk(clk_i), .Sennal_Salida(PWM_o));
	ADC_arduino ins3(.arduino_i(ADC_i), .reset(reset), .clk_i(clk_i), .LEDS_o(datos1), .dataf_i(dataf_i), .dataf_o(dataf_int1));
		
endmodule
