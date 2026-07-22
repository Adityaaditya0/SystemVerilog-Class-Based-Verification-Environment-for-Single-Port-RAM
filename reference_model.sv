class reference_model;
    transaction tr;

   transaction exp_tr;

    // Mailbox to receive transactions from monitor
    mailbox mon1;

    // Mailbox to send expected transactions to scoreboard
    mailbox mon2;

    // Golden memory (same size as DUT memory)
    // Declare your memory here
    // bit [WIDTH-1:0] golden_mem [0:DEPTH-1];
    // or
   bit [7:0] golden_mem [0:9];


    // Constructor
  function new(mailbox mon1, mailbox mon2);
     this.mon1=mon1;
     this.mon2=mon2;
   

    endfunction


    // Task that predicts the DUT behavior
    task predict();

      exp_tr=new();
      mon1.get(tr);
              // Copy common fields
        exp_tr.address = tr.address;
        exp_tr.data_in = tr.data_in;
        exp_tr.wr_en   = tr.wr_en;
        exp_tr.enable  = tr.enable;

      if(tr.enable)
        begin
          if(tr.wr_en)
            golden_mem[exp_tr.address]=exp_tr.data_in;
          else
            exp_tr.data_out=golden_mem[exp_tr.address];
        end
          else
            exp_tr.data_out=8'bx;
      exp_tr.display("EXPECTED");
      mon2.put(exp_tr);
      

    endtask


    // Run continuously
    task run();

       forever
         predict();

    endtask

endclass