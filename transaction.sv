class ram_txn;
  rand bit                  en;
  rand bit                  we;
  rand bit [3:0]            addr;
  rand bit [7:0]            wdata;
       bit [7:0]            rdata;
       bit [7:0]            exp_rdata;

  constraint c_valid { en == 1'b1; }

  function ram_txn clone();
    ram_txn c = new();
    c.en        = en;
    c.we        = we;
    c.addr      = addr;
    c.wdata     = wdata;
    c.rdata     = rdata;
    c.exp_rdata = exp_rdata;
    return c;
  endfunction
endclass
