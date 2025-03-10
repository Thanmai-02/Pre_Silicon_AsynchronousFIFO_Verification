#Delete and create work library
if [file exists "work"] {vdel -all}
vlib work

#Compile the RTL source & Testbench Files
vlog -source -lint -sv +incdir+../src/rtl ../src/tb/testbench.sv

#Optimize and simulate
vopt async_fifo_TB -o async_fifo_TB_Opt +acc +cover=sbfec
vsim async_fifo_TB_Opt -coverage +UVM_TESTNAME=Fifo_wr
vsim async_fifo_TB_Opt -coverage +UVM_TESTNAME=Fifo_wr -l uvm_output.log

#Setup VCD file and Logging
vcd file async_fifo_TB.vcd
vcd add -r async_fifo_TB/*
set NoQuitOnFinish 1
onbreak {resume}
log /* -r

#Run Simulation
run -all

#Save Coverage data
coverage save Fifo_wr.ucdb
quit -sim

vopt async_fifo_TB -o async_fifo_TB_Opt +acc +cover=sbfec
vsim async_fifo_TB_Opt -coverage +UVM_TESTNAME=Full_wr

#Setup VCD file and Logging
vcd file async_fifo_TB.vcd
vcd add -r async_fifo_TB/*
set NoQuitOnFinish 1
onbreak {resume}
log /* -r

#Run Simulation
run -all

#Save Coverage data
coverage save Full_wr.ucdb
quit -sim

vopt async_fifo_TB -o async_fifo_TB_Opt +acc +cover=sbfec
vsim async_fifo_TB_Opt -coverage +UVM_TESTNAME=Fifo_rd

set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all

coverage save Fifo_rd.ucdb
quit -sim

#--------------------------------------------------------------
#This process is repeated for UVM test: Fifo_wr_rd

vopt async_fifo_TB -o async_fifo_TB_Opt +acc +cover=sbfec
vsim async_fifo_TB_Opt -coverage +UVM_TESTNAME=Fifo_wr_rd

set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all

coverage save Fifo_wr_rd.ucdb
quit -sim

#--------------------------------------------------------------
#This process is repeated for UVM test: fifo_full

vopt async_fifo_TB -o async_fifo_TB_Opt +acc +cover=sbfec
vsim async_fifo_TB_Opt -coverage +UVM_TESTNAME=fifo_full

set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all

coverage save fifo_full.ucdb
quit -sim

#----------------------------------------------------------------
#This process is repeated for UVM test: Fifo_Full_and_Empty

vopt async_fifo_TB -o async_fifo_TB_Opt +acc +cover=sbfec
vsim async_fifo_TB_Opt -coverage +UVM_TESTNAME=Fifo_Full_and_Empty

set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all

coverage save Fifo_Full_and_Empty.ucdb
quit -sim

#----------------------------------------------------------------
#This process is repeated for UVM test: Concurrent_wr_rd_test

vopt async_fifo_TB -o async_fifo_TB_Opt +acc +cover=sbfec
vsim async_fifo_TB_Opt -coverage +UVM_TESTNAME=Concurrent_wr_rd_test

set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all

coverage save Concurrent_wr_rd_test.ucdb

#Merge coverage data
vcover merge output.ucdb Fifo_wr.ucdb Fifo_rd.ucdb Fifo_wr_rd.ucdb fifo_full.ucdb Fifo_Full_and_Empty.ucdb Concurrent_wr_rd_test.ucdb

#Generate coverage report
vcover report output.ucdb -cvg -details
vopt async_fifo_TB -o async_fifo_TB_Opt +acc +cover=sbfec
vsim async_fifo_TB_Opt -coverage +UVM_TESTNAME=empty_rd

set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all

coverage save Fifo_wr_rd.ucdb
quit -sim
#Finally quit simulation tool
quit
