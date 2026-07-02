class read_agent extends uvm_agent;
`uvm_component_utils(read_agent)
 `NEW
  read_driver rd_drv;
  read_sequencer rd_sqr;
  read_monitor rd_mon;
  read_coverage rd_cov;

 function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  rd_drv= read_driver::type_id::create("rd_drv",this);
  rd_sqr= read_sequencer::type_id::create("rd_sqr",this);
  rd_mon= read_monitor::type_id::create("rd_mon",this);
  rd_cov= read_coverage::type_id::create("rd_cov",this);
 endfunction

 function void connect_phase(uvm_phase phase);
  rd_drv.seq_item_port.connect(rd_sqr.seq_item_export); // Read Driver to Read Sequencer
  rd_mon.ap_port.connect(rd_cov.analysis_export); // Read Monitor to Read Coverage
 endfunction


endclass