`timescale 1ns/1ps

module test
  ();
  
  //Clock and reset signals
  logic clk;
  logic reset;
  
  //CPU outputs
  logic [3:0] cpu_final_result; //When CPU has Write instruction
  logic [15:0] instruction_test; //The current instruction of the CPU at this execute stage
  logic [3:0] step_test; //The current output of the CPU at end of this execute stage
  logic [3:0] reg1_info; //Information of source register 1
  logic [3:0] reg2_info; //Information of source register 2
  
  logic [3:0] command_bits; //The current opcode of CPU
  logic [3:0] destination_bits; //The current location of the destination register
  logic [3:0] data1_bits; //The current location of the source register 1
  logic [3:0] data2_bits; //The current location of the source register 2
  logic [7:0] cpu_pc; //The current program counter of the CPU
  logic [1:0] cpu_state; //The current state of the CPU
    
  string information_log[$]; //A list to hold all the information for the second output table
  string command; //The operation in readable text form
  
  //Instantiate CPU module
  cpu sub_cpu(
    .clk(clk),
    .reset(reset),
    
    .cpu_result(cpu_final_result),
    .instruction_test(instruction_test),
    .step_result(step_test),
    .reg1_info(reg1_info),
    .reg2_info(reg2_info),
    
    .state_out(cpu_state),
    .pc_out(cpu_pc)
  );
  
  
  //Create waveforms all the signals inside the CPU, including pc, outputs, clk, and more
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, sub_cpu);
    
  end
  
  //Set reset
  initial begin
    reset = '1;
    #10;
    reset = '0;
  end
    
  //Initiate clock
  initial begin
    #10; //Wait 10 ticks for the reset to subside
    clk = '0;
    forever #5 begin //Period of 10 ticks
      clk = ~clk;
    end
  end
  
  //Print the simulation's current instructions
  initial begin
    #10; //Wait 10 ticks for the reset to subside
    $display("The following test output is of the following format:");
    $display("");
    $display("OPERATOR | DESTINATION REGISTER LOCATION IN BITS | DATA1 REGISTER LOCATION IN BITS | DATA2 REGISTER LOCATION IN BITS");
  end
    
    always @(posedge clk) begin
      if (cpu_state == 2'b10) begin
        command_bits = instruction_test[15:12]; //The opcode
        //Here is the list of opcodes and their corresponding readable operation commands
          case (command_bits)
          4'b0000: command = "ADD";
          4'b0001: command = "SUB";
          4'b0010: command = "AND";
          4'b0011: command = "OR";
          4'b0100: command = "XOR";
          4'b0101: command = "NOT";
          4'b0110: command = "NAND";
          4'b0111: command = "NOR";
          4'b1000: command = "LSHIFT";
          4'b1001: command = "RSHIFT";
          4'b1010: command = "INC";
          4'b1011: command = "MOV";
          4'b1100: command = "JMP";
          4'b1101: command = "HALT";
          4'b1110: command = "LOAD";
          4'b1111: command = "WRITE";
        endcase

        //Decompose the instruction further
        destination_bits = instruction_test[11:8]; //The bit location of the destination register
        data1_bits = instruction_test[7:4]; //The bit location of the source register 1
        data2_bits = instruction_test[3:0]; //The bit location of the source register 2

        $display("%s | %b | %b | %b", command, destination_bits, data1_bits, data2_bits); //Displays the instruction information in the order as stated by the $display command

        information_log.push_back($sformatf("%s | %b | %b | %b | %b | %d", command, destination_bits, reg1_info, reg2_info, step_test, step_test));

      end
    end
  
  
  initial begin
    #800; //End simulation after 800 ticks
    $display("\n\n\n");
    $display("The following test output is of the following format:");
    $display("");
    $display("OPERATOR | DESTINATION REGISTER LOCATION IN BITS | DATA1 REGISTER INFO | DATA2 REGISTER INFO | RESULT | RESULT IN DECIMAL");
    $display("Note that non-calculating steps such as HALT and JMP have default result values of 0. The result of LOAD MOV is the data that has been transferred/moved");
    $display("");
    
    foreach (information_log[i]) begin //Go through this queue to access the second table with the result data with the information in the order as stated by the above $display command
      $display("%s", information_log[i]);
    end
    $finish; //End simulation
  end
endmodule
