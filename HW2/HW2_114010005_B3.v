`timescale 1ns/1ps
module DFF_setup_tb;
    reg D, CLK;
    wire Q, nQ;

    DFF uut(.D(D), .CLK(CLK), .Q(Q), .nQ(nQ));

    initial begin
        $dumpfile("DFF_setup.vcd");
        $dumpvars(0, DFF_setup_tb);
    end

    initial $monitor("t=%0t CLK=%b D=%b | Q=%b nQ=%b", $time, CLK, D, Q, nQ);

    // ============================================================
    // 測試流程：
    //  (1) 先做power-up + 讓 Q 穩定在 1 (D=1擺一段時間，經過一次edge)
    //  (2) case A: D 在 CLK 下降緣「前 6ns」變成0 (剛好等於算出的setup time) -> 應該成功變成0
    //  (3) case B: D 在 CLK 下降緣「前 2ns」才變成0 (明顯小於setup time) -> 應該失敗，Q 應該還停在 1（或跑出不確定/錯誤值）
    // ============================================================

    initial begin
        // ---- power up ----
        D = 1; CLK = 1;
        #10 CLK = 0;   // 第一次下降緣，Q應該被設成1
        #10 CLK = 1;

        // ---- Case A: setup time 剛好滿足 (D 在edge前 6ns 改變) ----
        #20;                 // CLK=1 一段時間, 讓狀態穩定
        #14 D = 0;            // D 在此時改變 (1->0)
        #6  CLK = 0;          // edge 發生在 D 改變後 6ns -> 滿足 setup time, 預期 Q 成功變成 0
        #20 CLK = 1;
        #10 D = 1;             // 把D跟Q都重置回1，準備下一個測試
        #10 CLK = 0;
        #10 CLK = 1;

        // ---- Case B: setup time 不足 (D 在edge前只有 2ns 改變) ----
        #20;
        #4  D = 0;             // D 在此時改變 (1->0)
        #2  CLK = 0;           // edge 發生在 D 改變後只有 2ns -> 違反 setup time, 預期 Q 沒有正確變成 0
        #20 CLK = 1;

        #20 $finish;
    end
endmodule
