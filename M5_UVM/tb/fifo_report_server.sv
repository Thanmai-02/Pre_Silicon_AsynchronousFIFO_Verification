class fifo_report_server extends uvm_report_server;
  `uvm_object_utils(fifo_report_server)

  // Constructor
  function new(string name="fifo_report_server");
    super.new();
    $display("Constructing report server %0s", name);
  endfunction

  // Override the compose_message function
  virtual function string compose_message(uvm_severity severity, string name, string id, string message, string filename, int line);
    $display("%0s", super.compose_message(severity, name, id, message, filename, line));
    return super.compose_message(severity, name, id, message, filename, line);
  endfunction
endclass