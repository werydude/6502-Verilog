`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2025 09:30:50 AM
// Design Name: 
// Module Name: AddrReg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module AddrReg(
    input clk,
    input load,
    input [7:0] bus,
    output [7:0] addr
);
    reg [7:0] data;
    assign addr = data;
    //always @ (posedge clk) if (load) data <= bus;
    always @ (posedge clk) data <= bus; // TEMP
endmodule
