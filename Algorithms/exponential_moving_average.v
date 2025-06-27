`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2025 16:19:19
// Design Name: 
// Module Name: exponential_moving_average
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


module exponential_moving_average(
input       enable,
input       clk,
input       rst,
input [7:0] data_in,      // [15:14] stock_id, [13:0] current_price
output reg  buy_signal,
output reg  sell_signal,
output [1:0] stock_idd
);
wire [5:0] current_price = data_in[5:0];
wire [1:0]  stock_id     = data_in[7:6];
assign stock_idd = stock_id;
parameter fixed_point_scale = 1024;

parameter fast_n = 5;
parameter alpha_fast = 341; // alpha_fast = 2/(fast_n+1)
parameter one_minus_alpha_fast = fixed_point_scale - alpha_fast; // 1024 - 341 = 683

parameter slow_n = 10;
parameter alpha_slow = 186; // alpha_slow = 2/(slow_n+1)
parameter one_minus_alpha_slow = fixed_point_scale - alpha_slow; // 1024 - 186 = 838

parameter crossover_threshold = 5;
parameter momentum_threshold  = 2;
parameter threshold       = 50;

reg [31:0] fastema [0:3];
reg [31:0] slowema [0:3];

reg [31:0] prevfastema [0:3];

reg [5:0] lastPrice [0:3];

reg [31:0] scaled_price;
reg [31:0] temp_fast, temp_slow;
reg [31:0] new_fastema, new_slowema;
reg signed [31:0] momentum;
reg [5:0] priceDelta;       
integer i;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        buy_signal  <= 1'b0;
        sell_signal <= 1'b0;
        // Stock 0: initial price = 10878, Stock 1: 750, Stock 2: 1250, Stock 3: 2412.
        fastema[0]    <= (14'b10101001111110) << 10;
        slowema[0]    <= (14'b10101001111110) << 10;
        prevfastema[0] <= (14'b10101001111110) << 10;
        lastPrice[0]  <= 6'b101010;
        
        fastema[1]    <= (14'b00001011101110) << 10;
        slowema[1]    <= (14'b00001011101110) << 10;
        prevfastema[1] <= (14'b00001011101110) << 10;
        lastPrice[1]  <= 6'b000010;
        
        fastema[2]    <= (14'b00010011100010) << 10;
        slowema[2]    <= (14'b00010011100010) << 10;
        prevfastema[2] <= (14'b00010011100010) << 10;
        lastPrice[2]  <= 6'b000100;
        
        fastema[3]    <= (14'b00100101101100) << 10;
        slowema[3]    <= (14'b00100101101100) << 10;
        prevfastema[3] <= (14'b00100101101100) << 10;
        lastPrice[3]  <= 6'b001001;
    end
    else if (enable) begin
    
        scaled_price = current_price << 10;
        
        temp_fast = (alpha_fast * scaled_price) + (one_minus_alpha_fast * fastema[stock_id]);
        new_fastema = temp_fast >> 10;
        
        temp_slow = (alpha_slow * scaled_price) + (one_minus_alpha_slow * slowema[stock_id]);
        new_slowema = temp_slow >> 10;
        
        momentum = new_fastema - fastema[stock_id];
        
        if (current_price >= lastPrice[stock_id])
            priceDelta = current_price - lastPrice[stock_id];
        else
            priceDelta = lastPrice[stock_id] - current_price;
        
        prevfastema[stock_id] <= fastema[stock_id];
        fastema[stock_id] <= new_fastema;
        slowema[stock_id] <= new_slowema;
        lastPrice[stock_id] <= current_price;
        
        buy_signal  <= 1'b0;
        sell_signal <= 1'b0;
        
        if (priceDelta < threshold) begin
            if ((new_fastema > new_slowema) && 
                ((new_fastema - new_slowema) > crossover_threshold) &&
                (momentum > momentum_threshold))
            begin
                buy_signal <= 1'b1;
            end
            else if ((new_slowema > new_fastema) && 
                     ((new_slowema - new_fastema) > crossover_threshold) &&
                     (momentum < - momentum_threshold))
            begin
                sell_signal <= 1'b1;
            end
        end
    end
    else begin
        buy_signal  <= 1'b0;
        sell_signal <= 1'b0;
    end
end

endmodule
