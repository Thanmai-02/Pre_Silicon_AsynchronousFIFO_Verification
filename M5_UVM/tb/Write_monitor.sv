class write_monitor extends uvm_monitor;
`uvm_component_utils(write_monitor)
 write_transaction tx;
 uvm_analysis_port#(write_transaction) ap_port;

 `NEW
 virtual interface_fifo inf;
 
 function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  ap_port= new("ap_port",this);
  if(!uvm_resource_db#(virtual interface_fifo)::read_by_name("ALL","TB",inf,this)) //Reterving the Interface
  begin
   `uvm_error("WRITE_MONITOR","Problem with the interface")
  end
 endfunction

 //Getting the Data from Interface
  task run_phase(uvm_phase phase);
   forever begin
     @(inf.monw_cs);
     if(inf.monw_cs.w_en == 1)  begin
        tx = new();
        tx.wrst_n = inf.monw_cs.wrst_n;
        tx.full = inf.monw_cs.full;
        tx.write_error= inf.monw_cs.write_error;
		    tx.w_en = inf.monw_cs.w_en;
	    	tx.data = inf.monw_cs.w_en? inf.monw_cs.data_in:1'b0;
	    	ap_port.write(tx);
        `uvm_info("Write_Monitor",$psprintf("MON is doing WRITE at data=%0h",tx.data),UVM_NONE);
   end
   end
  endtask


endclass