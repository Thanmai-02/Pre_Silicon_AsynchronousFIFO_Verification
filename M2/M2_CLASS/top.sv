`include "synchroniser_update.sv"
`include "wptr_handler_updated.sv"
`include "rptr_handler_updated.sv"
`include "fifo_mem_updated.sv"

module asynchronous_fifo #(parameter DEPTH=256, DATA_SIZE=8, parameter PTR_SIZE = 8) (
  input w_clk, wrst_n,
  input r_clk, rrst_n,
  input w_en, r_en,
  input [DATA_SIZE-1:0] data_in,
  output reg [DATA_SIZE-1:0] data_out,
  output reg full, empty, write_error, read_error
);
 
  reg [PTR_SIZE:0] g_wptr_sync, g_rptr_sync;
  reg [PTR_SIZE:0] b_wptr, b_rptr;
  reg [PTR_SIZE:0] g_wptr, g_rptr;

  wire [PTR_SIZE-1:0] waddr, raddr;

  synchronizer #(PTR_SIZE) sync_wptr (r_clk, rrst_n, g_wptr, g_wptr_sync); //write pointer to read clock domain
  synchronizer #(PTR_SIZE) sync_rptr (w_clk, wrst_n, g_rptr, g_rptr_sync); //read pointer to write clock domain 
  
  wptr_handler #(PTR_SIZE) wptr_h(w_clk, wrst_n, w_en,g_rptr_sync,b_wptr,g_wptr,full);
  rptr_handler #(PTR_SIZE) rptr_h(r_clk, rrst_n, r_en,g_wptr_sync,b_rptr,g_rptr,empty);
  fifo_mem fifom(w_clk, w_en, r_clk, r_en,b_wptr, b_rptr, data_in,full,empty, data_out, write_error, read_error);

endmodule
