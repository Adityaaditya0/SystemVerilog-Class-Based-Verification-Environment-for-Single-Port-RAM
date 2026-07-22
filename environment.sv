// import adi_pkg::*;
// // import ram_pkg::*;
// `include "transaction.sv"
//     `include "generator.sv"
//     `include "driver.sv"
class environment;

     generator ge;
     driver da;
     mailbox mb1;
     mailbox mb2;
     mailbox mb3;
     mailbox mb4;
     mailbox mb5;
     monitor mn;
     reference_model r;
     scorecard sb;
    coverage cv;
    virtual ram_if vif;
  

  function new(virtual ram_if vif);
    this.vif=vif;
  endfunction

    //---------------------------------
    // Build Task
    //---------------------------------

    task build();
      mb1=new();
      mb2=new();
      mb3=new();
      mb4=new();
      mb5=new();
      ge=new(mb1);
      da=new(mb1,vif);
      mn=new(mb2,mb3,mb5,vif);
      r=new(mb2,mb4);
      sb=new(mb3,mb4);
      cv=new(mb5);
    endtask

    //---------------------------------
    // Run Task
    //---------------------------------

    task run();
 fork
      ge.run();
      da.run();
      mn.run();
      r.run();
      sb.run();
      cv.run();
 join
    endtask

endclass