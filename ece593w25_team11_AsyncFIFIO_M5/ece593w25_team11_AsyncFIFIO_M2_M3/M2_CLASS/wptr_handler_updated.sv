module wptr_handler #(parameter PTR_SIZE=8) (
  input w_clk, wrst_n, w_en,
  input [PTR_SIZE:0] g_rptr_sync,
  output reg [PTR_SIZE:0] b_wptr, g_wptr,
  output reg full
);

  reg [PTR_SIZE:0] b_wptr_next;
  reg [PTR_SIZE:0] g_wptr_next;
  
  wire wfull;

  always_comb begin 
    b_wptr_next = b_wptr + (w_en & !full);
    g_wptr_next = (b_wptr_next >> 1) ^ b_wptr_next;
  end

  always_ff @(posedge w_clk or negedge wrst_n) begin 
    if (!wrst_n) begin
      b_wptr <= 0; 
      g_wptr <= 0;
    end else begin
      b_wptr <= b_wptr_next; // Increment binary write pointer
      g_wptr <= g_wptr_next; // Increment gray write pointer
    end
  end

  always_ff @(posedge w_clk or negedge wrst_n) begin 
    if (!wrst_n) 
      full <= 0;
    else 
      full <= wfull;
  end

  assign wfull = (g_wptr_next == {~g_rptr_sync[PTR_SIZE:PTR_SIZE-1], g_rptr_sync[PTR_SIZE-2:0]});

endmodule
