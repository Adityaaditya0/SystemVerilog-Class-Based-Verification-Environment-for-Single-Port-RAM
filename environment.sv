class ram_env;
  virtual ram_if vif;
  mailbox #(ram_txn) gen2drv;
  mailbox #(ram_txn) mon2rm;
  mailbox #(ram_txn) mon2scb;
  mailbox #(ram_txn) mon2cov;
  mailbox #(ram_txn) rm2scb;
  generator          gen;
  driver             drv;
  monitor            mon;
  reference_model    rm;
  scoreboard         scb;
  coverage_collector cov;
  int unsigned       num_txns;
  bit                directed_mode;

  function new(virtual ram_if vif, int unsigned num_txns, bit directed_mode);
    this.vif           = vif;
    this.directed_mode = directed_mode;
    this.num_txns      = directed_mode ? 8 : num_txns;
    gen2drv = new();
    mon2rm  = new();
    mon2scb = new();
    mon2cov = new();
    rm2scb  = new();
    gen = new(gen2drv, this.num_txns, directed_mode);
    drv = new(vif, gen2drv, this.num_txns);
    mon = new(vif, mon2rm, mon2scb, mon2cov, this.num_txns);
    rm  = new(mon2rm, rm2scb, this.num_txns);
    scb = new(mon2scb, rm2scb, this.num_txns);
    cov = new(mon2cov, this.num_txns);
  endfunction

  task run();
    fork
      gen.run();
      drv.run();
      mon.run();
      rm.run();
      scb.run();
      cov.run();
    join
  endtask
endclass
