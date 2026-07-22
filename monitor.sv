class monitor;

    transaction tr;

  mailbox  mb1;
  mailbox mb2;
  mailbox mb3;
  virtual ram_if vif;
  function new(mailbox mb1,mailbox mb2,mailbox mb3,virtual ram_if vif);
    this.vif=vif;
    this.mb1=mb1;
    this.mb2=mb2;
    this.mb3=mb3;
  endfunction
  task sample();
begin
      @(posedge vif.clk);
  #1;

  if(vif.enable==1'b1) begin
          tr = new();

          tr.wr_en   = vif.wr_en;
          tr.address = vif.address;
          tr.data_in = vif.data_in;
          tr.enable  = vif.enable;
          tr.data_out= vif.data_out;

          tr.display("monitor");

          mb1.put(tr);
          mb2.put(tr);
          mb3.put(tr);
      end
end
endtask
  task run();
    begin
      forever begin
      sample();
      end
    end
  endtask
endclass