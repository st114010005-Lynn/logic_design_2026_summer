`timescale 1ns/1ps

module Warn_Pattern_t;
reg clk = 1'b1;
reg rst_n = 1'b1;
reg in = 1'b0;
wire [2-1:0] out;

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always #(cyc/2) clk = ~clk;

//the module that you designed
Warn_Pattern WP (
    .clk (clk),
    .rst_n (rst_n),
    .in (in),
    .out (out)
);

//this blocks is for creating the waveform
initial begin
    $dumpfile("HW3_result.vcd");
    $dumpvars(0,Warn_Pattern_t);
end

//--- 把重複動作包成 task ---
task apply_bit(input bit_in);
    begin
        @(negedge clk);
        in = bit_in;
    end
endtask

initial begin
    // Test 1: reset 行為，此時 out 應該要是 11
    rst_n = 1'b0;
    @(negedge clk);
    @(negedge clk);
    rst_n = 1'b1;

    // Test 2: 餵入 "1011"，應該在第4個bit進去後偵測到，out=01
    apply_bit(1'b1);
    apply_bit(1'b0);
    apply_bit(1'b1);
    apply_bit(1'b1);

    // Test 3: 餵入 "0110"，應該偵測到，out=01
    apply_bit(1'b0);
    apply_bit(1'b1);
    apply_bit(1'b1);
    apply_bit(1'b0);

    // Test 4: 測試重疊情況 "10110"
    // 前4碼1011會先命中一次，接著0110又會命中一次
    apply_bit(1'b1);
    apply_bit(1'b0);
    apply_bit(1'b1);
    apply_bit(1'b1);
    apply_bit(1'b0);

    // Test 5: 測試中途再 reset 一次
    rst_n = 1'b0;
    @(negedge clk);
    rst_n = 1'b1;

    // Test 6: 完全不 match，維持 S0
    apply_bit(1'b0);
    apply_bit(1'b0);
    apply_bit(1'b0);

    rst_n = 1'b0;
    @(negedge clk);
    rst_n = 1'b1;

    // Test 7: 完全不 match，維持 S1
    apply_bit(1'b1);
    apply_bit(1'b1);
    apply_bit(1'b1);

    rst_n = 1'b0;
    @(negedge clk);
    rst_n = 1'b1;

    // Test 8: 比對到一半斷掉 (S1->S10->S0)
    apply_bit(1'b1);
    apply_bit(1'b0);
    apply_bit(1'b0);

    rst_n = 1'b0;
    @(negedge clk);
    rst_n = 1'b1;

    // Test 9: 藍色斜線 S011 -> S1 (收到1沒有形成0110)
    apply_bit(1'b0);
    apply_bit(1'b1);
    apply_bit(1'b1);
    apply_bit(1'b1);  // 這裡應該跳回 S1，不是 M0110

    rst_n = 1'b0;
    @(negedge clk);
    rst_n = 1'b1;

    // Test 10: 連續命中兩次 (不重疊)
    apply_bit(1'b1); apply_bit(1'b0); apply_bit(1'b1); apply_bit(1'b1); // 第一次 match
    apply_bit(1'b1); apply_bit(1'b0); apply_bit(1'b1); apply_bit(1'b1); // 第二次 match

    rst_n = 1'b0;
    @(negedge clk);
    rst_n = 1'b1;

    // Test 11: 反向重疊 011011
    apply_bit(1'b0); apply_bit(1'b1); apply_bit(1'b1); apply_bit(1'b0); // 0110 命中
    apply_bit(1'b1); apply_bit(1'b1); // 接著湊出 1011 應該再命中一次

    // Test 12: 比對途中 reset
    apply_bit(1'b1);
    apply_bit(1'b0);
    rst_n = 1'b0;
    @(negedge clk);
    rst_n = 1'b1;

    // 全部測試跑完，最後緩衝幾個 cycle 再結束
    #(cyc*3);
    $finish;
end

endmodule