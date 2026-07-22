`timescale 1ns/1ps

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

`include "ram_verif_pkg.sv"

module tb_single_port_ram;
  import ram_verif_pkg::*;

  localparam int ADDR_WIDTH_L = 4;
  localparam int DATA_WIDTH_L = 8;
  int unsigned num_txns = 100;
  bit directed_mode = 0;

  ram_if #(
    .ADDR_WIDTH(ADDR_WIDTH_L),
    .DATA_WIDTH(DATA_WIDTH_L)
  ) vif();

  single_port_ram #(
    .ADDR_WIDTH(ADDR_WIDTH_L),
    .DATA_WIDTH(DATA_WIDTH_L)
  ) dut (
    .clk   (vif.clk),
    .rst_n (vif.rst_n),
    .en    (vif.en),
    .we    (vif.we),
    .addr  (vif.addr),
    .wdata (vif.wdata),
    .rdata (vif.rdata)
  );

  ram_env env;

  initial begin
    vif.clk = 1'b0;
    forever #5 vif.clk = ~vif.clk;
  end

  initial begin
    if ($value$plusargs("NUM_TXNS=%d", num_txns)) begin
      $display("NUM_TXNS set to %0d", num_txns);
    end
    if ($test$plusargs("DIRECTED")) begin
      directed_mode = 1'b1;
      $display("Running directed test");
    end else begin
      $display("Running constrained-random test");
    end

    vif.rst_n = 1'b0;
    vif.en    = 1'b0;
    vif.we    = 1'b0;
    vif.addr  = '0;
    vif.wdata = '0;

    repeat (2) @(posedge vif.clk);
    vif.rst_n = 1'b1;
    repeat (1) @(posedge vif.clk);

    env = new(vif, num_txns, directed_mode);
    env.run();

    $display("TEST PASSED");
    $finish;
  end
endmodule
