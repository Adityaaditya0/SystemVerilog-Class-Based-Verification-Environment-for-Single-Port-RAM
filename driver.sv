// import adi_pkg::*;
// // import ram_pkg::*;
//  `include "transaction.sv"
//     `include "generator.sv"
class driver;

   transaction tr;
   mailbox mb;
  virtual ram_if vif;
  function new(mailbox mb, virtual ram_if vif);
    this.mb=mb;
    this.vif=vif;
  endfunction
     //------------------------------------------------    // Reset Task
    //--------------------------------------------------
    task reset();
      vif.rst=0;
      vif.wr_en=0;
      vif.address=0;
      vif.data_in=0;
      vif.enable=0;
      @(posedge vif.clk);
      vif.rst=1;
    endtask

    task drive();
  
       mb.get(tr);
       tr.display("DRIVER");  
      // <-- Print it here
      @(posedge vif.clk);
      vif.wr_en=tr.wr_en;
      vif.address=tr.address;
      vif.data_in=tr.data_in;
      vif.enable=tr.enable;
       @(posedge vif.clk)
      #12;
       tr.data_out=vif.data_out;
      tr.display("DRIVER OUTPUT");
      
    // Clear interface after transaction
    vif.enable  = 0;
    vif.wr_en   = 0;
    vif.address = 0;
    vif.data_in = 0;
 
    endtask

    task run();

      reset();
        forever
        begin
          drive();
        end

    endtask

endclass