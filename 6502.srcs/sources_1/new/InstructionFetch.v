`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2025 10:05:54 AM
// Design Name: 
// Module Name: InstructionFetch
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


module InstructionFetch
#(
        parameter WORD_SIZE      = 8,
        parameter ROM_DEPTH      = 512,
        parameter RAM_DEPTH      = 256
)(
    input clk,
    input cs, // 0 rom, 1 ram
    input [7:0] addr_lo,
    input [7:0] addr_hi,
    output [7:0] ir, // hi byte
    output [7:0] dr   // lo byte
);
    reg [(WORD_SIZE*2)-1:0] rom [0:ROM_DEPTH-1];
    reg [WORD_SIZE-1:0] ram [0:RAM_DEPTH-1];
    reg [15:0] fetch_res;
    integer addr;
    initial $readmemb("rom.mem", rom, 0, 7);
    always @ (posedge clk) begin
        if (cs) fetch_res[0+:WORD_SIZE] <= ram[{addr_hi, addr_lo}];
        else fetch_res <= rom[{addr_hi, addr_lo}];
    end
    assign ir = fetch_res[0+:WORD_SIZE];
    assign dr = fetch_res[WORD_SIZE+:WORD_SIZE];
endmodule
