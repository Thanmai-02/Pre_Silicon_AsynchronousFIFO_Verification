class read_monitor extends uvm_monitor;
`uvm_component_utils(read_monitor)
 read_transaction tx;
 uvm_analysis_port#(read_transaction) ap_port;

`NEW
 virtual interface_fifo inf;
 
function void build_phase(uvm_phase phase);
  super.build_phase(phase);
 if(!uvm_resource_db#(virtual interface_fifo)::read_by_name("ALL","TB",inf,this)) // Reterving the Interface
  begin
   `uvm_error("Read_MONITOR","Problem with the interface")
  end
   ap_port= new("ap_port",this);
endfunction

//Collecting the Data From the Interface
 task run_phase(uvm_phase phase);
   forever begin
		@(inf.monr_cs);
      if(inf.monr_cs.r_en==1)begin
		tx = new();
      tx.rrst_n=inf.monr_cs.rrst_n;
		tx.r_en=inf.monr_cs.r_en;
      tx.empty=inf.monr_cs.empty;
      tx.read_error=inf.monr_cs.read_error;
         repeat(2) @(posedge inf.r_clk);
         tx.data=inf.monr_cs.data_out;
		   ap_port.write(tx);
        `uvm_info("Read_Monitor",$psprintf("MON is doing READ in data=%0h",tx.data),UVM_NONE)
     end 
	end
 endtask


endclass
