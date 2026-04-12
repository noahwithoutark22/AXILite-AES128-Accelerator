`timescale 1ns / 1ps

module Top#(parameter MODE = 0)(
    input clk,
    input reset,
    input [127:0] key,
    input[9:0] source_address,
    input [8:0] blocks,
    input start,
    input key_valid,
    input [95:0] nonce,
    output done,
    output [1:0] status
    );

wire [127:0] key_w;
wire [9:0] src_addw;
wire startw, key_validw;
wire validaes_con, validcon_aes;
wire [127:0] ctw;
wire [127:0] messagew;
wire [95:0] noncew;
wire [127:0] keyc_aes;
wire [1:0] status;
wire ready;
AES128#(.MODE(MODE)) Encrypt ( // MODE = 0/1 --> ECB/Counter 
    .valid_out(validaes_con),
   .cipher_text(ctw),
    .ready(ready), 
    .key(keyc_aes), 
    .message(messagew),
    .nonce(noncew),
    .clk(clk),
    .valid_in(validcon_aes),
    .start(startw),
    .key_valid(key_validw)
    );

wire ARready, Rvalid, AWready, Wready, Rready, ARvalid, AWvalid, Wvalid;
wire [9:0] ARaddr, AWaddr;
wire [31:0] Wdata, Rdata;
Controller controller(.clk(clk),
.reset(reset),
.source_address(source_address),
.ARready(ARready),
.Rdata(Rdata),
.status(status),
.cipher_text(ctw),
.Rvalid(Rvalid),
.AWready(AWready),
.Wready(Wready),
.Aes_ready(ready), 
.blocks(blocks),
.key_in(key),
.start_in(start),
.key_valid(key_valid),
.valid(validaes_con),
.nounce_in(nonce),
.Rready(Rready),
.ARaddr(ARaddr),
.ARvalid(ARvalid),
.Awaddr(AWaddr),
.AWvalid(AWvalid),
.message(messagew),
.key_out(keyc_aes),
.Wdata(Wdata),
.Wvalid(Wvalid),
.message_valid(validcon_aes),
.nounce_out(noncew),
.start_out(startw),
.key_valid_out(key_validw),
.done(done));

Rmem rmem(
.clk(clk),
.reset(reset),
.R_address(ARaddr),
.W_address(),
.Wdata(),
.ARvalid(ARvalid),
.Rready(Rready),
.AWvalid(),
.Wvalid(),
.ARready(ARready),
.Rdata(Rdata),
.Rvalid(Rvalid),
.AWready(),
.Wready()
);

Wmem wmem(
.clk(clk),
.reset(reset),
.R_address(),
.W_address(AWaddr),
.Wdata(Wdata),
.ARvalid(),
.Rready(),
.AWvalid(AWvalid),
.Wvalid(Wvalid),
.ARready(),
.Rdata(),
.Rvalid(),
.AWready(AWready),
.Wready(Wready)
);
endmodule
