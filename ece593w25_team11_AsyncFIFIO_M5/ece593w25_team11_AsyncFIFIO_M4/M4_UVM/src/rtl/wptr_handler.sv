module wptr_handler #(parameter PTR_SIZE = 8) (
  input wire w_clk,
  input wire wrst_n,
  input wire w_en,
  input wire [PTR_SIZE:0] g_rptr_sync,
  output reg [PTR_SIZE:0] b_wptr,
  output reg [PTR_SIZE:0] g_wptr,
  output reg full
);

  reg [PTR_SIZE:0] b_wptr_next;
  reg [PTR_SIZE:0] g_wptr_next;
  wire wfull;
  
  // Compute next binary and gray code write pointers
  always @(*) begin
    b_wptr_next = b_wptr + (w_en & ~full);
    g_wptr_next = (b_wptr_next >> 1) ^ b_wptr_next;
  end
  
  // Update binary and gray write pointers
  always @(posedge w_clk or negedge wrst_n) begin
    if (!wrst_n) begin
      b_wptr <= 0;
      g_wptr <= 0;
    end else begin
      b_wptr <= b_wptr_next;
      g_wptr <= g_wptr_next;
    end
  end
  
  // Update full flag
  always @(posedge w_clk or negedge wrst_n) begin
    if (!wrst_n)
      full <= 0;
    else
      full <= wfull;
  end

  // Full condition logic
  assign wfull = (g_wptr_next == {~g_rptr_sync[PTR_SIZE:PTR_SIZE-1], g_rptr_sync[PTR_SIZE-2:0]});

endmodule