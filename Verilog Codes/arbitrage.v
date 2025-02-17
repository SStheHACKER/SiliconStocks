module stat_arbitrage(
    input clk,
    input reset,
    input [15:0] stock1_price,  // Stock 1 price from RAM
    input [15:0] stock2_price,  // Stock 2 price from RAM
    output reg buy_signal,      // Buy signal (long position on stock 1, short on stock 2)
    output reg sell_signal,     // Sell signal (long position on stock 2, short on stock 1)
    output reg [15:0] spread    // Spread between the two stocks
);

    // Parameters for the spread threshold
    parameter THRESHOLD = 100;  // Example threshold for signal generation

    // Calculate the spread between the two stock prices
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            spread <= 16'b0;
            buy_signal <= 0;
            sell_signal <= 0;
        end else begin
            spread <= stock1_price - stock2_price;

            // Generate buy signal if spread is greater than the threshold
            if (spread > THRESHOLD) begin
                buy_signal <= 1;
                sell_signal <= 0;
            end
            // Generate sell signal if spread is less than negative threshold
            else if (spread < -THRESHOLD) begin
                sell_signal <= 1;
                buy_signal <= 0;
            end
            else begin
                buy_signal <= 0;
                sell_signal <= 0;
            end
        end
    end
endmodule