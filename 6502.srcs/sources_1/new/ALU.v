`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/20/2025 10:33:20 AM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input clk,
    // Data in
    input [7:0] A, B,
    input cin, // Carry in
    input [2:0] ctrl,
    /*
    
    //input sums,
    //input ands,
    //input eors,
    //input ors,
    //input lsrs,
    //input lsls,
    //input asrs,
    //input asls,
    
    */
    // Status
    output V, C,
        
    // Data out
    output [7:0] out
    
);
    reg [7:0] res = 8'b0;
    reg [1:0] status = 2'b0;
    assign out = res[7:0];
    assign {V,C} = status;
    always @ (*) begin
        case (ctrl)
            3'b000:  begin // Sums
                        {status[0], res} = A + B + cin;                 
                        status[1] = (A[7] != res[7]) && (B[7] != res[7]);
                    end
            3'b001:  res = A & B;
            3'b010:  res = A ^ B;
            3'b011:  res = A | B;
            3'b100:  res = A << B;
            3'b101:  res = A >> B;
            3'b110:  res = A <<< B;
            3'b111:  res = A >>> B;
        endcase
    end
    
endmodule
