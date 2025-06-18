`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2025 09:54:06 AM
// Design Name: 
// Module Name: DataReg
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


module DataReg(
    input clk,
    input [7:0] data_in,
    input db_en,
    input adl_en,
    input adh_en,
    output [7:0] db,
    output [7:0] adl,
    output [7:0] adh
);
    reg [7:0] data = 8'b0;
    assign db = db_en ? (data | 8'b0) : 8'bz;
    assign adl = adl_en ? data : 8'bz;
    assign adh = adh_en ? data : 8'bz;
    always @ (negedge clk) data <= data_in;

endmodule
