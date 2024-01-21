module cv32e40p_mult_hardened
  import cv32e40p_pkg::*;
(
    input logic clk,
    input logic rst_n,

    input logic        enable_i,
    input mul_opcode_e operator_i,

    // integer and short multiplier
    input logic       short_subword_i,
    input logic [1:0] short_signed_i,

    input logic [31:0] op_a_i,
    input logic [31:0] op_b_i,
    input logic [31:0] op_c_i,

    input logic [4:0] imm_i,


    // dot multiplier
    input logic [ 1:0] dot_signed_i,
    input logic [31:0] dot_op_a_i,
    input logic [31:0] dot_op_b_i,
    input logic [31:0] dot_op_c_i,
    input logic        is_clpx_i,
    input logic [ 1:0] clpx_shift_i,
    input logic        clpx_img_i,

    output logic [31:0] result_o,

    output logic multicycle_o,
    output logic mulh_active_o,
    output logic ready_o,
    input  logic ex_ready_i,

    output logic mult_fault
);

  logic [31:0] mult_result_1;
  logic [31:0] mult_result_2;
  logic [31:0] mult_result_3;
  logic        mult_multicycle_o_1;
  logic        mult_multicycle_o_2;
  logic        mult_multicycle_o_3;
  logic        mulh_active_1;
  logic        mult_ready_1;
  logic        mulh_active_2;
  logic        mult_ready_2;
  logic        mulh_active_3;
  logic        mult_ready_3;

  // MUL fault
  logic        mult_fault_1;
  logic        mult_fault_2;
  logic        mult_fault_3;
  logic        mult_fault_4;

  cv32e40p_mult mult_i_1 (
      .clk  (clk),
      .rst_n(rst_n),

      .enable_i  (enable_i),
      .operator_i(operator_i),

      .short_subword_i(short_subword_i),
      .short_signed_i (short_signed_i),

      .op_a_i(op_a_i),
      .op_b_i(op_b_i),
      .op_c_i(op_c_i),
      .imm_i (imm_i),

      .dot_op_a_i  (dot_op_a_i),
      .dot_op_b_i  (dot_op_b_i),
      .dot_op_c_i  (dot_op_c_i),
      .dot_signed_i(dot_signed_i),
      .is_clpx_i   (is_clpx_i),
      .clpx_shift_i(clpx_shift_i),
      .clpx_img_i  (clpx_img_i),

      .result_o(mult_result_1),

      .multicycle_o (mult_multicycle_o_1),
      .mulh_active_o(mulh_active_1),
      .ready_o      (mult_ready_1),
      .ex_ready_i   (ex_ready_i)
  );

  cv32e40p_mult mult_i_2 (
      .clk  (clk),
      .rst_n(rst_n),

      .enable_i  (enable_i),
      .operator_i(operator_i),

      .short_subword_i(short_subword_i),
      .short_signed_i (short_signed_i),

      .op_a_i(op_a_i),
      .op_b_i(op_b_i),
      .op_c_i(op_c_i),
      .imm_i (imm_i),

      .dot_op_a_i  (dot_op_a_i),
      .dot_op_b_i  (dot_op_b_i),
      .dot_op_c_i  (dot_op_c_i),
      .dot_signed_i(dot_signed_i),
      .is_clpx_i   (is_clpx_i),
      .clpx_shift_i(clpx_shift_i),
      .clpx_img_i  (clpx_img_i),

      .result_o(mult_result_2),

      .multicycle_o (mult_multicycle_o_2),
      .mulh_active_o(mulh_active_2),
      .ready_o      (mult_ready_2),
      .ex_ready_i   (ex_ready_i)
  );

  cv32e40p_mult mult_i_3 (
      .clk  (clk),
      .rst_n(rst_n),

      .enable_i  (enable_i),
      .operator_i(operator_i),

      .short_subword_i(short_subword_i),
      .short_signed_i (short_signed_i),

      .op_a_i(op_a_i),
      .op_b_i(op_b_i),
      .op_c_i(op_c_i),
      .imm_i (imm_i),

      .dot_op_a_i  (dot_op_a_i),
      .dot_op_b_i  (dot_op_b_i),
      .dot_op_c_i  (dot_op_c_i),
      .dot_signed_i(dot_signed_i),
      .is_clpx_i   (is_clpx_i),
      .clpx_shift_i(clpx_shift_i),
      .clpx_img_i  (clpx_img_i),

      .result_o(mult_result_3),

      .multicycle_o (mult_multicycle_o_3),
      .mulh_active_o(mulh_active_3),
      .ready_o      (mult_ready_3),
      .ex_ready_i   (ex_ready_i)
  );

  cv32e40p_3voter #(
      .NBIT(1)
  ) voter_1 (
      .a(mult_multicycle_o_1),
      .b(mult_multicycle_o_2),
      .c(mult_multicycle_o_3),
      .fault(mult_fault_1),
      .winner(multicycle_o)
  );

  cv32e40p_3voter #(
      .NBIT(1)
  ) voter_2 (
      .a(mulh_active_1),
      .b(mulh_active_2),
      .c(mulh_active_3),
      .fault(mult_fault_2),
      .winner(mulh_active_o)
  );

  cv32e40p_3voter #(
      .NBIT(1)
  ) voter_3 (
      .a(mult_ready_1),
      .b(mult_ready_2),
      .c(mult_ready_3),
      .fault(mult_fault_3),
      .winner(mult_ready_o)
  );

  cv32e40p_3voter #(
      .NBIT(32)
  ) voter_4 (
      .a(mult_result_1),
      .b(mult_result_2),
      .c(mult_result_3),
      .fault(mult_fault_4),
      .winner(result_o)
  );


  assign mult_fault = mult_fault_1 || mult_fault_2 || mult_fault_3 || mult_fault_4;

endmodule
