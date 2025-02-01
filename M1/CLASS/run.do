vlib work

vlog -lint async_fifo.sv +acc
vlog -lint async_fifo_tb.sv +acc

vsim work.top

add wave -r *
run -all
