module tb_fifo;
  parameter WIDTH = 16;
  parameter DEPTH = 16;
  parameter PTR_WIDTH = $clog2(DEPTH);
  
   reg clk_i,rst_i,wr_en_i,rd_en_i;
   reg [WIDTH-1:0]wdata_i;
   wire [WIDTH-1:0]rdata_o;
   wire full_o,empty_o,error_o;

fifo dut(.*);

initial begin
clk_i = 1'b0;
forever #5 clk_i = ~clk_i;
end

initial begin
rst_i = 1;
wr_en_i = 0;
rd_en_i = 0;
wdata_i = 0;

@(posedge clk_i)

rst_i = 0;

repeat(5) begin
@(posedge clk_i)
if(full_o == 0)begin
wr_en_i = 1;
wdata_i = $urandom_range(5,50);
$display("wr_en_i = %0b,wdata_i = %0b,full_o = %0b",wr_en_i,wdata_i,full_o);
end
else begin
wr_en_i = 0;
$display("NO WRITE OPERATION");
end
end

@(posedge clk_i)
wr_en_i = 0;
rd_en_i = 0;
wdata_i = 0;

repeat(5) begin
@(posedge clk_i)
if(empty_o == 0)begin
rd_en_i = 1;
$display("rd_en_i = %0b,rdata_o = %0b,empty_o = %0b",rd_en_i,rdata_o,empty_o);
end
else begin
rd_en_i = 0;
$display("NO READ OPERATION");
end
end

@(posedge clk_i)  
rst_i = 1;
#250;
$finish;
 
end

initial begin
$dumpfile("dump.vcd");
$dumpvars(1);
end

endmodule
