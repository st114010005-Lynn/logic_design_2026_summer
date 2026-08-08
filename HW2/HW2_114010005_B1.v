`timescale 1ns/1ps
module DFF(D, CLK, Q, nQ);
    input D, CLK;
    output Q, nQ;

    wire nD, nCLK;
    wire nS1, nR1, Q1, nQ1;
    wire nS2, nR2;

    // inverters: 0 delay (no #delay specified)
    not (nD, D);
    not (nCLK, CLK);

    // ---- Master latch (transparent when CLK = 1) ----
    nand #2 g1(nS1, D,  CLK);
    nand #2 g2(nR1, nD, CLK);
    nand #2 g3(Q1,  nS1, nQ1);
    nand #2 g4(nQ1, nR1, Q1);

    // ---- Slave latch (transparent when CLK = 0, i.e. nCLK = 1) ----
    nand #2 g5(nS2, Q1,  nCLK);
    nand #2 g6(nR2, nQ1, nCLK);
    nand #2 g7(Q,  nS2, nQ);
    nand #2 g8(nQ, nR2, Q);

endmodule
