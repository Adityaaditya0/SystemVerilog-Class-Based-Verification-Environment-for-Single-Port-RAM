# SystemVerilog-Class-Based-Verification-Environment-for-Single-Port-RAM
Class-based SystemVerilog verification environment for synchronous single-port RAM using constrained-random stimulus, mailbox communication, scoreboard, reference model, and functional coverage.
# SystemVerilog Class-Based Verification Environment for Single-Port RAM

## Overview

This project implements a **class-based verification environment** in **SystemVerilog** to verify the functionality of a **synchronous single-port RAM**. The verification environment follows a modular architecture using object-oriented programming concepts and includes constrained-random testing, directed testing, a reference model, scoreboard, and functional coverage for self-checking verification.

---

## Features

- Class-based SystemVerilog verification environment
- Verification of a synchronous single-port RAM
- Constrained-random transaction generation
- Directed test support
- Mailbox-based communication between verification components
- Virtual interface-based DUT connectivity
- Self-checking scoreboard for automatic result comparison
- Reference (Golden) model for expected output generation
- Functional coverage using SystemVerilog covergroups
- Modular and reusable verification components

---

## Verification Components

- Transaction
- Generator
- Driver
- Monitor
- Reference Model
- Scoreboard
- Functional Coverage
- Environment
- Test

---

## Verification Flow

```text
Generator
    │
    ▼
Driver
    │
    ▼
DUT (Single-Port RAM)
    │
    ▼
Monitor
 ┌────┼────────┐
 ▼    ▼        ▼
Reference   Scoreboard   Coverage
     │
     ▼
Scoreboard
```

---

## Verification Methodology

- Object-Oriented Programming (OOP)
- Transaction-Based Verification
- Constrained-Random Verification
- Directed Testing
- Mailbox Communication
- Virtual Interface
- Self-Checking Testbench
- Functional Coverage

---

## Tools Used

- SystemVerilog
- QuestaSim / ModelSim

---

## Future Enhancements

- Assertion-Based Verification (SVA)
- UVM-based Verification Environment
- Functional Coverage Cross Analysis
- Regression Test Automation

---

## Author

**Aditya**
