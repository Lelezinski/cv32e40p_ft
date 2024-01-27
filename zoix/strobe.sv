// ZOIX MODULE FOR FAULT INJECTION AND STROBING

`timescale 1ps / 1ps

`ifndef TOPLEVEL
	`define TOPLEVEL cv32e40p_top
`endif

module strobe;


// Inject faults
initial begin

        $display("ZOIX INJECTION");
        //$fs_inject;       // by default

        $fs_delete;			// CHECK THIS
        $fs_add(`TOPLEVEL);		// CHECK THIS

end


// Strobe point
initial begin

        //#`START_TIME;
        #59990; //equivalent to strobe_offset tmax
        forever begin

        //OUTPUTS

                $fs_strobe(`TOPLEVEL.instr_req_o);
                $fs_strobe(`TOPLEVEL.data_req_o);
                $fs_strobe(`TOPLEVEL.data_we_o);
                $fs_strobe(`TOPLEVEL.instr_addr_o);
                $fs_strobe(`TOPLEVEL.data_addr_o);
                $fs_strobe(`TOPLEVEL.data_wdata_o);
                $fs_strobe(`TOPLEVEL.data_be_o);

		// $fs_strobe(`TOPLEVEL.rf_fault_o);
		// $fs_strobe(`TOPLEVEL.mult_fault_o);	
		// $fs_strobe(`TOPLEVEL.alu_fault_o);

		// strobe all no voter
		// $fs_strobe(`TOPLEVEL.core_i.ex_stage_i.mult_i.mult_i_1);
		// $fs_strobe(`TOPLEVEL.core_i.ex_stage_i.mult_i.mult_i_2);
		// $fs_strobe(`TOPLEVEL.core_i.ex_stage_i.mult_i.mult_i_3);

		//$fs_strobe(`TOPLEVEL.core_i.ex_stage_i.mult_i.mult_voter_result.winner_o);
		//$fs_strobe(`TOPLEVEL.core_i.ex_stage_i.mult_i.mult_voter_mulh_active.fault_o);
		//$fs_strobe(`TOPLEVEL.core_i.ex_stage_i.mult_i.mult_voter_multicycle.winner_o);
		//$fs_strobe(`TOPLEVEL.core_i.ex_stage_i.mult_i.mult_voter_ready.winner_o);

		//$fs_strobe(`TOPLEVEL.core_i.id_stage_i.register_file_i.rf_voter_a.winner_o);
		//$fs_strobe(`TOPLEVEL.core_i.id_stage_i.register_file_i.rf_voter_b.winner_o);
		//$fs_strobe(`TOPLEVEL.core_i.id_stage_i.register_file_i.rf_voter_c.winner_o);

		$fs_strobe(`TOPLEVEL.core_i.ex_stage_i.mult_i.mult_voter_result);
                #10000; // TMAX Strobe period
        end

end



endmodule
