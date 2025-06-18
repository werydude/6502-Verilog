`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/15/2025 05:44:36 PM
// Design Name: 
// Module Name: Decode
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


/* Control names
0:  DL/DB
1:  DL/ADL  
2:  DL/ADH  
3:  0/ADH0  
4:  0/ADH1-7
5:  ADH/ABH 
6:  ADL/ABL 
7:  PCL/PCL 
8:  ADL/PCL 
9:  1/PC    
10: PCL/DB  
11: PCL/ADL 
12: ADH/PCH 
13: PCH/DB  
14: PCH/ADH 
15: SB/ADH  
16: SB/DB   
17: 0/ADL0  
18: 0/ADL1  
19: 0/ADL2  
20: S/ADL   
21: S/SB    
22: DBB/ADD 
23: DB/ADD  
24: ADL/ADD 
25: 1/ADDC  
26: DAA     
27: DSA     
28: SUMS    
29: ANDS    
30: EORS    
31: ORS     
32: SRS     
33: ADD/ADL 
34: ADD/SB(0-6)
35: ADD/SB(7)
36: 0/ADD   
37: SB/ADD  
38: SB/AC   
39: AC/DB   
40: AC/SB   
41: SB/X    
42: X/SB    
43: SB/Y    
44: Y/SB    
45: P/DB    
46: DB0/C   
47: IR5/C   
48: ACR/C   
49: DBI/Z   
50: DBZ/Z   
51: DB2/1   
52: IR5/I   
53: DB3/D   
54: IR5/D   
55: DB6/V   
56: AVR/V   
57: I/V     
58: DB7/N

    */

// SIGNALS
`define DL_DB       1 
`define DL_ADL      1<<1
`define DL_ADH      1<<2
`define ZERO_ADH0   1<<3
`define ZERO_ADH17  1<<4
`define ADH_ABH     1<<5
`define ADL_ABL     1<<6
`define PCL_PCL     1<<7
`define ADL_PCL     1<<8
`define ONE_PC      1<<9
`define PCL_DB      1<<10
`define PCL_ADL     1<<11
`define ADH_PCH     1<<12
`define PCH_DB      1<<13
`define PCH_ADH     1<<14
`define SB_ADH      1<<15
`define SB_DB       1<<16
`define ZERO_ADL0   1<<17
`define ZERO_ADL1   1<<18
`define ZERO_ADL2   1<<19
`define S_ADL       1<<20
`define S_SB        1<<21
`define DBB_ADD     1<<22
`define DB_ADD      1<<23
`define ADL_ADD     1<<24
`define ONE_ADDC    1<<25
`define DAA         1<<26
`define DSA         1<<27
`define ALU0        1<<28
`define ALU1        1<<29
`define ALU2        1<<30
`define ALU3        1<<31
`define ALU4        1<<32
`define ADD_ADL     1<<33
`define ADD_SB06    1<<34
`define ADD_SB7     1<<35
`define ZERO_ADD    1<<36
`define SB_ADD      1<<37
`define SB_AC       1<<38
`define AC_DB       1<<39
`define AC_SB       1<<40
`define SB_X        1<<41
`define X_SB        1<<42
`define SB_Y        1<<43
`define Y_SB        1<<44
`define P_DB        1<<45
`define DB0_C       1<<46
`define IR5_C       1<<47
`define ACR_C       1<<48
`define DBI_Z       1<<49
`define DBZ_Z       1<<50
`define DB2_1       1<<51
`define IR5_I       1<<52
`define DB3_D       1<<53
`define IR5_D       1<<54
`define DB6_V       1<<55
`define AVR_V       1<<56
`define I_V         1<<57
`define DB7_N       1<<58

// OPCODES
`define LDX_IMM 8'h80
`define LDY_IMM 8'hA0
`define LDA_IMM 8'hA9
`define ADC_IMM 8'h69
`define ARC_X 8'h03
`define ARC_Y 8'h23

// HELPERS
`define ADD_SB `ADD_SB06 | `ADD_SB7
`define RESULT_TO_AC (`ADD_SB | `SB_AC)

// ALU HELPERS
`define ALU_START 28
`define SUMS (3'b000 << `ALU_START)
`define ANDS (3'b001 << `ALU_START)
`define EORS (3'b010 << `ALU_START)
`define ORS  (3'b011 << `ALU_START)
`define LSRS (3'b100 << `ALU_START)
`define LSLS (3'b101 << `ALU_START)
`define ASRS (3'b110 << `ALU_START)
`define ASLS (3'b111 << `ALU_START)


module Decode(
    input clk,
    input [7:0] instr,
    input [7:0] ext,
    output [58:0] ctrl
);
reg [58:0] data;
reg [7:0] last_pos_instr;
assign ctrl = data;
always @ (posedge clk) begin
    case (instr)
        `LDX_IMM: data = 58'b0 | (`DL_DB  | `SB_DB  | `SB_X); // LDX imm; dr_db, pass_sb_db, sb_x; ORIGINALY $A2
        `LDY_IMM: data = 58'b0 | (`DL_DB  | `SB_DB  | `SB_Y); // LDY imm; dr_db, pass_sb_db, sb_y
        `LDA_IMM: data = 58'b0 | (`DL_DB  | `SB_DB  | `SB_AC); // LDA imm; dr_db, pass_sb_db, sb_ac
        `ADC_IMM: data = 58'b0 | (`DB_ADD | `SB_ADD | `AC_SB | `DL_DB | `SUMS); // ADC imm; EX(ac_sb, sb_add, dr_db, db_add) + WB(add_sb, sb_ac)
        `ARC_X:   data = 58'b0 | (`DB_ADD | `SB_ADD | `AC_DB | `X_SB  | `SUMS); // ARC: Add registers with carry -> A+X;  EX:(db_add, sb_add, ac_db, x_sb) + WB(add_sb, sb_ac)
        `ARC_Y:   data = 58'b0 | (`DB_ADD | `SB_ADD | `AC_DB | `Y_SB  | `SUMS); // ARC: Add registers with carry -> A+Y;  EX:(db_add, sb_add, ac_db, y_sb) + WB(add_sb, sb_ac)
        default:  data = 58'b0;
    endcase
    last_pos_instr <= instr;
end

always @ (negedge clk) begin
    case (last_pos_instr)
        `ADC_IMM: data = 58'b0 | `RESULT_TO_AC; // ADC imm; EX(ac_sb, sb_add, dr_db, db_add, add_load) + WB(add_sb, sb_ac)
        `ARC_X:   data = 58'b0 | `RESULT_TO_AC; // ARC: Add registers with carry -> A+X;  EX:(x_sb, sb_add, ac_db, db_add, add_load) + WB(add_sb, sb_ac)
        `ARC_Y:   data = 58'b0 | `RESULT_TO_AC; // ARC: Add registers with carry -> A+Y;  EX:(y_sb, sb_add, ac_db, db_add, add_load) + WB(add/sb, sb_ac)
        default:  data = 58'b0;
    endcase
end
endmodule
