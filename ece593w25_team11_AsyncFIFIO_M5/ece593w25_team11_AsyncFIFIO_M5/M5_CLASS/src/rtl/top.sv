`include "fifo_mem.sv"
`include "rptr_handler_updated.sv"
`include "synchronizer.sv"
`include "wptr_handler.sv"


module asynchronous_fifo #(parameter DEPTH=256, DATA_WIDTH=8, parameter PTR_WIDTH = 8) (
  input w_clk, wrst_n,
  input r_clk, rrst_n,
  input w_en, r_en,
  input [DATA_WIDTH-1:0] data_in,
  output reg [DATA_WIDTH-1:0] data_out,
  output reg full, empty, write_error, read_error
);
 
  reg [PTR_WIDTH:0] g_wptr_sync, g_rptr_sync;
  reg [PTR_WIDTH:0] b_wptr, b_rptr;
  reg [PTR_WIDTH:0] g_wptr, g_rptr;

  wire [PTR_WIDTH-1:0] waddr, raddr;

  synchronizer #(PTR_WIDTH) sync_wptr (r_clk, rrst_n, g_wptr, g_wptr_sync); //write pointer to read clock domain
  synchronizer #(PTR_WIDTH) sync_rptr (w_clk, wrst_n, g_rptr, g_rptr_sync); //read pointer to write clock domain 
  
  wptr_handler #(PTR_WIDTH) wptr_h(w_clk, wrst_n, w_en,g_rptr_sync,b_wptr,g_wptr,full);
  rptr_handler #(PTR_WIDTH) rptr_h(r_clk, rrst_n, r_en,g_wptr_sync,b_rptr,g_rptr,empty);
  fifo_mem fifom(w_clk, w_en, r_clk, r_en,b_wptr, b_rptr, data_in,full,empty, data_out, write_error, read_error);

endmodule




