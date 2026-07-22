class scorecard;
  transaction tr;
  transaction exptr;
  mailbox mb1;
  mailbox mb2;
  function new(mailbox mb1,mailbox mb2);
    this.mb1=mb1;
    this.mb2=mb2;
  endfunction
  task compare();
    begin
      mb1.get(tr);
      mb2.get(exptr);
   if(exptr.address==tr.address && exptr.enable==tr.enable&&exptr.wr_en==tr.wr_en)
   begin
     if(exptr.data_out == tr.data_out)
        $display("PASS");
    else
       $display("FAIL Expected=%0h Actual=%0h",
         exptr.data_out,
         tr.data_out);
end
     else
       begin
         $display("control signlas are giving error");
       end
    end
  endtask
  task run();
    begin
      forever
        compare();
    end
  endtask
endclass
  
  