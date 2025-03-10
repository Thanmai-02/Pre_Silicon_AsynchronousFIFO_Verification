module rptr_handler #(parameter PTR_SIZE = 8) (
  input wire r_clk,
  input wire rrst_n,
  input wire r_en,
  input wire [PTR_SIZE:0] g_wptr_sync,
  output reg [PTR_SIZE:0] b_rptr,
  output reg [PTR_SIZE:0] g_rptr,
  output reg empty
);

  reg [PTR_SIZE:0] b_rptr_next;
  reg [PTR_SIZE:0] g_rptr_next;
  wire rempty;
  
  // Compute next binary and gray code read pointers
  always @(*) begin
    b_rptr_next = b_rptr + (r_en & ~empty);
    g_rptr_next = (b_rptr_next >> 1) ^ b_rptr_next;
  end

  assign rempty = (g_wptr_sync == g_rptr_next);
  
  // Update binary and gray read pointers
  always @(posedge r_clk or negedge rrst_n) begin
    if (!rrst_n) begin
      b_rptr <= 0;
      g_rptr <= 0;
    end else begin
      b_rptr <= b_rptr_next;
      g_rptr <= g_rptr_next;
    end
  end
  
  // Update empty flag
  always @(posedge r_clk or negedge rrst_n) begin
    if (!rrst_n)
      empty <= 1;
    else
      empty <= rempty;
  end

endmodule
