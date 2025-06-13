`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2025 11:40:23 PM
// Design Name: 
// Module Name: ACRegister
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

// NOTE: This does NOT feature DCB adjuster.
module ACRegister(
    input clk,
    inout [7:0] sb,
    input load_sb,
    input sb_en,
    input db_en,
    output [7:0] db_out
);
    reg [7:0] data;
    assign sb  = sb_en ? data : 8'bz;
    assign db_out = db_en ? data : 8'bz;
    always @(posedge clk) if (load_sb) data <= sb;
endmodule
