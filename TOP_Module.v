`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 

//////////////////////////////////////////////////////////////////////////////////
module TOP_Module(Datos,rst,clk, Sennal_Salida
    );
input rst,clk;	 
input wire [11:0] Datos;
output wire Sennal_Salida;

wire CLK;
wire [11:0] out;
//reg [11:0] registro;

//assign out= {1'b0,Datos[10:0]};


/*if (bandera)
begin
assign Datos=registro;
end*/

Frec_Divider Divisor (
.clk(clk),
.rst(rst),
.a_PWM(CLK)
);

voyaverquehagoconelPWM PWM (
.clk(CLK),
.rst(rst),
.compare(Datos),
.pwm_out(Sennal_Salida)
);


/*always @*
begin
registro=Sennal_Salida;
end
*/
endmodule
