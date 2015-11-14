`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:46:00 10/18/2015 
// Design Name: 
// Module Name:    dff 
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
module dff(
    input wire D,
    input wire clk,
    input wire  rst,
    output reg Q
    );
 
always @ (posedge(clk), posedge(rst))
begin
    if (rst == 1)
        Q <= 1'b0;
    else
            Q <= D;
end
endmodule 