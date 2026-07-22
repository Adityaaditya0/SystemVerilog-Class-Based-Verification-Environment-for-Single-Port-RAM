class driver;
  virtual ram_if vif;
  mailbox #(ram_txn) gen2drv;
  int unsigned num_txns;

  function new(virtual ram_if vif, mailbox #(ram_txn) gen2drv, int unsigned num_txns);
    this.vif      = vif;
    this.gen2drv  = gen2drv;
    this.num_txns = num_txns;
  endfunction

  task reset_signals();
    vif.en    <= 1'b0;
    vif.we    <= 1'b0;
    vif.addr  <= '0;
    vif.wdata <= '0;
  endtask

  task run();
    ram_txn tx;
    reset_signals();
    repeat (num_txns) begin
      gen2drv.get(tx);
      @(negedge vif.clk);
      vif.en    <= tx.en;
      vif.we    <= tx.we;
      vif.addr  <= tx.addr;
      vif.wdata <= tx.wdata;
    end
    @(negedge vif.clk);
    reset_signals();
  endtask
endclass
