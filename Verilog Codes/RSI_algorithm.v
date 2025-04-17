`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.04.2025 23:56:24
// Design Name: 
// Module Name: RSI_algorithm
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


module RSI_algorithm(
    input wire clk,
    input wire rst,
    input wire enable,
    input wire [15:0] price_in,  // [15:14] = stock_id, [13:0] = price
    
    output reg buy_signal,
    output reg sell_signal,
    output reg [1:0] stock_id_out
);

    parameter N = 10; //
    parameter RSI_OVERBOUGHT = 70;
    parameter RSI_OVERSOLD = 30;   
    
    reg [15:0] gain_sum, loss_sum;
    reg [13:0] prev_price; 
    wire [13:0] price = price_in[13:0]; 
    reg [15:0] RS;
    reg [15:0] RSI;
    
    wire [1:0] stock_id = price_in[15:14]; 

    reg [13:0] price_history [0:N-1];  
    integer i;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < N; i = i + 1)
                price_history[i] <= 14'd0;
            gain_sum  <= 0;
            loss_sum  <= 0;
            prev_price <= 14'd0;
            buy_signal <= 0;
            sell_signal <= 0;
            stock_id_out <= 2'b00;
        end 
        else if (enable) begin
            for (i = N-1; i > 0; i = i - 1)
                price_history[i] <= price_history[i-1];
            price_history[0] <= price;

            if (price > prev_price) begin
                gain_sum = gain_sum + (price - prev_price);
            end 
            else if (price < prev_price) begin
                loss_sum = loss_sum + (prev_price - price);
            end

            if (price_history[N-1] > price_history[N-2]) begin
                gain_sum = gain_sum - (price_history[N-1] - price_history[N-2]);
            end 
            else if (price_history[N-1] < price_history[N-2]) begin
                loss_sum = loss_sum - (price_history[N-2] - price_history[N-1]);
            end

            if (loss_sum == 0) begin
                buy_signal  <= 0;
                sell_signal <= 1; 
            end 
            else if (gain_sum == 0) begin
                buy_signal  <= 1;
                sell_signal <= 0;
            end 
            else begin
                
                RS = (gain_sum * 100) / loss_sum;
                
                RSI = 100 - (100 / (1 + RS));

                buy_signal  <= (RSI < RSI_OVERSOLD) ? 1 : 0;
                sell_signal <= (RSI > RSI_OVERBOUGHT) ? 1 : 0;
            end


            prev_price <= price;

            stock_id_out <= stock_id;
        end
    end
endmodule
