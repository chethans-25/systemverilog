//Author: Chethan Suryanarayanachar

//top module
module HA_top;
  reg A, B;  // Inputs as reg
  wire sum, carry;  // Outputs as wire

  // Instantiate the Half Adder
  Half_adder DUT (.*);
  
  // Instantiate the testbench
  Half_adder_tb TB();

  // Dump waveform
  initial begin
    $dumpfile("HA_top.vcd");
    $dumpvars(1, HA_top);
  end
endmodule


// Testbench using program block
program Half_adder_tb();
  reg A, B;

  // Testbench initialization
  initial begin
    A = 1'b0; B = 1'b0;
    #5 A = 1'b0; B = 1'b1;
    #5 A = 1'b1; B = 1'b0;
    #5 A = 1'b1; B = 1'b1;

    #10 $finish;
  end

  // Connect inputs to DUT in HA_top
  assign HA_top.A = A;
  assign HA_top.B = B;

endprogram


//Design
module Half_adder(input logic  A, B, output logic sum, carry);
  assign sum=A^B;
  assign carry = A&B;
endmodule