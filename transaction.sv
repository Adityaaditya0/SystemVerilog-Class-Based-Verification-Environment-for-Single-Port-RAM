
class transaction;
  rand bit        enable;
  rand bit        wr_en;
  rand bit [3:0]  address;
  rand bit [7:0] data_in;
  bit  [7:0]     data_out;

// ---------------------------------------------------------------------------
// Constraints
// ---------------------------------------------------------------------------

// 'enable' should be 1 with 90% probability
constraint enable_c {
  enable dist {1 := 90, 0 := 10};
}

// 'we' should be 1 with 50% probability
constraint we_c {
  wr_en dist {1 := 50, 0 := 50};
}
  constraint add_rc{
    address<4'd10;
  }
// ---------------------------------------------------------------------------
// Utility Functions
// ---------------------------------------------------------------------------

// Function to print the transaction contents
function void display(string name);
  $display("[%s] enable=%0b we=%0b addr=%0d wdata=%0h rdata=%0h",
            name, enable, wr_en, address, data_in, data_out);
endfunction
  
endclass