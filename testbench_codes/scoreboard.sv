class scoreboard;
 virtual interface_fifo in;
 mailbox mts;
 int no_trans= '0;
 bit[7:0]ram[0:256-1];
 bit wr_ptr;
 bit rd_ptr;

 
 
 function new(virtual interface_fifo in,mailbox mts);
   this.in = in;
   this.mts = mts;
   foreach(ram[i])begin
    ram[i] = 8'h00;
   end
 endfunction 
 
  task write();
   int h = 1;
   int P = 0;
   fork
   forever begin   
    transaction trans;
    trans = new();
    mts.get(trans);
    if(trans.w_en)begin
      ram[wr_ptr] = trans.data_in;
      wr_ptr++;
    end  
    if(trans.r_en)begin
      repeat(3) @(posedge in.w_clk);
      if(trans.data_out == ram[rd_ptr])begin
        rd_ptr++;
        if(h==1) $display("[Scoreboard] ------------------- Match with Brust_ID=%2d -------------------\n",h);
      end
      else begin
        $display("[Scoreboard] ------------------- Mismatch -------------------\n");
        $display("data_out=%d,sc_data=%d",trans.data_out,ram[rd_ptr]);
      end
    end
    P++;
    if(P==512) h++;
   end
   join
  endtask
endclass
