`include "interface.sv"
`include "test.sv"
module async_fifo_TB;

 

 interface_fifo in();
 test tet(in);
 
 asynchronous_fifo async_fifo (.w_clk(in.w_clk),.wrst_n(in.wrst_n),.r_clk(in.r_clk),.rrst_n(in.rrst_n),
                            .w_en(in.w_en),.r_en(in.r_en),.data_in(in.data_in),.data_out(in.data_out),.full(in.full),.empty(in.empty),.write_error(in.write_error),
                            .read_error(in.read_error));


  always #2.083ns in.w_clk = ~in.w_clk;
  always #1.25ns in.r_clk = ~in.r_clk;

 initial begin
    in.w_clk = 1;
    in.r_clk = 1;
 end 


endmodule

