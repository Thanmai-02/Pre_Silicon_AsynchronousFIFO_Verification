module fifo_mem #(parameter DEPTH=256, DATA_SIZE=8, PTR_SIZE=8) (
  input w_clk, w_en, rclk, r_en,
  input [PTR_SIZE:0] b_wptr, b_rptr,
  input [DATA_SIZE-1:0] data_in,
  input full, empty,
  output reg [DATA_SIZE-1:0] data_out,
  output reg write_error, read_error
);
  reg [DATA_SIZE-1:0] fifo[0:DEPTH-1];
  
  always_ff @(posedge w_clk) begin
    write_error = 0;
    if(w_en) begin
      if(full) begin
       write_error  = 1;
      end 
      else if (!full) begin
       fifo[b_wptr[PTR_SIZE-1:0]] <= data_in;
      end
  end 
  end


   
  always_ff @(posedge rclk) begin
    read_error = 0;
    if(r_en) begin
     if(empty) begin
      read_error = 1;
     end
     else if (!empty) begin
      data_out <= fifo[b_rptr[PTR_SIZE-1:0]];
    end
    end
  end

endmodule
