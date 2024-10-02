 
//Author: Chethan Suryanarayanachar

//top module
module top();
  reg t;
  bit clk,rst;
  wire q;
  TFF DUT(.*);
  TFF_TB TB(.*);
  
endmodule 

//Testbench
program TFF_TB(t,clk,rst, q);
  output reg t;
  output bit clk,rst;
  input reg q;
  
  initial forever #3 clk= ~clk;
   
  initial begin
    
    rst=1;t=0;
    #7 rst=0;
    #7 t= 1;
    #21 rst=1;
    #7 rst=0;
    #7 t= 1;
    #20 $finish;
  end 
  
    
  initial begin
    $dumpfile("top.vcd");
    $dumpvars(2,top);
  end
  
endprogram


//Design
module TFF(t,clk,rst, q);
  input reg t; 
  input bit clk,rst;
  output reg q;
  
  always_ff @ (posedge clk) begin
    if(rst) q<=0;
    else if(t) q<=~q;
    else q<=q;
  end 
endmodule 
 
