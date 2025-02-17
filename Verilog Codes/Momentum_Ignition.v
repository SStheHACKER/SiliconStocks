`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.01.2025 16:28:00
// Design Name: 
// Module Name: Momentum_Ignition
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


module Momentum_Ignition(
input enable,
input clk,
input rst,
input [13:0] current_price,
input [1:0] stock_id,
output reg buy_signal,
output reg sell_signal
    );
    
//    parameter volume=42200;
//    parameter volume_threshold = 80000;
    parameter desired_price_change = 10;
    
    reg[13:0] moving_avg [0:3];
    reg[13:0] entry_price[0:3];
    always @(posedge clk) begin
        if(rst) begin
            buy_signal <= 1'b0;
            sell_signal <= 1'b0;
            entry_price[0]<= 14'b10101010011011;
            entry_price[1]<= 14'b0;
            entry_price[2]<= 14'b0;
            entry_price[3]<= 14'b0;
            moving_avg[0] <= 14'b10101001111110; // 10878
            moving_avg[1] <= 14'b00001011101110; // 750
            moving_avg[2] <= 14'b00010011100010; // 1250
            moving_avg[3] <= 14'b00100101101100; // 2412
        end
        else begin
        if(enable) begin
            if((current_price > moving_avg[stock_id])) begin
                    buy_signal <= 1'b1;
                    sell_signal <= 1'b0;
                    moving_avg[stock_id] <= ((moving_avg[stock_id]  + current_price)/2);
            end else begin
                if
                ((current_price > entry_price[stock_id] + desired_price_change) || (current_price < entry_price[stock_id] - desired_price_change)) begin
                sell_signal <= 1'b1;
                buy_signal <= 1'b0;
                entry_price[stock_id] <= current_price;
                moving_avg[stock_id] <= ((moving_avg[stock_id]+current_price)/2);
                end
                else begin
                    buy_signal <=1'b0;
                    sell_signal <=1'b0;
                    moving_avg[stock_id] <= ((moving_avg[stock_id]+current_price)/2);
                end
            end
        end
        else begin
            buy_signal <= 1'b0;
            sell_signal <= 1'b0;
        end
        end
  end  
                

endmodule
