`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.01.2025 23:19:03
// Design Name: 
// Module Name: top_module
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


module top_module(
input clk,rst,we,enable,
input[4:0] w_addr,
input[15:0] data_in,
//input[13:0] current_price,
//input[1:0] stock_id,
output buy_signal,
output sell_signal
    );
    
    wire[15:0] ram_data;
    wire [1:0] stock_id;
    wire [13:0] current_price;
    
    asli_ram ram_inst(
        .clk(clk),
        .rst(rst),
        .we(we),
        .w_addr(w_addr),
        .data_in(data_in),
        .data_out(ram_data)
    );
    
    assign stock_id = ram_data[15:14];
    assign current_price = ram_data[13:0];
    
    Momentum_Ignition algo_inst(
        .enable(enable),
        .clk(clk),
        .rst(rst),
        .current_price(current_price),
        .stock_id(stock_id),
        .buy_signal(buy_signal),
        .sell_signal(sell_signal)
    );
endmodule
