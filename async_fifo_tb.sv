module top;

    // Parameters
    parameter DATA_SIZE = 8;
    parameter ADDR_SIZE = 8;

    // Signals
    logic w_clk, r_clk, wrst_n, rrst_n;
    logic [DATA_SIZE-1:0] w_data, r_data;
    logic w_inc, r_inc;
    logic w_full, r_empty;

    // Instantiate the FIFO module
    async_fifo #(DATA_SIZE, ADDR_SIZE) dut (
        .r_data(r_data),
        .w_full(w_full),
        .r_empty(r_empty),
        .w_data(w_data),
        .w_inc(w_inc),
        .w_clk(w_clk),
        .wrst_n(wrst_n),
        .r_inc(r_inc),
        .r_clk(r_clk),
        .rrst_n(rrst_n)
    );

    initial begin
        w_clk = 0;
        r_clk = 0;
        wrst_n = 0;
        rrst_n = 0;
        
        // Reset sequence
        #100;
        wrst_n = 1;
        rrst_n = 1;
        
        // Write transactions
        w_data = 8'hFF; // Example data
        w_inc = 1;
        #20; // Wait for a few cycles
        w_inc = 0; // Stop write
        #20; // Wait for a few cycles

        // Additional write transactions
        repeat (5) begin
            w_data = $random;
            w_inc = 1;
            #20; // Wait for a few cycles
            w_inc = 0; // Stop write
            #20; // Wait for a few cycles
        end

        // Read transactions
        r_inc = 1;
        #20; // Wait for a few cycles
        r_inc = 0; // Stop read
        #20; // Wait for a few cycles

        // Additional read transactions
        repeat (5) begin
            r_inc = 1;
            #50; // Wait for a few cycles
            r_inc = 0; // Stop read
            #100; // Wait for a few cycles
        end

        // Finish simulation
        $finish;
    end

    // Clock generation for write clock
    always #25 w_clk = ~w_clk;

    // Clock generation for read clock
    always #15 r_clk = ~r_clk;

    // Monitor output signals during simulation
    always @(posedge w_clk or posedge r_clk) begin
        $display("Time=%0t, w_full=%b, r_empty=%b, w_inc=%b, w_data=%h, r_inc=%b, r_data=%h", 
                 $time, w_full, r_empty, w_inc, w_data, r_inc, r_data);
    end

endmodule
