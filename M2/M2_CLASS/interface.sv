interface interface_fifo;
  parameter DATA_SIZE = 8;
  logic w_clk, wrst_n;
  logic r_clk, rrst_n;
  logic w_en, r_en;
  logic [DATA_SIZE-1:0] data_in;
  logic [DATA_SIZE-1:0] data_out;
  logic full, empty, write_error, read_error;

    
  clocking moni@(posedge w_clk or posedge r_clk);
    input w_clk,r_clk;
    input r_en;
    input w_en;
    input data_in;
    input data_out;
    input full,empty;
  endclocking
  
    modport MON (clocking moni);

endinterface 
