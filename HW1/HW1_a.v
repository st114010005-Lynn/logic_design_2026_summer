/*
Pi = Ai ⊕ Bi
Gi = Ai ． Bi

C1 = G0 + P0 ． C0
C2 = G1 + P1 ． C1 = G1 + P1 ． G0 + P1 ． P0 ． C0
C3 = G2 + P2 ． C2 = G2 + P2 ． G1 + P2 ． P1 ． G0 + P2 ． P1 ． P0 ． C0
C4 = G3 + P3 ． C3 = G3 + P3 ． G2 + P3 ． P2 ． G1 + P3 ． P2 ． P1 ． G0 + P3 ． P2 ． P1 ． P0 ． C0
*/


// 2輸入 XOR 閘 
module XOR2 (output out, input in1, input in2);
    xor (out, in1, in2);
endmodule

// 2輸入 AND 閘 
module AND2 (output out, input in1, input in2);
    and (out, in1, in2);
endmodule

// 3輸入 AND 閘 
module AND3 (output out, input in1, input in2, input in3);
    and (out, in1, in2, in3);
endmodule

// 4輸入 AND 閘
module AND4 (output out, input in1, input in2, input in3, input in4);
    and (out, in1, in2, in3, in4);
endmodule

// 5輸入 AND 閘
module AND5 (output out, input in1, input in2, input in3, input in4, input in5);
    and (out, in1, in2, in3, in4, in5);
endmodule

// 2輸入 OR 閘
module OR2 (output out, input in1, input in2);
    or (out, in1, in2);
endmodule

// 3輸入 OR 閘
module OR3 (output out, input in1, input in2, input in3);
    or (out, in1, in2, in3);
endmodule

// 4輸入 OR 閘
module OR4 (output out, input in1, input in2, input in3, input in4);
    or (out, in1, in2, in3, in4);
endmodule

// 5輸入 OR 閘
module OR5 (output out, input in1, input in2, input in3, input in4, input in5);
    or (out, in1, in2, in3, in4, in5);
endmodule


module cla_4bit (
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout,
    output       c3_out // 專門拉出來給全域計算 Overflow 使用的 C3 訊號
);
    wire g0, g1, g2, g3;
    wire p0, p1, p2, p3;
    wire c1, c2, c3;

    // 1. 產生 Generate (G) 與 Propagate (P)
    XOR2 xor_p0(p0, a[0], b[0]);
    XOR2 xor_p1(p1, a[1], b[1]);
    XOR2 xor_p2(p2, a[2], b[2]);
    XOR2 xor_p3(p3, a[3], b[3]);

    AND2 and_g0(g0, a[0], b[0]);
    AND2 and_g1(g1, a[1], b[1]);
    AND2 and_g2(g2, a[2], b[2]);
    AND2 and_g3(g3, a[3], b[3]);

    // 2. 超前進位邏輯電路 (Carry Logic)
    // C1 = g0 + p0*cin
    wire p0_cin;
    AND2 a_c1_1(p0_cin, p0, cin);
    OR2  o_c1(c1, g0, p0_cin);

    // C2 = g1 + p1*g0 + p1*p0*cin
    wire p1_g0, p1_p0_cin;
    AND2 a_c2_1(p1_g0, p1, g0);
    AND3 a_c2_2(p1_p0_cin, p1, p0, cin);
    OR3  o_c2(c2, g1, p1_g0, p1_p0_cin);

    // C3 = g2 + p2*g1 + p2*p1*g0 + p2*p1*p0*cin
    wire p2_g1, p2_p1_g0, p2_p1_p0_cin;
    AND2 a_c3_1(p2_g1, p2, g1);
    AND3 a_c3_2(p2_p1_g0, p2, p1, g0);
    AND4 a_c3_3(p2_p1_p0_cin, p2, p1, p0, cin);
    OR4  o_c3(c3, g2, p2_g1, p2_p1_g0, p2_p1_p0_cin);
    assign c3_out = c3; // 將內部 C3 接到輸出引腳

    // Cout (C4) = g3 + p3*g2 + p3*p2*g1 + p3*p2*p1*g0 + p3*p2*p1*p0*cin
    wire p3_g2, p3_p2_g1, p3_p2_p1_g0, p3_p2_p1_p0_cin;
    AND2 a_c4_1(p3_g2, p3, g2);
    AND3 a_c4_2(p3_p2_g1, p3, p2, g1);
    AND4 a_c4_3(p3_p2_p1_g0, p3, p2, p1, g0);
    AND5 a_c4_4(p3_p2_p1_p0_cin, p3, p2, p1, p0, cin);
    OR5  o_c4(cout, g3, p3_g2, p3_p2_g1, p3_p2_p1_g0, p3_p2_p1_p0_cin);

    // 3. 計算最終的 Sum = P ⊕ C
    XOR2 xor_s0(sum[0], p0, cin);
    XOR2 xor_s1(sum[1], p1, c1);
    XOR2 xor_s2(sum[2], p2, c2);
    XOR2 xor_s3(sum[3], p3, c3);

endmodule


module CLA_AddSub_8bit(
    input  [7:0] a, b,      // 8位元輸入
    input        mode,      // 0 = 加法, 1 = 減法
    output [7:0] s,         // 8位元輸出結果
    output       c8,        // 最終進位輸出
    output       overflow   // 有號數溢位旗標
);

    wire [7:0] b_in;        // 經過 mode 控制後的 B 輸入
    wire       c_mid;       // 低位 4-bit CLA 傳給高位 4-bit CLA 的進位 (即全域 C4)
    wire       c7;          // 高位 4-bit CLA 內部的 C3 輸出 (即全域 C7)
    wire       dummy_c3;    // 低位 CLA 的 c3_out 在頂層用不到，宣告一條空線來接

    // 1. 控制輸入 B (加法不變，減法反相)
    // 利用 XOR 閘實作控制反相器：B_in = B ⊕ mode
    XOR2 ctrl_b0(b_in[0], b[0], mode);
    XOR2 ctrl_b1(b_in[1], b[1], mode);
    XOR2 ctrl_b2(b_in[2], b[2], mode);
    XOR2 ctrl_b3(b_in[3], b[3], mode);
    XOR2 ctrl_b4(b_in[4], b[4], mode);
    XOR2 ctrl_b5(b_in[5], b[5], mode);
    XOR2 ctrl_b6(b_in[6], b[6], mode);
    XOR2 ctrl_b7(b_in[7], b[7], mode);

    // 2. 實例化低 4 位元 CLA 加法器 (處理 bit 0 ~ 3)
    // 這裡的 cin 直接接 mode (加法時為0，減法時為1提供二補數的+1)
    cla_4bit cla_low (
        .a(a[3:0]),
        .b(b_in[3:0]),
        .cin(mode),
        .sum(s[3:0]),
        .cout(c_mid),
        .c3_out(dummy_c3)
    );

    // 3. 實例化高 4 位元 CLA 加法器 (處理 bit 4 ~ 7)
    // 這裡的 cin 接低位加法器的 cout (c_mid)
    // 這裡輸出的 c3_out 對應到整個 8-bit 加法器的第 7 個進位 (c7)，是用來算溢位的
    cla_4bit cla_high (
        .a(a[7:4]),
        .b(b_in[7:4]),
        .cin(c_mid),
        .sum(s[7:4]),
        .cout(c8),
        .c3_out(c7)
    );

    // 4. 計算有號數溢位 Flag (Overflow = C8 ⊕ C7)
    XOR2 xor_overflow(overflow, c8, c7);

endmodule