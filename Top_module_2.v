`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2025 00:07:30
// Design Name: 
// Module Name: Top_module_2
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


module Top_module_2(
input clk,we,enable,
input[4:0] w_addr,
//input[15:0] data_in,
output buy_signal,sell_signal,
output[1:0] stock_id,
//output [9:0]   bought,   
output [15:0]  profit,

input ETH_CRSDV,
output ETH_REFCLK,
input [1:0]ETH_RXD,
input ETH_RXERR,
output [1:0]ETH_TXD,
output ETH_TXEN,
//output [15:0]LED,
input RESET_IN,
//input [15:0]SW,
output UART_RXD_OUT
    );
    
    wire[15:0] input_data;
    wire[15:0] output_data;
    wire[9:0]   bought;
    
    design_1_wrapper inst1
    (.CLK(clk),
    .ETH_CRSDV(ETH_CRSDV),
    .ETH_REFCLK(ETH_REFCLK),
    .ETH_RXD(ETH_RXD),
    .ETH_RXERR(ETH_RXERR),
    .ETH_TXD(ETH_TXD),
    .ETH_TXEN(ETH_TXEN),
    .LED(input_data),
    .RESET_IN(RESET_IN),
    .SW(output_data),
    .UART_RXD_OUT(UART_RXD_OUT)
    );
    
    
    Top_module_1 inst2
    (.clk(clk),
    .rst(RESET_IN),
    .we(we),
    .enable(enable),
    .w_addr(w_addr),
    .data_in(input_data),
    .buy_signal(buy_signal),
    .sell_signal(sell_signal),
    .stock_iden(stock_id),
    .ram_data(output_data),
    .bought(bought),   
    .profit(profit)
    );
endmodule
