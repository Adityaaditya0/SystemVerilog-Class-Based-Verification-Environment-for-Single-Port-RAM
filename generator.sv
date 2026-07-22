class generator;

    // Transaction Handle
    transaction tr;

    // Mailbox Handle
    mailbox mb;

    // Number of Transactions
    int count;

    // Constructor
    function new(mailbox mb);
        this.mb = mb;
    endfunction

    // Main Task
    task run();

        //==========================================================
        // RANDOM TRANSACTIONS
        //==========================================================

        repeat(count) begin

            tr = new();

            if(!tr.randomize())
                $display("[GENERATOR] Randomization Failed");

            tr.display("GENERATOR");

            mb.put(tr);

        end


        //==========================================================
        // DIRECTED WRITE TRANSACTION
        // Uncomment if required
        //==========================================================

        /*
        tr = new();

        tr.enable  = 1;
        tr.wr_en   = 1;
        tr.address = 3;
        tr.data_in = 8'hAA;

        tr.display("GENERATOR");

        mb.put(tr);
        */


        //==========================================================
        // DIRECTED READ TRANSACTION
        // Uncomment if required
        //==========================================================

        /*
        tr = new();

        tr.enable  = 1;
        tr.wr_en   = 0;
        tr.address = 3;
        tr.data_in = 8'h00;

        tr.display("GENERATOR");

        mb.put(tr);
        */

    endtask

endclass