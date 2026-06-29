module circuit_2(A, B, C, N);
    input [7:0]A;
    input [7:0]B;
    output [7:0]C;
    output N;

    assign C = A + B;
    assign N = C[7];
endmodule

