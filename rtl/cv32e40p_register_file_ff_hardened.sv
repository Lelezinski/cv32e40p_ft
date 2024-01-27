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
// Engineer:       Francesco Conti - f.conti@unibo.it                         //
//                                                                            //
// Additional contributions by:                                               //
//                 Michael Gautschi - gautschi@iis.ee.ethz.ch                 //
//                 Davide Schiavone - pschiavo@iis.ee.ethz.ch                 //
//                                                                            //
// Design Name:    RISC-V register file                                       //
// Project Name:   RI5CY                                                      //
// Language:       SystemVerilog                                              //
//                                                                            //
// Description:    Register file with 31x 32 bit wide registers. Register 0   //
//                 is fixed to 0. This register file is based on flip-flops.  //
//                 Also supports the fp-register file now if FPU=1            //
//                 If ZFINX is 1, floating point operations take values       //
//                 from the X register file                                   //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

module cv32e40p_register_file_hardened #(
    parameter ADDR_WIDTH = 5,
    parameter DATA_WIDTH = 32,
    parameter FPU        = 0,
    parameter ZFINX      = 0
) (
    // Clock and Reset
    input logic clk,
    input logic rst_n,

    input logic scan_cg_en_i,

    //Read port R1
    input  logic [ADDR_WIDTH-1:0] raddr_a_i,
    output logic [DATA_WIDTH-1:0] rdata_a_o,

    //Read port R2
    input  logic [ADDR_WIDTH-1:0] raddr_b_i,
    output logic [DATA_WIDTH-1:0] rdata_b_o,

    //Read port R3
    input  logic [ADDR_WIDTH-1:0] raddr_c_i,
    output logic [DATA_WIDTH-1:0] rdata_c_o,

    // Write port W1
    input logic [ADDR_WIDTH-1:0] waddr_a_i,
    input logic [DATA_WIDTH-1:0] wdata_a_i,
    input logic                  we_a_i,

    // Write port W2
    input logic [ADDR_WIDTH-1:0] waddr_b_i,
    input logic [DATA_WIDTH-1:0] wdata_b_i,
    input logic                  we_b_i,

    // Fault
    output logic rf_fault_o
);

logic [DATA_WIDTH-1:0] rdata_a_1;
logic [DATA_WIDTH-1:0] rdata_a_2;
logic [DATA_WIDTH-1:0] rdata_a_3;
logic [DATA_WIDTH-1:0] rdata_b_1;
logic [DATA_WIDTH-1:0] rdata_b_2;
logic [DATA_WIDTH-1:0] rdata_b_3;
logic [DATA_WIDTH-1:0] rdata_c_1;
logic [DATA_WIDTH-1:0] rdata_c_2;
logic [DATA_WIDTH-1:0] rdata_c_3;
logic                  rf_fault_a;
logic                  rf_fault_b;
logic                  rf_fault_c;

// Registers TMR
cv32e40p_register_file #(
    .ADDR_WIDTH(6),
    .DATA_WIDTH(32),
    .FPU       (FPU),
    .ZFINX     (ZFINX)
) register_file_1_i (
    .clk  (clk),
    .rst_n(rst_n),

    .scan_cg_en_i(scan_cg_en_i),

    // Read port a
    .raddr_a_i(raddr_a_i),
    .rdata_a_o(rdata_a_1),

    // Read port b
    .raddr_b_i(raddr_b_i),
    .rdata_b_o(rdata_b_1),

    // Read port c
    .raddr_c_i(raddr_c_i),
    .rdata_c_o(rdata_c_1),

    // Write port a
    .waddr_a_i(waddr_a_i),
    .wdata_a_i(wdata_a_i),
    .we_a_i   (we_a_i),

    // Write port b
    .waddr_b_i(waddr_b_i),
    .wdata_b_i(wdata_b_i),
    .we_b_i   (we_b_i)
);

cv32e40p_register_file #(
    .ADDR_WIDTH(6),
    .DATA_WIDTH(32),
    .FPU       (FPU),
    .ZFINX     (ZFINX)
) register_file_2_i (
    .clk  (clk),
    .rst_n(rst_n),

    .scan_cg_en_i(scan_cg_en_i),

    // Read port a
    .raddr_a_i(raddr_a_i),
    .rdata_a_o(rdata_a_2),

    // Read port b
    .raddr_b_i(raddr_b_i),
    .rdata_b_o(rdata_b_2),

    // Read port c
    .raddr_c_i(raddr_c_i),
    .rdata_c_o(rdata_c_2),

    // Write port a
    .waddr_a_i(waddr_a_i),
    .wdata_a_i(wdata_a_i),
    .we_a_i   (we_a_i),

    // Write port b
    .waddr_b_i(waddr_b_i),
    .wdata_b_i(wdata_b_i),
    .we_b_i   (we_b_i)
);

cv32e40p_register_file #(
    .ADDR_WIDTH(6),
    .DATA_WIDTH(32),
    .FPU       (FPU),
    .ZFINX     (ZFINX)
) register_file_3_i (
    .clk  (clk),
    .rst_n(rst_n),

    .scan_cg_en_i(scan_cg_en_i),

    // Read port a
    .raddr_a_i(raddr_a_i),
    .rdata_a_o(rdata_a_3),

    // Read port b
    .raddr_b_i(raddr_b_i),
    .rdata_b_o(rdata_b_3),

    // Read port c
    .raddr_c_i(raddr_c_i),
    .rdata_c_o(rdata_c_3),

    // Write port a
    .waddr_a_i(waddr_a_i),
    .wdata_a_i(wdata_a_i),
    .we_a_i   (we_a_i),

    // Write port b
    .waddr_b_i(waddr_b_i),
    .wdata_b_i(wdata_b_i),
    .we_b_i   (we_b_i)
);

// Voters
cv32e40p_3voter #(
    .DATA_WIDTH(32)
) rf_voter_a (
    .a_i(rdata_a_1),
    .b_i(rdata_a_2),
    .c_i(rdata_a_3),
    .fault_o(rf_fault_a),
    .winner_o(rdata_a_o)
);

cv32e40p_3voter #(
    .DATA_WIDTH(32)
) rf_voter_b (
    .a_i(rdata_b_1),
    .b_i(rdata_b_2),
    .c_i(rdata_b_3),
    .fault_o(rf_fault_b),
    .winner_o(rdata_b_o)
);

cv32e40p_3voter #(
    .DATA_WIDTH(32)
) rf_voter_c (
    .a_i(rdata_c_1),
    .b_i(rdata_c_2),
    .c_i(rdata_c_3),
    .fault_o(rf_fault_c),
    .winner_o(rdata_c_o)
);

// Fault Logic
assign rf_fault_o = rf_fault_a | rf_fault_b | rf_fault_c;

endmodule

