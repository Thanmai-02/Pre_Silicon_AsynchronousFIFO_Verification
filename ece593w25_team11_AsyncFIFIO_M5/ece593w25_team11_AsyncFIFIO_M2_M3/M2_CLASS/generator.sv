class generator;

  
  mailbox gtd;
  int repeat_count;
  event ended;
  int repeat_gen = 0;
 
  function new( mailbox gtd, event ended);
    this.gtd = gtd;
    this.ended = ended;  
  endfunction
  

  task write();
  int K;
  int h = 1;
   repeat(repeat_count) begin
    repeat(512)begin  
    transaction trans;
    trans = new();
    K = (trans.randomize());
    if(h==1) $display("[Generator] Brust_id=%0d >>Data_In=%0d", h, trans.data_in);

    gtd.put(trans);
    repeat_gen++;
    end 
    h = h+1; 
  end
   -> ended;
  #2055 $finish;
  endtask

endclass
