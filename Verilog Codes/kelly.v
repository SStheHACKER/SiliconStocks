`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2025 13:16:01
// Design Name: 
// Module Name: kelly
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


module kelly(
    input clk,
    input rst,
    input enable,
    input [15:0] data_in, 
    input RSI_buy, EMA_buy, Momentum_buy,
    input RSI_sell, EMA_sell, Momentum_sell,
    output reg [9:0] bought,
    output reg [15:0] profit,
    output [1:0] stock_id
);

    assign stock_id = data_in[15:14];
    wire [13:0] price_raw = data_in[13:0];
    wire [15:0] stock_price = {2'b00, price_raw}; 

    reg [9:0] total_stocks = 100;
    reg [15:0] money = 25000;
    reg [7:0] win_rate = 60; 
    reg [7:0] p = 60;      

    wire [7:0] Kelly_fraction;
    assign Kelly_fraction = (win_rate * p / 100 - (100 - p)) / win_rate;

    reg buy, sell;
    reg [9:0] quantity;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bought <= 0;
            profit <= 0;
            money <= 25000;
            total_stocks <= 100;
        end 
        else if (enable) begin
            buy  = (RSI_buy + EMA_buy + Momentum_buy >= 2);
            sell = (RSI_sell + EMA_sell + Momentum_sell >= 2);

            quantity = (total_stocks * Kelly_fraction) / 100;

            if (buy) begin
                bought <= bought + quantity;
                total_stocks <= total_stocks + quantity;
                money <= money - (quantity * stock_price);
            end
            else if (sell && bought >= quantity) begin
                bought <= bought - quantity;
                total_stocks <= total_stocks - quantity;
                money <= money + (quantity * stock_price);
            end

            profit <= money + (total_stocks * stock_price) - 25000;
        end
    end

endmodule
