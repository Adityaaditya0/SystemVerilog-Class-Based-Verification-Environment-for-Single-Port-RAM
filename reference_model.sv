class reference_model;
  mailbox #(ram_txn) mon2rm;
  mailbox #(ram_txn) rm2scb;
  bit [7:0] mem[15:0];
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
