module cv32e40p_3voter
# (
    parameter DATA_WIDTH = 32
)
(
    input logic [DATA_WIDTH - 1:0] a_i,
    input logic [DATA_WIDTH - 1:0] b_i,
    input logic [DATA_WIDTH - 1:0] c_i,

    output logic fault_o,
    output logic [DATA_WIDTH - 1:0] winner_o
);

  always_comb begin
    fault_o = 1;
    winner_o = a_i;

    if (a_i == b_i) begin
      if (a_i == c_i) begin
        winner_o = a_i;
        fault_o = 0;
      end
      else begin
        winner_o = a_i;
      end
    end else begin // a_i != b_i
      if (a_i == c_i) begin
        winner_o = a_i;
      end else if (b_i == c_i) begin
        winner_o = b_i;
      end
    end
  end

endmodule
