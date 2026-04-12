`timescale 1ns / 1ps
module tb();
reg clk;
reg reset;
reg [127:0]key;
reg start;
reg key_valid;
reg [9:0]source_address;
reg [8:0]blocks;
reg [95:0]nounce;
wire done;
Top #(.MODE(0))tp(clk,reset,key,source_address,blocks,start,key_valid,nounce,done);
initial 
clk=0;
always #5 clk=~clk;
initial 
begin
$readmemh("C:/Users/yashd/Desktop/testvectoraes.hex", tp.rmem.memory);
#3 reset=1; start=0;
#5 reset=0;
#1 source_address=0; key=128'h2B7E151628AED2A6ABF7158809CF4F3C ;nounce=96'hDADACACADADACACADADACACA; blocks=64; start=1; key_valid=1;
end  
initial 
begin 
$dumpfile("test.vcd");
$dumpvars(0,tp);
 wait(done);        
    #20;

    $writememh("C:/Users/yashd/Desktop/NNNEEEtestop.hex", tp.wmem.memory);

    $display("Dump complete");
    $finish;
end 
endmodule
