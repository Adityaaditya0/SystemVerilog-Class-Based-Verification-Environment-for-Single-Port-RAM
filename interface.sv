interface ram_if(input bit clk);

    logic rst;
    logic enable;
    logic wr_en;
    logic [3:0] address;
    logic [7:0] data_in;
    logic [7:0] data_out;

 

endinterface