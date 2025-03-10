class read_transaction extends uvm_sequence_item;
  bit [7:0] data;
  bit rrst_n;
  bit r_en;
  bit empty, read_error;

 `uvm_object_utils_begin(read_transaction)
 `uvm_field_int(data,UVM_ALL_ON)
 `uvm_object_utils_end
 `NEW_OBJ
 
endclass

