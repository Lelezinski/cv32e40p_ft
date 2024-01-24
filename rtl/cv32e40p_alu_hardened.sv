// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

////////////////////////////////////////////////////////////////////////////////
// Engineer:       Matthias Baer - baermatt@student.ethz.ch                   //
//                                                                            //
// Additional contributions by:                                               //
//                 Igor Loi - igor.loi@unibo.it                               //
//                 Andreas Traber - atraber@student.ethz.ch                   //
//                 Michael Gautschi - gautschi@iis.ee.ethz.ch                 //
//                 Davide Schiavone - pschiavo@iis.ee.ethz.ch                 //
//                                                                            //
// Design Name:    ALU                                                        //
// Project Name:   RI5CY                                                      //
// Language:       SystemVerilog                                              //
//                                                                            //
// Description:    Arithmetic logic unit of the pipelined processor           //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

module cv32e40p_alu_hardened
  import cv32e40p_pkg::*;
(
    input logic               clk,
    input logic               rst_n,
    input logic               enable_i,
    input alu_opcode_e        operator_i,
    input logic        [31:0] operand_a_i,
    input logic        [31:0] operand_b_i,
    input logic        [31:0] operand_c_i,

    input logic [1:0] vector_mode_i,
    input logic [4:0] bmask_a_i,
    input logic [4:0] bmask_b_i,
    input logic [1:0] imm_vec_ext_i,

    input logic       is_clpx_i,
    input logic       is_subrot_i,
    input logic [1:0] clpx_shift_i,

    output logic [31:0] result_o,
    output logic        comparison_result_o,

    output logic ready_o,
    input  logic ex_ready_i,

    output logic alu_fault_o
);

  logic [31:0] result_1;
  logic [31:0] result_2;
  logic [31:0] result_3;
  logic comparison_result_1, comparison_result_2, comparison_result_3;
  logic ready_1, ready_2, ready_3;

  logic result_fault, comparison_result_fault, ready_fault;

  // ALUs
  cv32e40p_alu alu_1_i (
      .clk        (clk),
      .rst_n      (rst_n),
      .enable_i   (enable_i),
      .operator_i (operator_i),
      .operand_a_i(operand_a_i),
      .operand_b_i(operand_b_i),
      .operand_c_i(operand_c_i),

      .vector_mode_i(vector_mode_i),
      .bmask_a_i    (bmask_a_i),
      .bmask_b_i    (bmask_b_i),
      .imm_vec_ext_i(imm_vec_ext_i),

      .is_clpx_i   (is_clpx_i),
      .clpx_shift_i(clpx_shift_i),
      .is_subrot_i (is_subrot_i),

      .result_o           (result_1),
      .comparison_result_o(comparison_result_1),

      .ready_o   (ready_1),
      .ex_ready_i(ex_ready_i)
  );

  cv32e40p_alu alu_2_i (
      .clk        (clk),
      .rst_n      (rst_n),
      .enable_i   (enable_i),
      .operator_i (operator_i),
      .operand_a_i(operand_a_i),
      .operand_b_i(operand_b_i),
      .operand_c_i(operand_c_i),

      .vector_mode_i(vector_mode_i),
      .bmask_a_i    (bmask_a_i),
      .bmask_b_i    (bmask_b_i),
      .imm_vec_ext_i(imm_vec_ext_i),

      .is_clpx_i   (is_clpx_i),
      .clpx_shift_i(clpx_shift_i),
      .is_subrot_i (is_subrot_i),

      .result_o           (result_2),
      .comparison_result_o(comparison_result_2),

      .ready_o   (ready_2),
      .ex_ready_i(ex_ready_i)
  );

  cv32e40p_alu alu_3_i (
      .clk        (clk),
      .rst_n      (rst_n),
      .enable_i   (enable_i),
      .operator_i (operator_i),
      .operand_a_i(operand_a_i),
      .operand_b_i(operand_b_i),
      .operand_c_i(operand_c_i),

      .vector_mode_i(vector_mode_i),
      .bmask_a_i    (bmask_a_i),
      .bmask_b_i    (bmask_b_i),
      .imm_vec_ext_i(imm_vec_ext_i),

      .is_clpx_i   (is_clpx_i),
      .clpx_shift_i(clpx_shift_i),
      .is_subrot_i (is_subrot_i),

      .result_o           (result_3),
      .comparison_result_o(comparison_result_3),

      .ready_o   (ready_3),
      .ex_ready_i(ex_ready_i)
  );

  // Voters
  cv32e40p_3voter #(
	.DATA_WIDTH(32)
  ) alu_voter_result (
	.a_i(result_1),
	.b_i(result_2),
	.c_i(result_3),
        .fault_o(result_fault),
  	.winner_o(result_o)
  );

  cv32e40p_3voter #(
	.DATA_WIDTH(1)
  ) alu_voter_ready (
	.a_i(ready_1),
	.b_i(ready_2),
	.c_i(ready_3),
        .fault_o(ready_fault),
  	.winner_o(ready_o)
  );

  cv32e40p_3voter #(
	.DATA_WIDTH(1)
  ) alu_voter_comparison_result (
	.a_i(comparison_result_1),
	.b_i(comparison_result_2),
	.c_i(comparison_result_3),
        .fault_o(comparison_result_fault),
  	.winner_o(comparison_result_o)
  );

  assign alu_fault_o = result_fault || comparison_result_fault || ready_fault ; // fault k
endmodule
