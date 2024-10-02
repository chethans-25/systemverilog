//Author: Chethan Suryanarayanachar

//top module
module FA_top;
  reg A, B, Cin;  // Inputs as reg
  wire sum, carry;  // Outputs as wire

  // Instantiate the Half Adder
  Full_adder FA (.A(A), .B(B),.Cin(Cin), .sum(sum), .carry(carry));

  // Instantiate the testbench
  Full_adder_tb TB();

  // Dump waveform
  initial begin
    $dumpfile("FA_top.vcd");
    $dumpvars(1, FA_top);
  end
endmodule

// SystemVerilog Testbench using program block
program Full_adder_tb();
  reg A, B, Cin;

  // Testbench initialization
  initial begin
    A = 1'b0; B = 1'b0; Cin = 1'b0;  // Case 1
    #5 A = 1'b0; B = 1'b0; Cin = 1'b1;  // Case 2
    #5 A = 1'b0; B = 1'b1; Cin = 1'b0;  // Case 3
    #5 A = 1'b0; B = 1'b1; Cin = 1'b1;  // Case 4
    #5 A = 1'b1; B = 1'b0; Cin = 1'b0;  // Case 5
    #5 A = 1'b1; B = 1'b0; Cin = 1'b1;  // Case 6
    #5 A = 1'b1; B = 1'b1; Cin = 1'b0;  // Case 7
    #5 A = 1'b1; B = 1'b1; Cin = 1'b1;  // Case 8

    #10 $finish;
  end

  // Connect inputs to DUT in HA_top
  assign FA_top.A = A;
  assign FA_top.B = B;
  assign FA_top.Cin = Cin;

endprogram

//Designs
module Half_adder(input logic  A, B, output logic sum, carry);
  assign sum=A^B;
  assign carry = A&B;
endmodule

module Full_adder(input logic  A, B,Cin, output logic sum, carry);
  logic c1,c2,s1;
  
  Half_adder HA1 (.A(A), .B(B), .sum(s1), .carry(c1));
  Half_adder HA2 (.A(s1), .B(Cin), .sum(sum), .carry(c2));
  assign carry=c1|c2;
  
endmodule