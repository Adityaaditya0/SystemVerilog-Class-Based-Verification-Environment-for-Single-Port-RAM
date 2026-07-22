class coverage_collector;
  mailbox #(ram_txn) mon2cov;
  int unsigned num_txns;
  ram_txn sample_txn;

  covergroup ram_cg;
    option.per_instance = 1;
    cp_we        : coverpoint sample_txn.we;
    cp_addr      : coverpoint sample_txn.addr;
    cp_data      : coverpoint sample_txn.wdata;
    cp_we_x_addr : cross cp_we, cp_addr;
  endgroup

  function new(mailbox #(ram_txn) mon2cov, int unsigned num_txns);
    this.mon2cov  = mon2cov;
    this.num_txns = num_txns;
    ram_cg = new();
  endfunction

  task run();
    repeat (num_txns) begin
      mon2cov.get(sample_txn);
      ram_cg.sample();
    end
    $display("Functional coverage: %0.2f%%", ram_cg.get_coverage());
  endtask
endclass
