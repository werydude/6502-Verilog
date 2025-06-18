`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/17/2025 08:32:24 PM
// Design Name: 
// Module Name: decode_tb
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
`define PAGE_SIZE 4096
`define ROM_SIZE `PAGE_SIZE*2
`define RAM_SIZE `PAGE_SIZE
`define WORD_SIZE 8
`define FETCH_SIZE `WORD_SIZE*2
`define BLOCK_SIZE(mem,size) (mem)/(size) // Parens important here for nested macros!
`define ROM_DEPTH `BLOCK_SIZE(`ROM_SIZE, `FETCH_SIZE)
`define RAM_DEPTH `BLOCK_SIZE(`RAM_SIZE, `WORD_SIZE)

module decode_tb(input clk);
reg [7:0] adl = 8'h00;
reg [7:0] adh = 8'h00;
reg [7:0] dr; // Input Data Latch
reg [7:0] ir; // Instruction register
wire [7:0] ir_wire;
wire [7:0] dr_wire;
wire [58:0] ctrl_wire;
Decode de(
    clk,
    ir_wire,
    dr_wire,
    ctrl_wire
);
reg cs = 1'b0; // TEMP: Hardcode to rom
InstructionFetch #(
    .WORD_SIZE(`WORD_SIZE), .ROM_DEPTH(`ROM_DEPTH), .RAM_DEPTH(`RAM_DEPTH)
) fetch(clk, cs, adl, adh, ir_wire, dr_wire);

always @ (dr_wire)  dr <= dr_wire;
always @ (ir_wire)  ir <= ir_wire;
always @ (posedge clk) begin
    {adh, adl} <= {adh, adl}+1;
end

endmodule
