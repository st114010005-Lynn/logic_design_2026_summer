`timescale 1ns/1ps
module DFF_func_tb;
    reg D, CLK;
    wire Q, nQ;

    DFF uut(.D(D), .CLK(CLK), .Q(Q), .nQ(nQ));

    initial begin
        $dumpfile("DFF_func.vcd");
        $dumpvars(0, DFF_func_tb);
    end

    initial begin
        D   = 0;
        CLK = 1;      // 先讓CLK=1一段時間(>4ns), 使Master latch resolve成已知值
        #20 CLK = 0;  // 第一次下降緣：讓Slave也跟著resolve成已知值；Q應該變成 D=0
        #20 CLK = 1;
        #10 D = 1;    // 在CLK=1的中間改變 D
        #30 CLK = 0;  // 下降緣：Q應該變成 1
        #20 CLK = 1;
        #10 D = 0;    // 在CLK=1的中間改變 D
        #30 CLK = 0;  // 下降緣：Q應該變回 0
        #20 CLK = 1;
        #40 $finish;
    end

    initial $monitor("t=%0t CLK=%b D=%b | Q=%b nQ=%b", $time, CLK, D, Q, nQ);
endmodule
