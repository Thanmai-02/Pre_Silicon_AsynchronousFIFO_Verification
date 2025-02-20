if [file exists "work"] {vdel -all}
vlib work
vlog fifo_mem_updated.sv
vlog rptr_handler_updated.sv
vlog synchroniser_update.sv
vlog wptr_handler_updated.sv
vlog top.sv
vlog testbench.sv
#vsim -c -voptargs=+acc=npr async_fifo_TB
#vcd file async_fifo_TB.vcd
#vcd add -r async_fifo_TB/*

vopt async_fifo_TB -o async_fifo_TB_opt +acc +cover=sbfec
vsim async_fifo_TB_opt -coverage

set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all




quit