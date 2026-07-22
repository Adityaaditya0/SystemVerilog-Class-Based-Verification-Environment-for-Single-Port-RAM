// Code your design here
module ram #(
  parameter DEPTH =10,
  parameter WIDTH =8)
  (
    input [$clog2(DEPTH)-1:0]  address ,
    input              clk,
    input              rst,
    input [WIDTH-1:0]  data_in ,
    input              wr_en,
    input              enable,
    output reg [WIDTH-1:0] data_out
  );
  reg [WIDTH-1:0] mem [DEPTH-1:0];
  always @(posedge clk )begin
    if(!rst)
      data_out<=0;
    else if(enable&&wr_en)
      begin
        mem[address]<=data_in;
      end
    else if(enable&&!wr_en)
      begin
        data_out<=mem[address];
      end
    else begin
      data_out<=8'bx;
    end
  end
  
 endmodule
      
        
           