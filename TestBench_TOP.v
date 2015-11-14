`timescale 1ns / 1ps
module TestBench_TOP;

	// Inputs
	reg clk_i;
	reg reset;
	reg [11:0] ADC_i;
	reg dataf_i;
	reg [11:0] ref_i;
	reg [11:0] v_mem [0:4];
	// Outputs
	wire PWM_o;
	wire [11:0] LEDS_o;
	integer i;
	// Instantiate the Unit Under Test (UUT)
	Top uut (
		.clk_i(clk_i), 
		.reset(reset), 
		.ADC_i(ADC_i), 
		.PWM_o(PWM_o), 
		.dataf_i(dataf_i), 
		.ref_i(ref_i), 
		.LEDS_o(LEDS_o)
	);

	initial begin
		// Initialize Inputs
		clk_i = 0;
		reset = 0;
		ADC_i = 0;
		dataf_i = 0;
		ref_i = 0;

		// Wait 100 ns for global reset to finish
		#100;
		ref_i=12'b000000001010;
      reset=1;  
		#50;
		reset=0;
		$readmemb("Datos_pruebas_I_PD.txt",v_mem);
		for (i=0;i<6;i=i+1)
		begin 
		ADC_i=v_mem[i];
		dataf_i=1;
		#4;
		dataf_i=0;
		#100000;
		end
		// Add stimulus here
		

	end
      initial forever #1 clk_i=~clk_i;
endmodule

