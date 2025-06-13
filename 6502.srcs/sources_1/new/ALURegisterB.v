`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2025 08:43:21 PM
// Design Name: 
// Module Name: ALURegsiterB
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


module ALURegisterB(
    input clk,
    input [7:0] data_bus,
    input [7:0] datab_bus,
    input [7:0] addr_bus,
    input load_data,
    input load_datab,
    input load_addr,
    output [7:0] out
);
    reg [7:0] data;
    assign out = data;
    always @ (posedge clk) begin
        if (load_data)  data <= data_bus;
        if (load_datab) data <= datab_bus;
        if (load_addr)  data <= addr_bus;
    end
endmodule
