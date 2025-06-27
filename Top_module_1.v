`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.04.2025 23:53:19
// Design Name: 
// Module Name: Top_module_1
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


module Top_module_1(
input clk,rst,we,enable,
input[4:0] w_addr,
input[15:0] data_in,
//input[13:0] current_price,
//input[1:0] stock_id,
output buy_signal,
output sell_signal,
output [9:0]   bought,   
output [15:0]  profit,
output [1:0]stock_iden,
output [15:0] ram_data
    );
    
     wire ema_buy;
    wire ema_sell;
//    wire [1:0] stock_id_ema;

    wire RSI_buy;
    wire RSI_sell;
//    wire [1:0] stock_id_algo;

    wire mom_buy;
    wire mom_sell;
//    wire [1:0] stock_id_mom;

    
    RAM_module ram_inst(
        .clk(clk),
        .rst(rst),
        .we(we),
        .w_addr(w_addr),
        .data_in(data_in),
        .data_out(ram_data)
    );
    
    
    Momentum_ignition algo_inst1(
        .enable(enable),
        .clk(clk),
        .rst(rst),
        .data_in(ram_data),
        .buy_signal(mom_buy),
        .sell_signal(mom_sell),
        .stock_idd(stock_iden)
    );
    
    RSI_algorithm algo_inst2(
        .enable(enable),
        .clk(clk),
        .rst(rst),
        .price_in(ram_data),
        .buy_signal(RSI_buy),
        .sell_signal(RSI_sell),
        .stock_id_out(stock_iden)
    );
    
    exponential_moving_average algo_inst3(
        .enable(enable),
        .clk(clk),
        .rst(rst),
        .data_in(ram_data),
        .buy_signal(ema_buy),
        .sell_signal(ema_sell),
        .stock_idd(stock_iden)
    );
    
    kelly kelly_inst (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .data_in(data_in),
        .RSI_buy(RSI_buy),
        .EMA_buy(ema_buy),
        .Momentum_buy(mom_buy),
        .RSI_sell(RSI_sell),
        .EMA_sell(ema_sell),
        .Momentum_sell(mom_sell),
        .bought(bought),
        .profit(profit),
        .stock_id(stock_iden)
    );

    
    assign buy_signal = (mom_buy & RSI_buy) | (RSI_buy & ema_buy) | (ema_buy & mom_buy); 
    assign sell_signal = (mom_sell & RSI_sell) | (mom_sell & ema_sell) | (RSI_sell & ema_sell);
endmodule

