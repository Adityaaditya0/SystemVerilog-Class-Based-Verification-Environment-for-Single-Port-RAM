interface ram_if #(
  parameter int ADDR_WIDTH = 4,
  parameter int DATA_WIDTH = 8
);
  logic                  clk;
  logic                  rst_n;
  logic                  en;
  logic                  we;
  logic [ADDR_WIDTH-1:0] addr;
  logic [DATA_WIDTH-1:0] wdata;
  logic [DATA_WIDTH-1:0] rdata;
endinterface
