
# 4-bit-cpu-systemverilog

A 4-bit CPU built from scratch with a custom ISA, FSM-based Fetch-Decode-Execute cycle, and external RAM module. Programmed to calculate the Fibonacci sequence as a demonstration of full CPU functionality including branching, memory operations, and arithmetic.

All code is in the src folder, and the testbench output for my example Fibonacci sequece program is given in result.txt
## Features

- Custom 16-operation ISA with arithmetic, logic, LOAD/STORE, MOV, and JMP branching
- FSM-based Fetch-Decode-Execute cycle
- Integrated ALU, control logic, registers, and external RAM
- Fibonacci sequence program
- Testbench with waveform analysis and step-by-step execution tables
## Project Structure
/src        — SystemVerilog source files
/testbench  — Testbench
/docs       — Waveforms and execution table outputs

## Screenshots
Here is the waveform for several important signals in the CPU.

![Waveform](https://github.com/austinyu2007/4-bit-cpu-system-verilog/blob/main/docs/waveform.png?raw=true)

Note that the output tables are inside the docs folder. It lists important step-by-step data such as command, results, and register info.

## Tools Used
- Icarus Verilog
- GTKWave for waveform
