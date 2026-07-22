package ram_verif_pkg;
  parameter int ADDR_WIDTH = 4;
  parameter int DATA_WIDTH = 8;

  class ram_txn;
    rand bit                     en;
    rand bit                     we;
    rand bit [ADDR_WIDTH-1:0]    addr;
    rand bit [DATA_WIDTH-1:0]    wdata;
         bit [DATA_WIDTH-1:0]    rdata;
         bit [DATA_WIDTH-1:0]    exp_rdata;

    constraint c_valid { en == 1'b1; }

    function ram_txn clone();
      ram_txn c = new();
      c.en       = en;
      c.we       = we;
      c.addr     = addr;
      c.wdata    = wdata;
      c.rdata    = rdata;
      c.exp_rdata = exp_rdata;
      return c;
    endfunction
  endclass

  class generator;
    mailbox #(ram_txn) gen2drv;
    int unsigned num_txns;
    bit directed_mode;

    function new(mailbox #(ram_txn) gen2drv, int unsigned num_txns, bit directed_mode);
      this.gen2drv       = gen2drv;
      this.num_txns      = num_txns;
      this.directed_mode = directed_mode;
    endfunction

    task run();
      ram_txn tx;
      if (directed_mode) begin
        tx = new(); tx.en = 1'b1; tx.we = 1'b1; tx.addr = 4'h0; tx.wdata = 8'hA5; gen2drv.put(tx);
        tx = new(); tx.en = 1'b1; tx.we = 1'b1; tx.addr = 4'h1; tx.wdata = 8'h3C; gen2drv.put(tx);
        tx = new(); tx.en = 1'b1; tx.we = 1'b1; tx.addr = 4'h2; tx.wdata = 8'hF0; gen2drv.put(tx);
        tx = new(); tx.en = 1'b1; tx.we = 1'b1; tx.addr = 4'h3; tx.wdata = 8'h55; gen2drv.put(tx);
        tx = new(); tx.en = 1'b1; tx.we = 1'b0; tx.addr = 4'h0; tx.wdata = '0;    gen2drv.put(tx);
        tx = new(); tx.en = 1'b1; tx.we = 1'b0; tx.addr = 4'h1; tx.wdata = '0;    gen2drv.put(tx);
        tx = new(); tx.en = 1'b1; tx.we = 1'b0; tx.addr = 4'h2; tx.wdata = '0;    gen2drv.put(tx);
        tx = new(); tx.en = 1'b1; tx.we = 1'b0; tx.addr = 4'h3; tx.wdata = '0;    gen2drv.put(tx);
      end else begin
        repeat (num_txns) begin
          tx = new();
          if (!tx.randomize()) begin
            $fatal(1, "Generator randomization failed");
          end
          gen2drv.put(tx);
        end
      end
    endtask
  endclass

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

  class reference_model;
    mailbox #(ram_txn) mon2rm;
    mailbox #(ram_txn) rm2scb;
    bit [DATA_WIDTH-1:0] mem[(2**ADDR_WIDTH)-1:0];
    int unsigned num_txns;

    function new(mailbox #(ram_txn) mon2rm, mailbox #(ram_txn) rm2scb, int unsigned num_txns);
      this.mon2rm   = mon2rm;
      this.rm2scb   = rm2scb;
      this.num_txns = num_txns;
      foreach (mem[i]) mem[i] = '0;
    endfunction

    task run();
      ram_txn tx;
      repeat (num_txns) begin
        mon2rm.get(tx);
        if (tx.en && tx.we) begin
          mem[tx.addr] = tx.wdata;
        end
        if (tx.en && !tx.we) begin
          tx.exp_rdata = mem[tx.addr];
        end
        rm2scb.put(tx);
      end
    endtask
  endclass

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

  class coverage_collector;
    mailbox #(ram_txn) mon2cov;
    int unsigned num_txns;
    ram_txn sample_txn;

    covergroup ram_cg;
      option.per_instance = 1;
      cp_we   : coverpoint sample_txn.we;
      cp_addr : coverpoint sample_txn.addr;
      cp_data : coverpoint sample_txn.wdata;
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
endpackage
