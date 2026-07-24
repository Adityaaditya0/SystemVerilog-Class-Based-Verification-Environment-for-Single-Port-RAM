module single_port_ram #(
  parameter int ADDR_WIDTH = 4,
  parameter int DATA_WIDTH = 8
) (
  input  logic                  clk,
  input  logic                  rst_n,
  input  logic                  en,
  input  logic                  we,
  input  logic [ADDR_WIDTH-1:0] addr,
  input  logic [DATA_WIDTH-1:0] wdata,
  output logic [DATA_WIDTH-1:0] rdata
);
  logic [DATA_WIDTH-1:0] mem [(2**ADDR_WIDTH)-1:0];

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rdata <= '0;
    end else if (en) begin
      if (we) begin
        mem[addr] <= wdata;
      end else begin
        rdata <= mem[addr];
      end
    end
  end
endmodule
