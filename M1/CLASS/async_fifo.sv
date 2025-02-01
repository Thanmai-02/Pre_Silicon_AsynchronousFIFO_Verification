module async_fifo #(parameter DATA_SIZE = 8, parameter ADDR_SIZE = 8) (
    output logic [DATA_SIZE-1:0] r_data,
    output logic w_full,
    output logic r_empty,
    input logic [DATA_SIZE-1:0] w_data,
    input logic w_inc, w_clk, wrst_n,
    input logic r_inc, r_clk, rrst_n
);

    logic [ADDR_SIZE-1:0] w_addr, r_addr;
    logic [ADDR_SIZE:0] w_ptr, r_ptr, wq2_r_ptr, rq2_w_ptr;

    sync_r2w #(ADDR_SIZE) sync_r2w_inst (
        .wq2_r_ptr(wq2_r_ptr),
        .r_ptr(r_ptr),
        .w_clk(w_clk),
        .wrst_n(wrst_n)
    );

    sync_w2r #(ADDR_SIZE) sync_w2r_inst (
        .rq2_w_ptr(rq2_w_ptr),
        .w_ptr(w_ptr),
        .r_clk(r_clk),
        .rrst_n(rrst_n)
    );

    fifomem #(DATA_SIZE, ADDR_SIZE) fifomem_inst (
        .r_data(r_data),
        .w_data(w_data),
        .w_addr(w_addr),
        .r_addr(r_addr),
        .w_clken(w_inc),
        .w_full(w_full),
        .w_clk(w_clk)
    );

    r_ptr_empty #(ADDR_SIZE) r_ptr_empty_inst (
        .r_empty(r_empty),
        .r_addr(r_addr),
        .r_ptr(r_ptr),
        .rq2_w_ptr(rq2_w_ptr),
        .r_inc(r_inc),
        .r_clk(r_clk),
        .rrst_n(rrst_n)
    );

    w_ptr_full #(ADDR_SIZE) w_ptr_full_inst (
        .w_full(w_full),
        .w_addr(w_addr),
        .w_ptr(w_ptr),
        .wq2_r_ptr(wq2_r_ptr),
        .w_inc(w_inc),
        .w_clk(w_clk),
        .wrst_n(wrst_n)
    );

endmodule

module fifomem #(parameter DATADDR_SIZE = 8, parameter ADDRSIZE = 8) (
    output logic [DATADDR_SIZE-1:0] r_data,
    input logic [DATADDR_SIZE-1:0] w_data,
    input logic [ADDRSIZE-1:0] w_addr, r_addr,
    input logic w_clken, w_full, w_clk
);

    localparam DEPTH = 1 << ADDRSIZE;
    logic [DATADDR_SIZE-1:0] mem [0:DEPTH-1];

    always_ff @(posedge w_clk) begin
        if (w_clken && !w_full)
            mem[w_addr] <= w_data;
    end

    assign r_data = mem[r_addr];

endmodule

module sync_r2w #(parameter ADDRSIZE = 8) (
    output reg [ADDRSIZE:0] wq2_r_ptr,
    input [ADDRSIZE:0] r_ptr,
    input logic w_clk, wrst_n
);
    reg [ADDRSIZE:0] wq1_r_ptr;
    always_ff @(posedge w_clk or negedge wrst_n) begin
        if (!wrst_n)
            {wq2_r_ptr, wq1_r_ptr} <= 0;
        else
            {wq2_r_ptr, wq1_r_ptr} <= {wq1_r_ptr, r_ptr};
    end
endmodule

module sync_w2r #(parameter ADDRSIZE = 8) (
    output reg [ADDRSIZE:0] rq2_w_ptr,
    input [ADDRSIZE:0] w_ptr,
    input logic r_clk, rrst_n
);
    reg [ADDRSIZE:0] rq1_w_ptr;
    always_ff @(posedge r_clk or negedge rrst_n) begin
        if (!rrst_n)
            {rq2_w_ptr, rq1_w_ptr} <= 0;
        else
            {rq2_w_ptr, rq1_w_ptr} <= {rq1_w_ptr, w_ptr};
    end
endmodule

module r_ptr_empty #(parameter ADDRSIZE = 8) (
    output reg r_empty,
    output [ADDRSIZE-1:0] r_addr,
    output reg [ADDRSIZE:0] r_ptr,
    input [ADDRSIZE:0] rq2_w_ptr,
    input r_inc, r_clk, rrst_n
);
    reg [ADDRSIZE:0] rbin;
    wire [ADDRSIZE:0] rgraynext, rbinnext;

    always_ff @(posedge r_clk or negedge rrst_n) begin
        if (!rrst_n)
            {rbin, r_ptr} <= 0;
        else
            {rbin, r_ptr} <= {rbinnext, rgraynext};
    end

    assign r_addr = rbin[ADDRSIZE-1:0];
    assign rbinnext = rbin + (r_inc & ~r_empty);
    assign rgraynext = (rbinnext >> 1) ^ rbinnext;

    always_ff @(posedge r_clk or negedge rrst_n) begin
        if (!rrst_n)
            r_empty <= 1'b1;
        else
            r_empty <= (rgraynext == rq2_w_ptr);
    end

endmodule

module w_ptr_full #(parameter ADDRSIZE = 8) (
    output reg w_full,
    output [ADDRSIZE-1:0] w_addr,
    output reg [ADDRSIZE:0] w_ptr,
    input [ADDRSIZE:0] wq2_r_ptr,
    input w_inc, w_clk, wrst_n
);
    reg [ADDRSIZE:0] wbin;
    wire [ADDRSIZE:0] wgraynext, wbinnext;

    always_ff @(posedge w_clk or negedge wrst_n) begin
        if (!wrst_n)
            {wbin, w_ptr} <= 0;
        else
            {wbin, w_ptr} <= {wbinnext, wgraynext};
    end

    assign w_addr = wbin[ADDRSIZE-1:0];
    assign wbinnext = wbin + (w_inc & ~w_full);
    assign wgraynext = (wbinnext >> 1) ^ wbinnext;

    always_ff @(posedge w_clk or negedge wrst_n) begin
        if (!wrst_n)
            w_full <= 1'b0;
        else
            w_full <= (wgraynext == {~wq2_r_ptr[ADDRSIZE], wq2_r_ptr[ADDRSIZE-1:0]});
    end

endmodule


