`timescale 1ns / 1ps
module Test_bench_Control_I_PD;

	// Inputs
	reg [11:0] y_k_i;
	reg clk_i;
	reg dataf_i;
	reg reset;
	reg [11:0] coeff_1;
	reg [11:0] coeff_2;
	reg [11:0] coeff_3;
	reg [11:0] ref_i;
	reg [11:0] v_mem [0:4];
	// Outputs
	wire dataf_oo;
	wire [11:0] servo_o;
	integer i;
	// Instantiate the Unit Under Test (UUT)
	ControlPID uut (
		.dataf_oo(dataf_oo), 
		.y_k_i(y_k_i), 
		.clk_i(clk_i), 
		.dataf_i(dataf_i), 
		.reset(reset), 
		.coeff_1(coeff_1), 
		.coeff_2(coeff_2), 
		.coeff_3(coeff_3), 
		.ref_i(ref_i), 
		.servo_o(servo_o)
	);

	initial begin
		// Initialize Inputs
		y_k_i = 0;
		clk_i = 0;
		dataf_i = 0;
		reset = 0;
		coeff_1 = 12'b000000000010;
		coeff_2 = 12'b000000000100;
		coeff_3 = 12'b000000000110;
		ref_i=12'b000000001010;
      #100;

      reset=1;  
		#5;
		reset=0;
		$readmemb("Datos_pruebas_I_PD.txt",v_mem);
		for (i=0;i<6;i=i+1)
		begin 
		y_k_i=v_mem[i];
		dataf_i=1;
		#4;
		dataf_i=0;
		#30;
		end  

	end
    initial forever #1 clk_i=~clk_i;  
endmodule

