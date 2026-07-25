`include "HW1_a.v"

`timescale 1ns / 1ps // 定義時間單位與精確度

module tb_CLA_AddSub_8bit;

    // 1. 宣告連接到被測元件 (DUT) 的訊號
    reg [7:0] a;
    reg [7:0] b;
    reg       mode;
    wire [7:0] s;
    wire       c8;
    wire       overflow;

    // 2. 實例化你要測試的頂層模組 (Device Under Test, DUT)
    CLA_AddSub_8bit uut (
        .a(a), 
        .b(b), 
        .mode(mode), 
        .s(s), 
        .c8(c8), 
        .overflow(overflow)
    );

    // 3. 產生測試訊號
    initial begin
        // 初始化輸出格式，方便在 Console 視窗直接看結果
        $monitor("Time=%0dns | mode=%b | a=%d (%h) | b=%d (%h) | s=%d (%h) | c8=%b | overflow=%b", 
                 $time, mode, a, a, b, b, s, s, c8, overflow);

        // --- 測試案例 1：簡單加法 (5 + 3 = 8) ---
        mode = 0; a = 8'd5; b = 8'd3;
        #10; // 等待 10 個時間單位

        // --- 測試案例 2：簡單減法 (10 - 4 = 6) ---
        mode = 1; a = 8'd10; b = 8'd4;
        #10;

        // --- 測試案例 3：加法溢位 (正數+正數 = 負數) ---
        // 有號數 8-bit 最大是 127。 127 + 1 應該要溢位變成 -128 (8'h80)
        mode = 0; a = 8'd127; b = 8'd1;
        #10;

        // --- 測試案例 4：減法溢位 (正數-負數 = 負數) ---
        // 127 - (-1) 等同於 127 + 1，會產生溢位
        // 有號數的 -1 在二補數表示法中是 8'hFF (或是 255)
        mode = 1; a = 8'd127; b = 8'hFF; 
        #10;

        // --- 測試案例 5：大數減法結果為負數 (5 - 12 = -7) ---
        // -7 的二補數表示法是 8'hF9
        mode = 1; a = 8'd5; b = 8'd12;
        #10;

        // 結束模擬
        $display("模擬結束！");
        $finish;
    end
      
endmodule