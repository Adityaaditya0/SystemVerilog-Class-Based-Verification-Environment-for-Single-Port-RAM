# SystemVerilog-Class-Based-Verification-Environment-for-Single-Port-RAM
Class-based SystemVerilog verification environment for synchronous single-port RAM using constrained-random stimulus, mailbox communication, scoreboard, reference model, and functional coverage.

## Repository contents
- `rtl/single_port_ram.sv` - synchronous single-port RAM DUT
- `tb/ram_verif_pkg.sv` - reusable verification components:
  - Transaction
  - Generator
  - Driver
  - Monitor
  - Reference Model
  - Scoreboard
  - Functional Coverage Collector
  - Environment wrapper
- `tb/tb_single_port_ram.sv` - top-level testbench and interface wiring

## Test modes
- **Constrained-random (default):** random read/write transactions with mailbox-based communication.
- **Directed (`+DIRECTED`):** fixed write/read sequence for deterministic sanity checking.

Both modes are self-checking via scoreboard + reference model and print functional coverage at end of test.

## Example simulation (Icarus Verilog)
```sh
iverilog -g2012 -o simv rtl/single_port_ram.sv tb/tb_single_port_ram.sv
vvp simv
vvp simv +DIRECTED
vvp simv +NUM_TXNS=200
```
