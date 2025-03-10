class Environment extends uvm_env;

`uvm_component_utils(Environment)
`NEW

 write_agent WR_Agent;
 read_agent RD_Agent; 
 async_scoreboard scoreboard;

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  WR_Agent = write_agent::type_id::create("WR_Agent",this); 
  RD_Agent = read_agent::type_id::create("RD_Agent",this);
  scoreboard   =  async_scoreboard::type_id::create("scoreboard",this);
endfunction

function void connect_phase(uvm_phase phase);
  WR_Agent.wr_mon.ap_port.connect(scoreboard.ap_wr);	//Connecting Write Monitor and Scoreboard
  RD_Agent.rd_mon.ap_port.connect(scoreboard.ap_rd); //Connectiong Read Monitor and Scoreboard

endfunction

endclass
