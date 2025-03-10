module synchronizer #(parameter SIZE=8) (
  input clk, rst_n, 
  input [SIZE:0] d_in,  
  output reg [SIZE:0] d_out
);
  reg [SIZE:0] q1;

  always_ff @(posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin  
      q1 <= 0;
      d_out <= 0;
    end else begin
      q1 <= d_in;
      d_out <= q1;
    end
  end
endmodule
