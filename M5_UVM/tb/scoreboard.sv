`uvm_analysis_imp_decl(_wr)
`uvm_analysis_imp_decl(_rd)

class async_scoreboard extends uvm_scoreboard;
  uvm_analysis_imp_wr#(write_transaction,async_scoreboard) ap_wr;
  uvm_analysis_imp_rd#(read_transaction,async_scoreboard) ap_rd;  
`uvm_component_utils(async_scoreboard)
`NEW


bit [7:0]writeQ[$];
bit [7:0]readQ[$];
bit [7:0] write_data;
bit [7:0] read_data;


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
  ap_wr = new("ap_wr",this);
  ap_rd = new("ap_rd",this);
endfunction
  
//Pushing Data into the Scoreboard Write Queue
    function void write_wr( write_transaction tx);
        writeQ.push_back(tx.data);
        $display("data=%h",tx.data);
        tx.print();
    endfunction
 //Pushing Data into the Scoreboard Write Queue
  function void write_rd(read_transaction rd);
    readQ.push_back(rd.data);  
  	$display("data=%h",rd.data);
	  rd.print();
 endfunction

 //Taking Data From Read Queue and Write Queue and Comparing them
task run_phase(uvm_phase phase);

	forever begin
      
      wait(writeQ.size()>0 && readQ.size()>0);
		 write_data=writeQ.pop_front();
		 read_data=readQ.pop_back();

		if(write_data == read_data)$display("matched data_src=%0h, data_out=%0h", write_data,read_data);
		else begin $display("mismatched data_src=%0h, data_out=%0h", write_data,read_data); end
	end

endtask
endclass