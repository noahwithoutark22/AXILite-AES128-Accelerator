`timescale 1ns / 1ps

module DynamicTb();

reg clk;
reg reset;
reg [127:0] key;
reg start;
reg key_valid;
reg [9:0] source_address;
reg [8:0] blocks;
reg [95:0] nounce;
wire [1:0] status;
wire done;

integer i;

integer TOTAL_BLOCKS = 400;      // must match Python
integer BLOCKS_PER_RUN = 400;
integer NUM_RUNS;
integer curr_blocks;

Top #(.MODE(1)) tp(
    .clk(clk),
    .reset(reset),
    .key(key),
    .source_address(source_address),
    .blocks(blocks),
    .start(start),
    .key_valid(key_valid),
    .nonce(nounce),
    .done(done),
    .status(status)
);


initial clk = 0;
always #5 clk = ~clk;


initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, tp);
end

task run_test;
input [9:0] addr;
input [8:0] blk_count;
begin
    reset = 1;
    start = 0;
    @(posedge clk);

    reset = 0;


    source_address = addr;
    blocks = blk_count;

    $display("Time=%0t | START addr=%0d blocks=%0d", $time, addr, blk_count);


    start = 1;


    wait(done);

    $display("Time=%0t | DONE addr=%0d", $time, addr);


    @(posedge clk);
    start = 0;

    @(posedge clk);
end
endtask


initial begin


    $readmemh("C:/Users/yashd/Desktop/pt_32ctr.hex", tp.rmem.memory);


    reset = 0;
    start = 0;
    key_valid = 0;


    key = 128'h2B7E151628AED2A6ABF7158809CF4F3C;
    nounce = 96'hDADACACADADACACADADACACA;

    @(posedge clk);
    key_valid = 1;


    NUM_RUNS = (TOTAL_BLOCKS + BLOCKS_PER_RUN - 1) / BLOCKS_PER_RUN;


    for (i = 0; i < NUM_RUNS; i = i + 1) begin

        


        if (i == NUM_RUNS - 1)
            curr_blocks = TOTAL_BLOCKS - i * BLOCKS_PER_RUN;
        else
            curr_blocks = BLOCKS_PER_RUN;

        run_test(i * BLOCKS_PER_RUN * 4, curr_blocks);

    end


    $writememh("C:/Users/yashd/Desktop/NEWWWstanVecctr.hex", tp.wmem.memory);

    $display("ALL TESTS COMPLETED");
    $finish;

end

endmodule