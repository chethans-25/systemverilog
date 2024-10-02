//author : Chethan Suryanarayanchar


module testbench();

// Parameters
parameter DEPTH = 8;
parameter DWIDTH = 32;

// Testbench signals
reg rstwn, rstrn;
reg wr_clk;
reg rd_clk;
reg wr_en;
reg rd_en;
reg [DWIDTH-1:0] din;
wire [DWIDTH-1:0] out;
wire empty;
wire full;
wire  [DWIDTH-1:0] FIFO [0:DEPTH-1];

// Instantiate the FIFO
async_fifo #(.DEPTH(DEPTH), .DWIDTH(DWIDTH)) dut (
  .rstwn(rstwn),.rstrn(rstrn),
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .din(din),
    .out(out),
    .empty(empty),
  .full(full),
  .FIFO(FIFO)
);

// Clock generation
initial begin
    wr_clk = 0;
    forever #5 wr_clk = ~wr_clk; // Write clock with a period of 10 time units
end

initial begin
    rd_clk = 0;
    forever #7 rd_clk = ~rd_clk; // Read clock with a period of 14 time units
end

// Test process
initial begin
  $dumpfile("testbench.vcd");
  $dumpvars(1,testbench);
    // Initialize inputs
    rstwn = 0;
    rstrn = 0;
    wr_en = 0;
    rd_en = 0;
    din = 0;

    // Release reset
    #10 rstwn = 1;
    rstrn = 1;
    

    // Write data into the FIFO
  
  for (int i = 0; i < DEPTH; i++) begin
    write_fifo($urandom);  
  end
    

    // Read data from the FIFO
  
    #20;
  for (int i = 0; i < DEPTH; i++) begin
    read_fifo();  
  end
    
   
    
    
    // Finish the simulation
    #20;
    $finish;
end

// Task to write data to FIFO
task write_fifo(input [DWIDTH-1:0] data);
    begin
        din = data;
        wr_en = 1;
        #10 wr_en = 0;
    end
endtask

// Task to read data from FIFO
task read_fifo();
    begin
        rd_en = 1;
        #20 rd_en = 0;
    end
endtask

// Monitor signals
initial begin
    $monitor("[%0t] wr_en=%0b rd_en=%0b din=0x%0h out=0x%0h empty=%0b full=%0b", $time, wr_en, rd_en, din, out, empty, full);
end

endmodule



//design

module async_fifo #(parameter DEPTH=8, DWIDTH=32)
( input
rstwn,rstrn,// Active low reset
wr_clk,// Write clock
rd_clk,// Read clock
wr_en,// Write enable
rd_en,// Read enable
input [DWIDTH-1:0] din,// Data written into FIFO
output [DWIDTH-1:0] out,// Data read from FIFO
output
empty,// FIFO is empty when high
full, // FIFO is full when high

 output [DWIDTH-1:0] FIFO [0:DEPTH-1]
);
reg [DWIDTH-1:0] dout;
reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] rptr;
reg [$clog2(DEPTH)-1:0] count;
  reg fp,f,e;
  
// reg [(DWIDTH - 1):0] fifo[DEPTH];
reg [DWIDTH-1:0] fifo [0:DEPTH-1];
  assign FIFO=fifo;
//write operation
always @ (posedge wr_clk) begin
  if (!rstwn) begin
wptr <= 0;
end else begin
if (wr_en & !full) begin fifo[wptr] <= din;
wptr <= wptr + 1;

end
  
end
end

initial begin
  fp<=0;
  f<=0;
  wptr<=0;
  rptr<=0;
  
  $monitor("[%0t] [FIFO] wr_en=%0b din=0x%0h rd_en=%0b dout=0x%0h empty=%0b full=%0b", $time, wr_en, din, rd_en, dout, empty, full);
end

//Read operation
always @ (posedge rd_clk) begin
if (!rstrn) begin
rptr <= 0;
end else begin
  if (rd_en & !empty) begin 
    dout <= fifo[rptr];
    fifo[rptr] <= 16'h0;
    rptr <= rptr + 1;
end
end
end
  
  
  
assign out =dout;


  assign full=((wptr+1)%(DEPTH) ==rptr)?1'b1:1'b0;
  assign empty=(wptr == rptr)?1'b1:1'b0;
  
endmodule