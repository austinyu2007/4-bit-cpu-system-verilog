# 4-bit-cpu-systemverilog

A custom 4-bit CPU implemented in SystemVerilog, featuring a 16-opcode instruction set, FSM-based control, and integrated ALU/RAM modules — verified through two independent test programs in simulation.

## Tools Used
- Icarus Verilog
- GTKWave for waveform

## Overview
This project implements a simple but complete CPU architecture from scratch, including:

- A 16-opcode ISA: 11 ALU operations (ADD, SUB, AND, OR, XOR, NOT, NAND, NOR, left-shift, right-shift, INC) plus 5 control/memory instructions (MOV, JMP, LOAD, STORE, HALT)
- A fetch-decode-execute FSM controlling instruction sequencing
- An integrated ALU (combinational logic module)
- An integrated RAM module (16 x 4-bit memory) for LOAD/STORE operations
- A seven-segment display driver module (ssd), included for future physical hardware deployment (see Future Work)

## Architecture
- CPU: Top-level FSM: fetch, decode, execute cycle; instantiates ALU and RAM
- ALU: Combinational 4-bit ALU supporting 11 operations, selected via opcode
- RAM: 16x4-bit memory with synchronous write, combinational read
- SSD: Decodes a 4-bit value into dual seven-segment display outputs

## Instruction/Opcodes
```
+--------+-----------+
| OPCODE | OPERATION |
+--------+-----------+
|  0000  |    ADD    |
|  0001  |    SUB    |
|  0010  |    AND    |
|  0011  |    OR     |
|  0100  |    XOR    |
|  0101  |    NOT    |
|  0110  |    NAND   |
|  0111  |    NOR    |
|  1000  |  LSHIFT   |
|  1001  |  RSHIFT   |
|  1010  |    INC    |
|  1011  |    MOV    |
|  1100  |    JMP    |
|  1101  |   HALT    |
|  1110  |   LOAD    |
|  1111  |   STORE   |
+--------+-----------+
```

## Verification
The CPU was verified using a shared testbench (testbench/testbench.sv) across two separate design variants, each preloading a different instruction program:
1. ALU Coverage Test (src/cpu_alu_test.sv) — loads all 11 ALU operations plus HALT into instruction memory, verifying every ALU opcode executes and writes back the correct result.
2. Fibonacci Sequence Program (src/cpu_fibonacci.sv) — a 9-instruction program using LOAD (seed values from RAM), ADD, MOV (register shifting), JMP (looping), STORE (writing the final result back to RAM), and HALT — verifying control flow, looping, and memory read/write behavior together.
Together, these two programs exercise all 16 opcodes.
The testbench automatically decodes each instruction into a readable mnemonic (e.g. ADD, JMP, LOAD) and logs the destination register, source register values, and result for every instruction executed, printed in a formatted table at the end of simulation. Sample output and waveform captures for both runs are included in docs/ and waveforms/.

## How to Run
1. Compile either src/cpu_alu_test.sv or src/cpu_fibonacci.sv (they differ only in preloaded instruction memory) along with testbench/testbench.sv in your SystemVerilog simulator (e.g. Icarus Verilog, ModelSim, Vivado Simulator)
2. Run the simulation — output is printed via $display in two tables: instruction stream, then per-instruction results
3. Waveforms are viewable in waveforms/ (captured via GTKWave)

## Future Work
- Porting the design to a Zynq-7000 FPGA board for real hardware execution, using the existing seven-segment display module for physical output
