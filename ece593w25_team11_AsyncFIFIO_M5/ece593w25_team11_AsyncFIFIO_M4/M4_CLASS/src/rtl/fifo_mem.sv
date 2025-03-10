module fifo_memory #(parameter DEPTH = 256, DATA_SIZE = 8, PTR_SIZE = 8) (
  input wire w_clk,
  input wire w_en,
  input wire r_clk,
  input wire r_en,
  input wire [PTR_SIZE:0] b_wptr,
  input wire [PTR_SIZE:0] b_rptr,
  input wire [DATA_SIZE-1:0] data_in,
  input wire full,
  input wire empty,
  output reg [DATA_SIZE-1:0] data_out,
  output reg write_error,
  output reg read_error
);

  reg [DATA_SIZE-1:0] fifo [0:DEPTH-1];

  // Write block
  always @(posedge w_clk) begin
    write_error <= 0;
    if (w_en) begin
      if (full) 
        write_error <= 1;
      else 
        fifo[b_wptr[PTR_SIZE-1:0]] <= data_in;
    end
  end

  // Read block
  always @(posedge r_clk) begin
    read_error <= 0;
    if (r_en) begin
      if (empty)
        read_error <= 1;
      else 
        data_out <= fifo[b_rptr[PTR_SIZE-1:0]];
    end
  end

endmodule
