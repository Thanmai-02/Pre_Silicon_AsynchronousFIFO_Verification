class write_transaction extends uvm_sequence_item;
  randc bit [7:0] data;
  logic wrst_n;
  logic w_en;
  logic full, write_error;


 `uvm_object_utils_begin(write_transaction)
 `uvm_field_int(data,UVM_ALL_ON)
 `uvm_object_utils_end


 `NEW_OBJ


endclass