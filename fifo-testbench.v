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


rst_i = 1;
@(posedge clk_i)
wr_en_i = 0;
rd_en_i = 0;
wdata_i = 0;

rst_i = 0;

repeat(5) begin
@(posedge clk_i)
if(full_o == 0)begin
wr_en = 1;
wdata_i = $urandom_range(5,50);
$dispaly("wr_en = %0b,wdata_i = %0b",wr_en,wdata_i,full_o);
end
else begin
wr_en_i = 0;
$display("NO WRITE OPERATION")

@(posedge clk_i)
wr_en_i = 0;
rd_en_i = 0;
wdata_i = 0;

repeat(5) begin
@(posedge clk_i)
if(empty_o == 0)begin
rd_en = 1;
$dispaly("rd_en_i = %0b,rdata_i = %0b",rd_en_i,rdata_i,empty_o);
end
else begin
rd_en_i = 0;
$display("NO READ OPERATION")
end

rst_i = 1;
#250;
$finish;
 
end

initial begin
$dump.file(dump.vcd);
$dump.vars(1)
end

endmodule
