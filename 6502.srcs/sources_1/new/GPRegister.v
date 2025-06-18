`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2025 09:28:04 PM
// Design Name: 
// Module Name: GPRegister
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


module GPRegister(
    input clk,
    inout [7:0] bus,
    input load,
    input bus_en
);
    reg [7:0] data;
    assign bus = bus_en ? data : 8'bz;
    always @ (*) if (load) data <= bus;
endmodule
