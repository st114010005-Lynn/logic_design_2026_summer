`timescale 1ns/1ps

module Warn_Pattern (clk, rst_n, in, out);
input clk, rst_n;
input in;
output [2-1:0] out;

reg [1:0] out;
reg [3:0] state, next_state;

//state encoding
parameter IDLE  = 4'd0,
          S0    = 4'd1,
          S1    = 4'd2,
          S01   = 4'd3,
          S10   = 4'd4,
          S011  = 4'd5,
          S101  = 4'd6,
          M1011 = 4'd7,
          M0110 = 4'd8;

//1. 狀態暫存器：同步 reset，時序邏輯
always @(posedge clk) begin
    if (!rst_n)
        state <= IDLE;
    else
        state <= next_state;
end

//2. 下一狀態邏輯：組合邏輯，對應你畫的那張圖
always @(*) begin
    case (state)
        IDLE:  next_state = in ? S1    : S0;
        S0:    next_state = in ? S01   : S0;
        S1:    next_state = in ? S1    : S10;
        S01:   next_state = in ? S011  : S10;
        S10:   next_state = in ? S101  : S0;
        S011:  next_state = in ? S1    : M0110;
        S101:  next_state = in ? M1011 : S10;
        M1011: next_state = in ? S1    : M0110;
        M0110: next_state = in ? S101  : S0;
        default: next_state = IDLE;
    endcase
end

//3. 輸出邏輯：組合邏輯，只看目前 state（Moore machine）
always @(*) begin
    case (state)
        IDLE:  out = 2'b11;
        M1011: out = 2'b01;
        M0110: out = 2'b01;
        default: out = 2'b00;
    endcase
end

endmodule