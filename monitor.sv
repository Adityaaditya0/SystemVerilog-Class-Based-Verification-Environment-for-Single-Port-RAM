class monitor;
  virtual ram_if vif;
  mailbox #(ram_txn) mon2rm;
  mailbox #(ram_txn) mon2scb;
  mailbox #(ram_txn) mon2cov;
  int unsigned num_txns;

  function new(
    virtual ram_if vif,
    mailbox #(ram_txn) mon2rm,
    mailbox #(ram_txn) mon2scb,
    mailbox #(ram_txn) mon2cov,
    int unsigned num_txns
  );
    this.vif      = vif;
    this.mon2rm   = mon2rm;
    this.mon2scb  = mon2scb;
    this.mon2cov  = mon2cov;
    this.num_txns = num_txns;
  endfunction

  task run();
    ram_txn tx;
    repeat (num_txns) begin
      @(posedge vif.clk);
      if (vif.en) begin
        tx       = new();
        tx.en    = vif.en;
        tx.we    = vif.we;
        tx.addr  = vif.addr;
        tx.wdata = vif.wdata;
        @(negedge vif.clk);
        tx.rdata = vif.rdata;
        mon2rm.put(tx.clone());
        mon2scb.put(tx.clone());
        mon2cov.put(tx.clone());
      end
    end
  endtask
endclass
