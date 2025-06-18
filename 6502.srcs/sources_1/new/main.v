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

// Decode lines
`define DL_DB_WIRE        0 
`define DL_ADL_WIRE       1
`define DL_ADH_WIRE       2
`define ZERO_ADH0_WIRE    3
`define ZERO_ADH17_WIRE   4
`define ADH_ABH_WIRE      5
`define ADL_ABL_WIRE      6
`define PCL_PCL_WIRE      7
`define ADL_PCL_WIRE      8
`define ONE_PC_WIRE       9
`define PCL_DB_WIRE       10
`define PCL_ADL_WIRE      11
`define ADH_PCH_WIRE      12
`define PCH_DB_WIRE       13
`define PCH_ADH_WIRE      14
`define SB_ADH_WIRE       15
`define SB_DB_WIRE        16
`define ZERO_ADL0_WIRE    17
`define ZERO_ADL1_WIRE    18
`define ZERO_ADL2_WIRE    19
`define S_ADL_WIRE        20
`define S_SB_WIRE         21
`define DBB_ADD_WIRE      22
`define DB_ADD_WIRE       23
`define ADL_ADD_WIRE      24
`define ONE_ADDC_WIRE     25
`define DAA_WIRE          26
`define DSA_WIRE          27
`define ALU0_WIRE         28
`define ALU1_WIRE         29
`define ALU2_WIRE         30
`define ALU3_WIRE         31
`define ALU4_WIRE         32
`define ADD_ADL_WIRE      33
`define ADD_SB06_WIRE     34
`define ADD_SB7_WIRE      35
`define ZERO_ADD_WIRE     36
`define SB_ADD_WIRE       37
`define SB_AC_WIRE        38
`define AC_DB_WIRE        39
`define AC_SB_WIRE        40
`define SB_X_WIRE         41
`define X_SB_WIRE         42
`define SB_Y_WIRE         43
`define Y_SB_WIRE         44
`define P_DB_WIRE         45
`define DB0_C_WIRE        46
`define IR5_C_WIRE        47
`define ACR_C_WIRE        48
`define DBI_Z_WIRE        49
`define DBZ_Z_WIRE        50
`define DB2_1_WIRE        51
`define IR5_I_WIRE        52
`define DB3_D_WIRE        53
`define IR5_D_WIRE        54
`define DB6_V_WIRE        55
`define AVR_V_WIRE        56
`define I_V_WIRE          57
`define DB7_N_WIRE        58

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
    output wire [1:0] an        // Annode; selected display segment
);
    
    reg [$clog2(`ROM_SIZE):0] pc = 0;
    wire [58:0] ctrl;
    
    reg [7:0] dr; // Input Data Latch
    reg [7:0] ir; // Instruction register
    reg [7:0] adl = 8'h00;
    reg [7:0] adh = 8'h00;
        
    wire [7:0] sb;
    wire [7:0] db;

    wire [7:0] adl_wire;
    wire [7:0] adh_wire;
    assign adl_wire = adl;
    assign adh_wire = ctrl[`SB_ADH_WIRE] ? sb :  adh; //FIXME

    wire [15:0] addr_data;
    AddrReg abl(clk, ctrl[`ADL_ABL_WIRE], adl_wire, addr_data[0+:8]);
    AddrReg abh(clk, ctrl[`ADH_ABH_WIRE], adh_wire, addr_data[8+:8]);

    GPRegister x(clk, sb, ctrl[`SB_X_WIRE], ctrl[`X_SB_WIRE]);
    GPRegister y(clk, sb, ctrl[`SB_Y_WIRE], ctrl[`Y_SB_WIRE]);
    
    /* -------------FETCH-------------- */
    
    // Modification of 6502 to support Harvard Arch. //
    wire [7:0] ir_wire;
    wire [7:0] dr_wire;
    // Modification of 6502 to support Harvard Arch. //
    DataReg dr_mod(clk, dr_wire, ctrl[`DL_DB_WIRE], ctrl[`DL_ADL_WIRE], ctrl[`DL_ADH_WIRE], db, adl_wire, adh_wire); // Input Data Latch
    reg cs = 1'b0; // TEMP: Hardcode to rom
    InstructionFetch #(
        .WORD_SIZE(`WORD_SIZE), .ROM_DEPTH(`ROM_DEPTH), .RAM_DEPTH(`RAM_DEPTH)
    ) fetch(clk, cs, adl, adh, ir_wire, dr_wire);
    
    
    /* ----------Bus Signals-----------*/
    assign sb = ctrl[`SB_DB_WIRE] ? db : 
                ctrl[`SB_ADH_WIRE] ? adh_wire : 
                8'bz;
    assign db = ctrl[`SB_DB_WIRE] ? sb : 8'bz;
    
    
    /* -------------DECODE-------------*/
    
    Decode de(
        clk,
        ir_wire,
        dr_wire,
        ctrl
    );
    
    /* --------------ALU-------------- */
    wire [7:0] bus_b_addr;
    wire [7:0] alu_a, alu_b, alu_out;

    assign dbb = ~db;
    assign bus_b_addr = adl_wire;

    wire V, C, ex;
    reg cin = 1'b0;
    reg load_out_data = 1'b0;
    reg load_a_zero, load_a_data;
    reg load_b_data, load_b_datab, load_b_addr;
    reg [2:0] alu_ctrl;
 
    
    ALURegisterA a(clk, sb, ctrl[`SB_ADD_WIRE], ctrl[`ZERO_ADD_WIRE], alu_a);
    ALURegisterB b(clk, db, dbb, bus_b_addr, ctrl[`DB_ADD_WIRE], ctrl[`DBB_ADD_WIRE], ctrl[`ADL_ADD_WIRE], alu_b);
    ALU alu(clk, alu_a, alu_b, cin, {ctrl[`ALU2_WIRE],ctrl[`ALU1_WIRE],ctrl[`ALU0_WIRE]}, V, C, alu_out);
    AdderHoldRegister add(clk, alu_out, ctrl[`ADD_ADL_WIRE], ctrl[`ADD_SB7_WIRE], ctrl[`ADD_SB06_WIRE], adl_wire, sb);
        
    ACRegister ac(clk, sb, ctrl[`SB_AC_WIRE], ctrl[`AC_SB_WIRE], ctrl[`AC_DB_WIRE], db);
    
    /* ---------------Run---------------*/



    always @ (dr_wire)  dr <= dr_wire;
    always @ (ir_wire)  ir <= ir_wire;
    always @ (posedge clk) begin
        {adh, adl} <= {adh, adl}+1;
    end
    /* -------------Display-------------*/
    wire [4*7-1:0] segDataWire;     // 4x7 array of converted data for each segment.
    wire [4*4-1:0] hexDataWire;     // 4x7 array of raw hex data behind each segement.
    assign hexDataWire[0+:8] = adl_wire;
    assign hexDataWire[8+:8] = adh_wire;
    // Encodes hex data to segments
    sw_EncodeHex sw_encode0(clk, hexDataWire[0+:4], segDataWire[0+:7]);     // Segment 0
    sw_EncodeHex sw_encode1(clk, hexDataWire[4+:4], segDataWire[7+:7]);     // Segment 1
    sw_EncodeHex sw_encode2(clk, hexDataWire[8+:4], segDataWire[14+:7]);    // Segment 2
    sw_EncodeHex sw_encode3(clk, hexDataWire[12+:4], segDataWire[21+:7]);   // Segment 3
    
    SevenSegment_Hex seg_hex(clk, en, an_sel, segDataWire, seg, an, dp);    // Drives display

    
endmodule
