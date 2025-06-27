`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2025 16:17:44
// Design Name: 
// Module Name: Momentum_ignition
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


module Momentum_ignition(
input enable,
input clk,
input rst,
//input [13:0] current_price,
//input [1:0] stock_id,
input [7:0] data_in,
output buy_signal,
output sell_signal,
output[1:0] stock_idd
    );
    
//    parameter volume=42200;
//    parameter volume_threshold = 80000;
    parameter desired_price_change = 7;
    
    wire [5:0] current_price;
    reg [5:0] next_price;
    wire [1:0] stock_id;
    reg buy_signal_reg;
    reg sell_signal_reg;
    
    reg[5:0] moving_avg [0:3];
    reg[5:0] entry_price[0:3];
    
    assign current_price = data_in[5:0];
    assign stock_id = data_in[7:6];
    
    always @(posedge clk) begin
        if(rst) begin
//            current_price <= data_in[13:0];
            buy_signal_reg <= 1'b0;
            sell_signal_reg <= 1'b0;
            entry_price[0]<= 6'b101010;
            entry_price[1]<= 6'b0;
            entry_price[2]<= 6'b0;
            entry_price[3]<= 6'b0;
            moving_avg[0] <= 6'b101010; // 10900
            moving_avg[1] <= 6'b000010; // 750
            moving_avg[2] <= 6'b000100; // 1250
            moving_avg[3] <= 6'b001001; // 2412
        end
        else begin
        if(enable) begin
//            next_price <= data_in[13:0];
//            current_price <= data_in[13:0];
            
            if((current_price > moving_avg[stock_id])) begin
                    buy_signal_reg <= 1'b1;
                    sell_signal_reg <= 1'b0;
                    moving_avg[stock_id] <= ((moving_avg[stock_id]  + current_price)/2);
            end else begin
                if
                ((current_price > entry_price[stock_id] + desired_price_change) || (current_price < entry_price[stock_id] - desired_price_change)) begin
                sell_signal_reg <= 1'b1;
                buy_signal_reg <= 1'b0;
                entry_price[stock_id] <= current_price;
                moving_avg[stock_id] <= ((moving_avg[stock_id]+current_price)/2);
                end
                else begin
                    buy_signal_reg <=1'b0;
                    sell_signal_reg <=1'b0;
                    moving_avg[stock_id] <= ((moving_avg[stock_id]+current_price)/2);
                end
            end
        end
        else begin
            buy_signal_reg <= 1'b0;
            sell_signal_reg <= 1'b0;
        end
        end
  end
  
  assign stock_idd = stock_id;
  assign buy_signal = buy_signal_reg;
  assign sell_signal = sell_signal_reg;         

endmodule
