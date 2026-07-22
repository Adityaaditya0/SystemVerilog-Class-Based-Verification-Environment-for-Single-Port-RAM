class coverage;

    // Transaction Handle
    transaction tr;

    // Mailbox
    mailbox mb;

    // Covergroup
    covergroup ram_cg;

        // Coverpoints
      cp_enable:coverpoint tr.enable;
      cp_wr_en:coverpoint tr.wr_en;
      cp_addr: coverpoint tr.address{
        bins addr[]={[0:9]};
      }
      cp_rw:cross cp_enable ,cp_wr_en;
    endgroup
      


    // Constructor
    function new(mailbox mb);
      this.mb=mb;
      ram_cg=new();
    endfunction


    // Run Task
    task run();

        forever begin
          mb.get(tr);
       $display("[COVERAGE] Sampled addr=%0d", tr.address);

          ram_cg.sample();

        end

    endtask

endclass