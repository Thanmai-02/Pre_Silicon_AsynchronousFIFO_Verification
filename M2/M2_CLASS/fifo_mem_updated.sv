module fifo_mem #(parameter DEPTH=256, DATA_SIZE=8, PTR_SIZE=8) (
  input w_clk, w_en, r_clk, r_en,
  input [PTR_SIZE:0] b_wptr, b_rptr,
  input [DATA_SIZE-1:0] data_in,
  input full, empty,
  output reg [DATA_SIZE-1:0] data_out,
  output reg write_error, read_error
);
  reg [DATA_SIZE-1:0] fifo[0:DEPTH-1];
  
  always_ff @(posedge w_clk) begin
    write_error <= 0;  
    if (w_en) begin
      if (full) 
        write_error <= 1;  
      else 
        fifo[b_wptr[PTR_SIZE-1:0]] <= data_in;  
    end
  end

  always_ff @(posedge r_clk) begin
    read_error <= 0;  
    if (r_en) begin
      if (empty) 
        read_error <= 1;  
      else 
        data_out <= fifo[b_rptr[PTR_SIZE-1:0]];  
    end
  end

endmodule
