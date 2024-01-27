`timescale 1ns/1ps

module cv32e40p_3voter_tb;

  parameter DATA_WIDTH = 32;

  logic [DATA_WIDTH - 1:0] a_i, b_i, c_i;

  logic fault_o;
  logic [DATA_WIDTH - 1:0] winner_o;

  cv32e40p_3voter #(
    .DATA_WIDTH(DATA_WIDTH)
  ) uut (
    .a_i(a_i),
    .b_i(b_i),
    .c_i(c_i),
    .fault_o(fault_o),
    .winner_o(winner_o)
  );

  reg clk = 0;
  always #5 clk = ~clk;

  // Test stimulus
  initial begin
    // Initialize inputs
    a_i = 0;
    b_i = 0;
    c_i = 0;

    // Apply stimulus
    #10 a_i = 8;
    #10 b_i = 8;
    // all the same 
    #10 c_i = 8;
    // a_i == c_i 
    #10 b_i = 16;

    // b_i == c_i
    #10 a_i = 16;

    #10 b_i = 12;
    #10 c_i = 18;

    // Wait for simulation to complete
    #100 $finish;
  end

  // Display results
  always @(posedge clk) begin
    $display("Time: %t, a_i: %0d, b_i: %0d, c_i: %0d, winner_o: %0d, fault_o: %0d", $time, a_i, b_i, c_i, winner_o, fault_o);
  end

endmodule
