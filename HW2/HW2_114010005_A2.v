`timescale 1ns / 1ps

module DEMUX_tb;

    reg A;
    reg [1:0] S;
    wire X, Y, Z;

    // instantiate the DEMUX (device under test)
    DEMUX uut (
        .A(A),
        .S(S),
        .X(X),
        .Y(Y),
        .Z(Z)
    );

    // 產生 GTKWave 要看的波形檔
    initial begin
        $dumpfile("DEMUX.vcd");
        $dumpvars(0, DEMUX_tb);
    end

    // 窮舉所有 8 種輸入組合 (A: 2 種 x S: 4 種)
    initial begin
        A = 0; S = 2'b00;
        #10 A = 1; S = 2'b00;
        #10 A = 0; S = 2'b01;
        #10 A = 1; S = 2'b01;
        #10 A = 0; S = 2'b10;
        #10 A = 1; S = 2'b10;
        #10 A = 0; S = 2'b11;
        #10 A = 1; S = 2'b11;
        #10 $finish;
    end

    // 在 terminal 印出每個時間點的訊號，方便對照波形
    initial begin
        $monitor("time=%0t | A=%b S=%b || X=%b Y=%b Z=%b", $time, A, S, X, Y, Z);
    end

endmodule
