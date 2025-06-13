`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2025 08:43:21 PM
// Design Name: 
// Module Name: ALURegisterA
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


module ALURegisterA(
    input clk,
    input [7:0] bus,
    input load,
    input zero,
    output [7:0] out
);
    reg [7:0] data;
    assign out = data;
    always @ (posedge clk) begin
        if (load) data <= bus;
        if (zero) data <= 8'b0; 
    end
endmodule
