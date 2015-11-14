`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

module TB_ControlPID;

	// Inputs
	reg [7:0] y_k_i;
	reg clk_i;
	reg dataf_i;
	reg reset;
	reg [7:0] coeff_1;
	reg [7:0] coeff_2;
	reg [7:0] coeff_3;
	reg [7:0] ref_i;

	// Outputs
	wire dataf_oo;
	wire [15:0] servo_o;

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
		coeff_1 = 8'b00010010;   // 18
		coeff_2 = 8'b00000111;  //   7
		coeff_3 = 8'b10010110; //  150   // 8 bits no da para los bits de signo 
		ref_i = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

