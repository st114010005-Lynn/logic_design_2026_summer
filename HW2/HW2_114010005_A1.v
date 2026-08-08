module DEMUX(A, S, X, Y, Z);
    input A;
    input [1:0] S;
    output X, Y, Z;

    // behavioural, tri-state description
    // 依照作業圖片的真值表：
    //   S=00 -> X,Y,Z 皆為 Hi-Z (未選取任何輸出)
    //   S=01 -> X = A
    //   S=10 -> Y = A
    //   S=11 -> Z = A
    // 未被選到的輸出則變成高阻抗 (z)
    assign X = (S == 2'b01) ? A : 1'bz;
    assign Y = (S == 2'b10) ? A : 1'bz;
    assign Z = (S == 2'b11) ? A : 1'bz;

endmodule
