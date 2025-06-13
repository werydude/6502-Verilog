`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2025 09:30:03 PM
// Design Name: 
// Module Name: ALU_tb
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

module ALU_tb();
`include "ALU_tb_h.vh"

ALURegisterA a(bus_a_data, load_a_data, load_a_zero, bus_out_a);
ALURegisterB b(bus_b_data, bus_b_datab, bus_b_addr, load_b_data, load_b_datab, load_b_addr, bus_out_b);
ALU alu(bus_out_a, bus_out_b, cin, sums, ands, eors, ors/*, srs*/, V, C, load_out, out);

initial begin
    $display("Starting ALU add test");
    data_a = 'd4;
    data_b = 'd6;
    load_a_data = 1'b1;
    load_b_data = 1'b1;
    #1;
    load_a_data = 1'b0;
    load_b_data = 1'b0;
    
    sums = 1'b1;
    load_out_data = 1'b1;
    #1;
    load_out_data = 1'b0;
    
    $finish;
end

endmodule
