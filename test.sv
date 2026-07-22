// import adi_pkg::*;
// import ram_pkg::*;

//   `include "transaction.sv"
//     `include "generator.sv"
//     `include "driver.sv"
  
   // `include "environment.sv"
class test;

   environment env;

  virtual ram_if vif;


  function new(virtual ram_if vif);

        this.vif=vif;
        env=new(vif);

    endfunction

    //---------------------------------
    // Configure Task (Optional)
    //---------------------------------

    task configure();

      env.ge.count=10;

    endtask

    //---------------------------------
    // Run Task
    //---------------------------------

    task run();
      begin

      env.build();
      configure();
      env.run();
      end
    endtask

endclass