module rptr_handler #(parameter PTR_SIZE=8) (
  input r_clk, rrst_n, r_en,
  input [PTR_SIZE:0] g_wptr_sync,
  output reg [PTR_SIZE:0] b_rptr, g_rptr,
  output reg empty
);

  reg [PTR_SIZE:0] b_rptr_next;
  reg [PTR_SIZE:0] g_rptr_next;
  reg rempty; 

  always_comb begin 
    b_rptr_next = b_rptr + (r_en & !empty);
    g_rptr_next = (b_rptr_next >> 1) ^ b_rptr_next;
  end

  always_ff @(posedge r_clk or negedge rrst_n) begin 
    if (!rrst_n) begin
      b_rptr <= 0;
      g_rptr <= 0;
    end else begin
      b_rptr <= b_rptr_next;
      g_rptr <= g_rptr_next; 
    end
  end

  always_ff @(posedge r_clk or negedge rrst_n) begin 
    if (!rrst_n)
      empty <= 1;
    else begin
      rempty = (g_wptr_sync == g_rptr_next); 
      empty <= rempty;
    end
  end

endmodule
