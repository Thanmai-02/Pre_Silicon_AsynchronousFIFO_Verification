module synchronizer #(parameter SIZE = 8) (
  input wire clk,
  input wire rst_n,
  input wire [SIZE:0] d_in,
  output reg [SIZE:0] d_out
);

  reg [SIZE:0] q1;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      q1 <= 0;
      d_out <= 0;
    end else begin
      q1 <= d_in;
      d_out <= q1;
    end
  end

endmodule