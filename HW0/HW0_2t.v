`timescale 1ns/1ps

module testbench;
    reg [7:0]A;
    reg [7:0]B;
    wire [7:0]C;
    wire N;

    circuit_2 U0(A, B, C, N);

    initial begin
        $dumpfile("HW0_2.vcd");
        $dumpvars(0, testbench);
    end

    initial begin
        A = 8'b0000_0001;
        B = 8'b0000_0001;
        #(10)
        A = 8'b10;
        B = 8'b11;
        #(10)
        A = 8'd10;
        B = 8'd11;
        #(10)
        A = 8'h10;
        B = 8'h11;
        #(10)
        A = 8'hff;
        B = 8'h00;
        #(10);
        $finish;
    end
endmodule