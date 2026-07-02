import uvm_pkg::*;  /* Importing UVM configurations */
`include "uvm_macros.svh"
`include "top.sv"         /*Including all TB Files*/
`include "interface.sv"
`include "common.sv"
`include "Write_tx.sv"
`include "Write_driver.sv"
`include "Write_monitor.sv"
`include "Write_cov.sv"
`include "Write_sqr.sv"
`include "Write_seq_lib.sv"
`include "Read_tx.sv"
`include "Read_driver.sv"
`include "Read_sqr.sv"
`include "Read_cov.sv"
`include "Read_monitor.sv"
`include "Read_seq_lib.sv"
`include "scoreboard.sv"
`include "Read_Agent.sv"
`include "Write_Agent.sv"
`include "env.sv"
`include "fifo_test_library.sv"
`include "fifo_report_server.sv"
module async_fifo_TB;

 
 interface_fifo in();

 
 asynchronous_fifo as_fifo (.w_clk(in.w_clk),.wrst_n(in.wrst_n),.r_clk(in.r_clk),.rrst_n(in.rrst_n),
                            .w_en(in.w_en),.r_en(in.r_en),.data_in(in.data_in),.data_out(in.data_out),.full(in.full),.empty(in.empty),.write_error(in.write_error),
                            .read_error(in.read_error));


  always #2.083ns in.w_clk = ~in.w_clk;
  always #1.25ns in.r_clk = ~in.r_clk;


  //Reset Condition
 initial begin
    in.w_clk = 1;
    in.r_clk = 1;
    in.wrst_n = 1'b0;
    in.w_en = 1'b0;
    in.data_in = 0;
    in.r_clk = 1'b0; 
    in.rrst_n = 1'b0;
    in.r_en = 1'b0; 
    repeat(2) @(posedge in.w_clk);
    in.wrst_n = 1'b1;
    in.rrst_n = 1'b1;
 end 


 /*Seting Virtual Interface Using Resource TB*/
initial begin 
				uvm_resource_db#(virtual interface_fifo)::set("ALL","TB",in,null);
end

initial begin
				run_test();
end

endmodule


class log_test extends uvm_test;
  `uvm_component_utils(log_test)

  function new(string name = "log_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_top.set_report_verbosity_level(UVM_MEDIUM);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info("TEST_LOG", "Simulation started", UVM_MEDIUM)
    `uvm_warning("TEST_LOG", "Warning: Possible issue detected")
    `uvm_error("TEST_LOG", "Error: Something went wrong")

    phase.drop_objection(this);
  endtask
endclass