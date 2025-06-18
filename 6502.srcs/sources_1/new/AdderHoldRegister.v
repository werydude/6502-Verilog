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
    input bus7_en,
    input bus06_en,
    output [7:0] addr,
    output [7:0] bus
);
    reg [6:0] data06;
    reg data7;
    assign bus  = {(bus7_en ? data7 : 1'bz), (bus06_en ? data06 : 7'bz)};
    assign addr = addr_en ? {data7, data06} : 8'bz;
    always @(negedge clk) {data7, data06} <= alu_res;
endmodule
