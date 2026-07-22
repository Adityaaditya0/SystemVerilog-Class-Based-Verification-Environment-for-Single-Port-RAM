`timescale 1ns/1ps

`include "interface.sv"
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "reference_model.sv"
`include "scoreboard.sv"
`include "coverage.sv"
`include "environment.sv"
`include "test.sv"

module testbench;
  localparam int ADDR_WIDTH = 4;
  localparam int DATA_WIDTH = 8;

  ram_if #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) vif();

  single_port_ram #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) dut (
    .clk   (vif.clk),
    .rst_n (vif.rst_n),
    .en    (vif.en),
    .we    (vif.we),
    .addr  (vif.addr),
    .wdata (vif.wdata),
    .rdata (vif.rdata)
  );

  ram_test t;

  initial begin
    vif.clk = 1'b0;
    forever #5 vif.clk = ~vif.clk;
  end

  initial begin
    vif.rst_n = 1'b0;
    vif.en    = 1'b0;
    vif.we    = 1'b0;
    vif.addr  = '0;
    vif.wdata = '0;

    repeat (2) @(posedge vif.clk);
    vif.rst_n = 1'b1;
    repeat (1) @(posedge vif.clk);

    t = new(vif);
    t.run();
    $finish;
  end
endmodule
