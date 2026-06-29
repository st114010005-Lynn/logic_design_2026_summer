module circuit_2(A, B, C, D, F);
    input A, B, C, D;
    output F;
    wire W1, W2, W3;

    and g1(W1, A, B);
    and g2(W2, C, D);
    or g3(W3, W1, W2);
    not g4(F, W3);
endmodule