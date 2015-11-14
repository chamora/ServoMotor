`timescale 1ns / 1ps

module ADC_arduino(arduino_i, reset, clk_i, LEDS_o, dataf_i, dataf_o
    );
	input reset, clk_i;
	input wire dataf_i;
	
	output wire dataf_o;
	
	input wire [11:0] arduino_i;
	output wire [11:0] LEDS_o;
	
	reg [11:0] intermedio, intermedio2;
	reg intermedio3;
	
	assign LEDS_o=intermedio;
	assign dataf_o=intermedio3;
	
	always @(posedge clk_i,posedge reset) 
			begin  
				if(reset)
					begin
						intermedio2=12'b111111111111;
					end
				else
					begin
					intermedio3=dataf_i;
					intermedio=arduino_i;
					end
			end	
endmodule 