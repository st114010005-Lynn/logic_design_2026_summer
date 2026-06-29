`timescale 1ns/1ps
//Set time scale to this for all homework

module testbench;
    reg A, B, C, D;
    //reg stands for register
    wire F;

    circuit_2 U0(A, B, C, D, F);

    //The initial block only ran once during the stimulation
    //Only use initial block here, not in the design file
    initial begin
        $dumpfile("HW0_1.vcd");
        $dumpvars(0, testbench);
    end

    //The second initial block alters the input signal
    initial begin
        {A, B, C, D} = 4'b0000;
        #(10) {A, B, C, D} = 4'b0001;
        #(10) {A, B, C, D} = 4'b0010;
        #(10) {A, B, C, D} = 4'b0011;
        #(10) {A, B, C, D} = 4'b0100;
        #(10) {A, B, C, D} = 4'b0101;
        #(10) {A, B, C, D} = 4'b0110;
        #(10) {A, B, C, D} = 4'b0111;
        #(10) {A, B, C, D} = 4'b1000;
        #(10) {A, B, C, D} = 4'b1001;
        #(10) {A, B, C, D} = 4'b1010;
        #(10) {A, B, C, D} = 4'b1011;
        #(10) {A, B, C, D} = 4'b1100;
        #(10) {A, B, C, D} = 4'b1101;
        #(10) {A, B, C, D} = 4'b1110;
        #(10) {A, B, C, D} = 4'b1111;

        /*#(10) means delay for 10 time units
        {A, B, C, D} allows us to assing to 4 signals at once
        4'b0000 means 4-bits of value 0000 binary*/

        $finish;
        //Use $finish at the end of your stimulation
    
    end
endmodule
