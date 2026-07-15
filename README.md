# 4-bit-cpu-systemverilog

A custom 4-bit CPU implemented in SystemVerilog with a 16-opcode instruction set, FSM Fetch-Decode-Execute_store cycle, and integrated ALU/RAM/Seven Segment Display modules. Painstakingly built from the ground up.

## Tools Used
- Icarus Verilog
- GTKWave for waveform

## Overview
This project implements a programmable CPU architecture from scratch, including:

- A 16-opcode ISA: 11 ALU operations (ADD, SUB, AND, OR, XOR, NOT, NAND, NOR, left-shift, right-shift, INC) plus 5 control/memory instructions (MOV, JMP, LOAD, STORE, HALT)
- A fetch-decode-execute FSM controlling instruction sequencing
- An integrated ALU
- An integrated RAM module (16 x 4-bit memory) for LOAD/STORE operations (note that this much memory is quite overkill for the small programs that I wrote)
- A seven-segment display driver module (ssd), included for future physical hardware deployment (see Future Work)

## Architecture
- CPU: FSM for fetch-decode-execute-store cycle; includes pc and instruction memory; instantiates ALU and RAM
- ALU: Combinational 4-bit ALU supporting 11 operations, selected via opcode from the CPU
- RAM: 16x4-bit memory with synchronous write, combinational read
- SSD: Decodes a 4-bit value into two seven-segment display outputs (one for tens place and one for ones place)

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
The CPU was verified using a shared testbench (testbench/testbench.sv) across two separate different designs. Most of the design was similar, with the exception of the program/instruction memory to test operations:
1. ALU Coverage Test (src/cpu_alu_test.sv) — loads all 11 ALU operations plus HALT into instruction memory. Verifies ALU and Halt instructions.
2. Fibonacci Sequence Program (src/cpu_fibonacci.sv) — a 9-instruction program using LOAD (seed values from RAM), ADD, MOV (register shifting), JMP (looping), STORE (writing the final result back to RAM), and HALT. Verifies memory instructions and shows that the CPU can run somewhat complicated programs.

Together, these two programs use (and verify) all 16 opcodes.
The testbench automatically decodes each instruction into English (e.g. ADD, JMP, LOAD) and logs the destination register, source register values, and result for every instruction executed, printed in a formatted table at the end of simulation. Sample output and waveform captures for both runs are included in docs/ and waveforms/.

## How to Run
1. Compile either src/cpu_alu_test.sv or src/cpu_fibonacci.sv (they differ only in instruction register) along with testbench/testbench.sv in SystemVerilog simulation
2. Run the simulation
3. View results. Waveforms are viewable in waveforms/ (captured via GTKWave). The output also gives two separate tables as specified in Veriication. Also viewable in docs/.

## Future Work
- Porting the design to a Zynq-7000 FPGA board for real hardware execution, using the existing seven-segment display module for physical output
