module circuit_2(A, B, C, D, F);
    input A, B, C, D;
    output F;
    wire W1, W2, W3;

    assign F = ~((A & B) | (C & D));
endmodule