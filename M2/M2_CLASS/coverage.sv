parameter DEPTH=256;
    parameter DATA_SIZE=8;
    parameter PTR_SIZE = 8;

class Cov_class;
    
    virtual interface_fifo bfm;

    // Declare the inputs
    bit w_clk, wrst_n, r_clk, rrst_n, w_en, r_en;
    logic [DATA_SIZE-1:0] data_in, data_out;
    reg full, empty, write_error, read_error;

    // 1. Write Operations Covergroup
    covergroup cg_write_ops;
        option.per_instance = 1;
        full_coverage: coverpoint full {
        //bins full = {1'b1};
        bins not_full = {1'b0};
        }
    endgroup

    // 2. Read Operations Covergroup
    covergroup cg_read_ops;
        option.per_instance = 1;
        empty_coverage: coverpoint empty {
        bins empty = {1'b1};
        bins not_empty = {1'b0};
        }
    endgroup



    function new(virtual interface_fifo b);
        cg_write_ops = new();
        cg_read_ops = new();
        bfm = b;
    endfunction   

    task execute();
    fork
        execute_1();
        execute_2();
    join
    endtask

    task execute_1();
        forever begin
            @(posedge bfm.w_clk);
            full = bfm.full;
            w_en = bfm.w_en;
            cg_write_ops.sample();
        end
    endtask
    task execute_2();
        forever begin
            @(posedge bfm.r_clk);
            empty = bfm.empty;
            r_en = bfm.r_en;
            cg_read_ops.sample();
        end
    endtask



endclass