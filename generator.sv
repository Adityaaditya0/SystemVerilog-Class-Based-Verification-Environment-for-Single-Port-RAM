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
