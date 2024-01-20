module cv32e40p_3voter
  import cv32e40p_pkg::*;
# (
    parameter NBIT = 32
)
(
    input logic [NBIT - 1:0] a,
    input logic [NBIT - 1:0] b,
    input logic [NBIT - 1:0] c,
    output logic fault,
    output logic [NBIT - 1:0] winner
);

  logic fault_i;

  always_comb begin
    fault_i = 0;

    if (a == b) begin
      if (a != c) begin
        fault_i = 1;
      end
      winner = a;
    end else begin
      fault_i = 1;
      winner = c;
    end
  end

  assign fault = fault_i;
endmodule
