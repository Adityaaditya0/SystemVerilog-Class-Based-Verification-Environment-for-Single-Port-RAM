class ram_test;
  virtual ram_if vif;
  ram_env env;
  int unsigned num_txns;
  bit directed_mode;

  function new(virtual ram_if vif);
    this.vif = vif;
    this.num_txns = 100;
    this.directed_mode = 1'b0;
  endfunction

  task run();
    if ($value$plusargs("NUM_TXNS=%d", num_txns)) begin
      $display("NUM_TXNS set to %0d", num_txns);
    end
    if ($test$plusargs("DIRECTED")) begin
      directed_mode = 1'b1;
      $display("Running directed test");
    end else begin
      $display("Running constrained-random test");
    end

    env = new(vif, num_txns, directed_mode);
    env.run();
    $display("TEST PASSED");
  endtask
endclass
