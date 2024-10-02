//Author: Chethan Suryanarayanachar

//top module
module top();
  reg d;
  bit clk,rst;
  wire q;
  DFF dut(.*);
  DFF_TB TB(.*);
endmodule 

//testbench
program DFF_TB(d,clk,rst, q);
  output reg d;
  output bit clk,rst;
  input reg q;
  
  initial forever #3 clk= ~clk;
   
  initial begin
    
    rst=1;d=0;
    #7 rst=0;
    #7 d= 1;
    #21 rst=1;
    #7 rst=0;
    #7 d= 1;
    #20 $finish;
  end 
   
  initial begin
    $dumpfile("top.vcd");
    $dumpvars(1,top);
  end
endprogram

//Design
module DFF(d,clk,rst, q);
  input reg d; 
  input bit clk,rst;
  output reg q;
  
  always_ff @ (posedge clk) begin
    if(rst) q<=0;
    else q<=d;
  end 
endmodule 
 
