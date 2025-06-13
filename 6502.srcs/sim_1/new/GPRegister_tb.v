`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2025 08:33:13 AM
// Design Name: 
// Module Name: GPRegister_tb
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


module GPRegister_tb();
    reg [7:0] data = 8'b11100111;
    wire [7:0] bus;
    reg load_x = 1'b0;
    reg bus_en_x = 1'b0;
    reg load_y = 1'b0;
    reg bus_en_y = 1'b0;
    
    GPRegister x(bus, load_x, bus_en_x);
    GPRegister y(bus, load_y, bus_en_y);
    assign bus = !(bus_en_x || bus_en_y) ? data : 8'bz;
    
    // Register transfer test
    initial begin
        load_x = 1'b1;
        #1 load_x = 1'b0;
        
        #1;
        
        data = 8'hFF;
        
        #1;
        
        load_y = 1'b1;
        #1 load_y = 1'b0;
        
        #1;
        
        bus_en_x = 1'b1;
        load_y = 1'b1;
        #1 load_y = 1'b0;
        bus_en_x = 1'b0;
        #1;
        
        load_x = 1'b1;
        #1 load_x = 1'b0;
        $finish;
    end
endmodule
