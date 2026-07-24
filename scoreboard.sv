class scoreboard;
  mailbox #(ram_txn) mon2scb;
  mailbox #(ram_txn) rm2scb;
  int unsigned num_txns;
  int unsigned pass_count;
  int unsigned fail_count;

  function new(mailbox #(ram_txn) mon2scb, mailbox #(ram_txn) rm2scb, int unsigned num_txns);
    this.mon2scb  = mon2scb;
    this.rm2scb   = rm2scb;
    this.num_txns = num_txns;
    pass_count    = 0;
    fail_count    = 0;
  endfunction

  task run();
    ram_txn actual;
    ram_txn expected;
    repeat (num_txns) begin
      mon2scb.get(actual);
      rm2scb.get(expected);
      if (actual.en && !actual.we) begin
        if (actual.rdata === expected.exp_rdata) begin
          pass_count++;
        end else begin
          fail_count++;
          $error("Scoreboard mismatch: addr=0x%0h exp=0x%0h got=0x%0h",
                 actual.addr, expected.exp_rdata, actual.rdata);
        end
      end
    end
    $display("Scoreboard summary: reads_pass=%0d reads_fail=%0d", pass_count, fail_count);
    if (fail_count != 0) begin
      $fatal(1, "Scoreboard detected %0d failures", fail_count);
    end
  endtask
endclass
