`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2025 09:49:17 PM
// Design Name: 
// Module Name: main
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

`include "GPRegister.v"
`include "ALURegisterA.v"
`include "ALURegisterB.v"
`include "ALU.v"
`include "ACRegister.v"
`include "C:\Users\tahv\Code\FPGA\Xilinx\Projects\7Segment_Hex\7Segment_Hex.srcs\sources_1\new\sw_EncodeHex.v"
`include "C:\Users\tahv\Code\FPGA\Xilinx\Projects\7Segment_Hex\7Segment_Hex.srcs\sources_1\new\SevenSegment_Hex.v"

`define PAGE_SIZE 4096
`define ROM_SIZE `PAGE_SIZE*2
`define RAM_SIZE `PAGE_SIZE
`define WORD_SIZE 8
`define FETCH_SIZE `WORD_SIZE*2
`define BLOCK_SIZE(mem,size) (mem)/(size) // Parens important here for nested macros!
`define ROM_DEPTH `BLOCK_SIZE(`ROM_SIZE, `FETCH_SIZE)
`define RAM_DEPTH `BLOCK_SIZE(`RAM_SIZE, `WORD_SIZE)

module main(
    input clk,
    input [15:0] sw,
    input btnC,
    input btnU,
    input btnD,
    input btnR,
    input btnL,
    output [15:0] led,
    output wire [6:0] seg,      // Segment data to push to 7-segment display
    output wire [3:0] an        // Annode; selected display segment
);
    
    reg [$clog2(`ROM_SIZE):0] pc = 0;
    
    AddrReg abl(clk, adl_abl, adl, addr_data[0+:8]);
    AddrReg abh(clk, adh_abh, adh, addr_data[8+:8]);
    wire [15:0] addr_data;
    wire [7:0] adl;
    wire [7:0] adh;
    wire adh_abh, adl_abl;
    
    wire [7:0] sb;
    wire [7:0] db;
    
    wire [1:0] reg_load;
    wire [1:0] reg_sb_en;
    GPRegister x(clk, sb, reg_load[0], reg_sb_en[0]);
    GPRegister y(clk, sb, reg_load[1], reg_sb_en[1]);
    
    wire pass_sb_db, pass_sb_adh;
    assign sb = pass_sb_db ? db : 
                pass_sb_adh ? adh : 
                8'bz;
    assign db = pass_sb_db ? sb : 8'bz;
    assign adh = 
    
    /* -------------FETCH-------------- */
    
    // Modification of 6502 to support Harvard Arch. //
    reg [7:0] dr; // Input Data Latch
    reg [7:0] ir; // Instruction register
    reg cs = 1'b0; // TEMP: Hardcode to rom
    reg cs = 1'b0; // TEMP: Hardcode to rom
    wire [7:0] ir_wire;
    wire [7:0] dr_wire;
    InstructionFetch #(
        .WORD_SIZE(`WORD_SIZE), .ROM_DEPTH(`ROM_DEPTH), .RAM_DEPTH(`RAM_DEPTH)
    ) fetch(clk, cs, adl, adh, ir_wire, dr_wire);
    
    /* -------------DECODE-------------*/
    
    
    
    /* --------------ALU-------------- */
    wire [7:0] bus_b_addr;
    wire [7:0] alu_a, alu_b, alu_out;

    assign dbb = ~db;
    assign bus_b_addr = adl;

    wire V, C, ex, load_out;
    reg cin = 1'b0;
    reg load_out_data = 1'b0;
    reg load_a_zero, load_a_data;
    reg load_b_data, load_b_datab, load_b_addr;
    reg [2:0] alu_ctrl;
    
    assign load_out = (load_out_data && !btnC);
    assign ex = btnC;
    
    ALURegisterA a(clk, sb, load_a_data, load_a_zero, alu_a);
    ALURegisterB b(clk, db, dbb, bus_b_addr, load_b_data, load_b_datab, load_b_addr, alu_b);
    ALU alu(clk, alu_a, alu_b, cin, alu_ctrl, ex, load_out, V, C, alu_out);
    
    reg add_adl, add_sb;
    wire add_addr;
    assign add_addr = adl;
    AdderHoldRegister add(clk, alu_out, add_adl, add_sb, add_addr, sb);
        
    wire load_ac, ac_sb, ac_db;
    assign load_ac = btnL || load_out;
    assign ac_db = btnC || btnD;
    ACRegister ac(clk, sb, load_ac, ac_sb, ac_db, db);
    
    /* -------------Display-------------*/
    wire [4*7-1:0] segDataWire;     // 4x7 array of converted data for each segment.
    wire [4*4-1:0] hexDataWire;     // 4x7 array of raw hex data behind each segement.
    assign hexDataWire[0+:8] = adl;
    assign hexDataWire[8+:8] = adh;
    // Encodes hex data to segments
    sw_EncodeHex sw_encode0(clk, hexDataWire[0+:4], segDataWire[0+:7]);     // Segment 0
    sw_EncodeHex sw_encode1(clk, hexDataWire[4+:4], segDataWire[7+:7]);     // Segment 1
    sw_EncodeHex sw_encode2(clk, hexDataWire[8+:4], segDataWire[14+:7]);    // Segment 2
    sw_EncodeHex sw_encode3(clk, hexDataWire[12+:4], segDataWire[21+:7]);   // Segment 3
    
    SevenSegment_Hex seg_hex(clk, en, an_sel, segDataWire, seg, an, dp);    // Drives display

    
endmodule
