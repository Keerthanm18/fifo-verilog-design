module fifo(clk_i,rst_i,wdata_i,rdata_o,wr_en_i,rd_en_i,full_o,error_o,empty_o);
parameter WIDTH=16;
parameter DEPTH=16;
parameter PTR_WIDTH=$clog2(DEPTH);
//port declarations
input clk_i,rst_i,wr_en_i,rd_en_i;
input [WIDTH-1:0]wdata_i;
output reg [WIDTH-1:0]rdata_o;
output reg full_o,error_o,empty_o;
integer i;

//internal registsers
reg [PTR_WIDTH-1:0]wr_ptr;
reg [PTR_WIDTH-1:0]rd_ptr;
reg wr_toggle;
reg rd_toggle;
reg [WIDTH-1:0]mem[DEPTH-1:0];
always@(posedge clk_i)begin
	if(rst_i==1)begin
		wr_ptr=0;
		rd_ptr=0;
		wr_toggle=0;
		rd_toggle=0;
		rdata_o=0;
		full_o=0;
		error_o=0;
		empty_o=1;
		for(i=0;i<DEPTH;i=i+1)begin
			mem[i]=0;
		end
	end
	else begin
		error_o=0;
	if(wr_en_i==1)begin//do write operation
		if(full_o==1)begin
			error_o=1;
		end
		else begin
			mem[wr_ptr]=wdata_i;
			if(wr_ptr==DEPTH-1)begin
				wr_toggle=~wr_toggle;
				wr_ptr=0;
			end
			else begin
				wr_ptr=wr_ptr+1;
			end
		end
	end
	if(rd_en_i==1)begin//do read operation
		if(empty_o==1)begin
			error_o=1;
		end
		else begin 
			rdata_o=mem[rd_ptr];
			if(rd_ptr==DEPTH-1)begin
				rd_toggle=~rd_toggle;
				rd_ptr=0;
			end
			else begin
				rd_ptr=rd_ptr+1;
			end
		end
	end
end
end
	always@(*)begin
if((wr_ptr==rd_ptr) && (wr_toggle==rd_toggle))begin
	empty_o=1;
end

if((wr_ptr==rd_ptr) && (wr_toggle!=rd_toggle))begin
	full_o=1;
end
end

endmodule


