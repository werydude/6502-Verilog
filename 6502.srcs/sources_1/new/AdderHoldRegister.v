`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2025 01:34:53 PM
// Design Name: 
// Module Name: AdderHoldRegister
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


module AdderHoldRegister(
    input clk,
    input [7:0] alu_res,
    input addr_en,
    input bus_en,
    output [7:0] addr,
    output [7:0] bus
);
    reg [7:0] data;
    assign bus  = bus_en ? data : 8'bz;
    assign addr = addr_en ? data : 8'bz;
    always @(posedge clk) data <= alu_res;
endmodule
