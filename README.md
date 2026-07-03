
# 4-bit-cpu-systemverilog

A personal project.

4-bit CPU with ALU, outside RAM, testbench, and custom ISA. CPU uses Fetch-Decode-Execute cycle. This project has preset memory into the CPU and programmed the instructions to iterate through the Fibonacci sequence three times, but the instructions and memory can be fully altered.

All code is in the src folder, and the testbench output for my example Fibonacci sequece program is given in result.txt
## Features

- 4 bit custom ISA
- Fetch-Decode-Execute cycle using FSM
- ALU, LOAD/STORE, MOV, and JMP capabilities
- Hardcoded program in CPU calculates the Fibonacci sequence
- Comprehenshive testbench, waveforms, and output data for debugging


## Screenshots
Here is the waveform for several important signals in the CPU.

[Waveform] (docs/waveform.png)
