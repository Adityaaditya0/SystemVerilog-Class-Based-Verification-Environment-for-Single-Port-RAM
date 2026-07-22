# SystemVerilog-Class-Based-Verification-Environment-for-Single-Port-RAM
Class-based SystemVerilog verification environment for synchronous single-port RAM using constrained-random stimulus, mailbox communication, scoreboard, reference model, and functional coverage.

## Repository contents
- `design.sv` - synchronous single-port RAM DUT
- `interface.sv` - RAM virtual interface
- `transaction.sv` - transaction class
- `generator.sv` - stimulus generator
- `driver.sv` - DUT driver
- `monitor.sv` - DUT monitor
- `reference_model.sv` - expected-data model
- `scoreboard.sv` - self-checking comparator
- `coverage.sv` - functional coverage collector
- `environment.sv` - environment assembly
- `test.sv` - test control class
- `testbench.sv` - top-level testbench

## Test modes
- **Constrained-random (default):** random read/write transactions with mailbox-based communication.
- **Directed (`+DIRECTED`):** fixed write/read sequence for deterministic sanity checking.

Both modes are self-checking via scoreboard + reference model and print functional coverage at end of test.

## Example simulation (Icarus Verilog)
```sh
iverilog -g2012 -o simv design.sv testbench.sv
vvp simv
vvp simv +DIRECTED
vvp simv +NUM_TXNS=200
```
