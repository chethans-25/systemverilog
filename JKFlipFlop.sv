//Author: Chethan Suryanarayanachar

//top module

module top();
  reg  J,K;
  bit clk,rst;
  wire q;
  JKFF dut(.*);
  JKFF_TB TB(.*);
endmodule 

//testbench
program JKFF_TB(J,K,clk,rst, q);
  output reg J,K;
  output bit clk,rst;
  input wire q;
  
  initial forever #3 clk= ~clk;

  initial begin
   
    rst = 1; J = 0; K = 0;  //reset
    #7 rst = 0;             // Release reset 
    
    //  Hold
    #7 J = 0; K = 0;       

    // Reset 
    #7 J = 0; K = 1;      

    //  Set
    #7 J = 1; K = 0;       

    // Toggle 
    #7 J = 1; K = 1;     
    
    #14 J = 0; K = 1;       
    #7 J = 1; K = 1;        
    
    #20 $finish;          
  end
  
  
  initial begin
    $dumpfile("top.vcd");
    $dumpvars(1,top);
  end

  
endprogram



//design
module JKFF(J,K,clk,rst, q);
  input J,K; 
  input bit clk,rst;
  output reg q;
  
  always_ff @ (posedge clk) begin
    if(rst) q<=0;
    else begin
      case ({J,K})
       2'b00:q<=q;//hold
       2'b01:q<=1'b0;//reset
       2'b10:q<=1'b1;//set
       2'b11:q<=~q;//toggle
      endcase
    end
  end 
endmodule 
 