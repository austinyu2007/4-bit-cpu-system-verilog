`timescale 1ns/1ps

module alu
  (
    input logic [3:0] data1, //First input
    input logic [3:0] data2, //Second input
    input logic [3:0] select, //Operation
    
    output logic [3:0] result //Output result
  );
  
  always_comb begin
    case (select)
      4'b0000: result = data1 + data2; //Addition
      4'b0001: result = data1 - data2; //Subtraction
      4'b0010: result = data1 & data2; //Bitwise AND
      4'b0011: result = data1 | data2; //Bitwise OR
      4'b0100: result = data1 ^ data2; //Bitwise XOR
      4'b0101: result = ~data1; //Bitwise NOT
      4'b0110: result = ~(data1 & data2); //Bitwise NAND
      4'b0111: result = ~(data1 | data2); //Bitwise NOR
      4'b1000: result = data1 << 1; //Leftshift 1
      4'b1001: result = data1 >> 1; //Rightshift 1
      4'b1010: result = data1 + 1; //Increment 1
      
      default: result = 4'b0; //Default 0
    endcase
  end
endmodule


module ram
  (
    input logic clk,
    
    input logic write_enable,
    input logic [3:0] data_in,
    input logic [3:0] address,
    
    output logic [3:0] data_out
  );
  logic [3:0] memory [0:15];  
  
  initial begin
    memory[0]  = 4'b0100;
    memory[1]  = 4'b1001;
    memory[2]  = 4'b0000;
    memory[3]  = 4'b0001;
    memory[4]  = 4'b1000;
    memory[5]  = 4'b0001;
    memory[6]  = 4'b1100;
    memory[7]  = 4'b0111;
    memory[8]  = 4'b0000;
    memory[9]  = 4'b0001;
    memory[10] = 4'b0100;
    memory[11] = 4'b1001;
    memory[12] = 4'b0110;
    memory[13] = 4'b1101;
    memory[14] = 4'b0000;
    memory[15] = 4'b0011;
  end
  
  always_ff @(posedge clk) begin
    if (write_enable) begin
      memory[address] <= data_in;
    end
  end
  
  assign data_out = memory[address];
endmodule

//This module consists of two seven segment displays and their decoders
module two_seven_segments
  (
    input logic [3:0] alu_result,
  
    // First seven-segment display (for ones)
    output logic seg0_a,
    output logic seg0_b,
    output logic seg0_c,
    output logic seg0_d,
    output logic seg0_e,
    output logic seg0_f,
    output logic seg0_g,

    // Second seven-segment display (for tens)
    output logic seg1_a,
    output logic seg1_b,
    output logic seg1_c,
    output logic seg1_d,
    output logic seg1_e,
    output logic seg1_f,
    output logic seg1_g
);
  
  logic [3:0] tens;
  logic [3:0] ones;
  
  always_comb begin
    tens = alu_result / 10;
    ones = alu_result % 10;
    
    case (tens)
      4'b0000: begin seg1_a = 1; seg1_b = 1; seg1_c = 1; seg1_d = 1; seg1_e = 1; seg1_f = 1; seg1_g = 0; end //0
      4'b0001: begin seg1_a = 0; seg1_b = 1; seg1_c = 1; seg1_d = 0; seg1_e = 0; seg1_f = 0; seg1_g = 0; end //1
      4'b0010: begin seg1_a = 1; seg1_b = 1; seg1_c = 0; seg1_d = 1; seg1_e = 1; seg1_f = 0; seg1_g = 1; end //2
      4'b0011: begin seg1_a = 1; seg1_b = 1; seg1_c = 1; seg1_d = 1; seg1_e = 0; seg1_f = 0; seg1_g = 1; end //3
      4'b0100: begin seg1_a = 0; seg1_b = 1; seg1_c = 0; seg1_d = 0; seg1_e = 1; seg1_f = 1; seg1_g = 1; end //4
      4'b0101: begin seg1_a = 1; seg1_b = 0; seg1_c = 1; seg1_d = 1; seg1_e = 0; seg1_f = 1; seg1_g = 1; end //5
      4'b0110: begin seg1_a = 1; seg1_b = 0; seg1_c = 1; seg1_d = 1; seg1_e = 1; seg1_f = 1; seg1_g = 1; end //6
      4'b0111: begin seg1_a = 1; seg1_b = 1; seg1_c = 1; seg1_d = 1; seg1_e = 0; seg1_f = 0; seg1_g = 0; end //7
      4'b1000: begin seg1_a = 1; seg1_b = 1; seg1_c = 1; seg1_d = 1; seg1_e = 1; seg1_f = 1; seg1_g = 1; end //8
      4'b1001: begin seg1_a = 1; seg1_b = 1; seg1_c = 1; seg1_d = 1; seg1_e = 0; seg1_f = 1; seg1_g = 1; end //9
    endcase
      
    case (ones)
      4'b0000: begin seg0_a = 1; seg0_b = 1; seg0_c = 1; seg0_d = 1; seg0_e = 1; seg0_f = 1; seg0_g = 0; end //0
      4'b0001: begin seg0_a = 0; seg0_b = 1; seg0_c = 1; seg0_d = 0; seg0_e = 0; seg0_f = 0; seg0_g = 0; end //1
      4'b0010: begin seg0_a = 1; seg0_b = 1; seg0_c = 0; seg0_d = 1; seg0_e = 1; seg0_f = 0; seg0_g = 1; end //2
      4'b0011: begin seg0_a = 1; seg0_b = 1; seg0_c = 1; seg0_d = 1; seg0_e = 0; seg0_f = 0; seg0_g = 1; end //3
      4'b0100: begin seg0_a = 0; seg0_b = 1; seg0_c = 0; seg0_d = 0; seg0_e = 1; seg0_f = 1; seg0_g = 1; end //4
      4'b0101: begin seg0_a = 1; seg0_b = 0; seg0_c = 1; seg0_d = 1; seg0_e = 0; seg0_f = 1; seg0_g = 1; end //5
      4'b0110: begin seg0_a = 1; seg0_b = 0; seg0_c = 1; seg0_d = 1; seg0_e = 1; seg0_f = 1; seg0_g = 1; end //6
      4'b0111: begin seg0_a = 1; seg0_b = 1; seg0_c = 1; seg0_d = 1; seg0_e = 0; seg0_f = 0; seg0_g = 0; end //7
      4'b1000: begin seg0_a = 1; seg0_b = 1; seg0_c = 1; seg0_d = 1; seg0_e = 1; seg0_f = 1; seg0_g = 1; end //8
      4'b1001: begin seg0_a = 1; seg0_b = 1; seg0_c = 1; seg0_d = 1; seg0_e = 0; seg0_f = 1; seg0_g = 1; end //9
    endcase
  end
  
endmodule


module cpu
  (
    input logic clk,
    input logic reset,
    
    output logic [3:0] cpu_result, //For writing to RAM
    
    
    //The following outputs are simply for testbench purposes
    output logic [15:0] instruction_test, //Instruction in this iteration
    output logic [3:0] step_result, //Result of the operation given by the instructions in this cycle
    
    output logic [3:0] reg1_info,
    output logic [3:0] reg2_info,
    output logic [1:0] state_out,
    output logic [7:0] pc_out
  );
  
  logic halt;
  logic [7:0] pc; //Program counter
  logic [1:0] state;
  logic [15:0] instructions [0:15]; //Each of the 16 instruction will follow the format of opcode, destination reg, reg1, reg2. Note that for the purposes of this demo, only 9 instructions will be used.
  logic [15:0] instr;
  logic [3:0] regs [0:15]; //16 pieces of 4 bit memory
  logic [3:0] opcode, op_reg1, op_reg2, op_dest; //Instruction sections
  logic [3:0] alu_out;
  logic [3:0] reg1, reg2; //Information from reg1 and reg2
  logic [3:0] ram_out; //data from the ram into the CPU
  logic [3:0] jmp_counter; //how many times loop has jumped
  logic [3:0] seven_segment_display_value; //note that only alu values will be displayed on SSD
  
  
  logic write_enable; //If the CPU can write data to the RAM
  
  //Instantiate the ALU module
  
  alu alu_cpu(
    .data1(reg1),
    .data2(reg2),
    .select(opcode),
    
    .result(alu_out)
  );
  
  //Instantiate the RAM module
  
  ram ram_cpu(
    .clk(clk),
    
    .write_enable(write_enable),
    .data_in(reg1),
    .address(op_reg2),
    
    .data_out(ram_out)
  );
  
  two_seven_segments ssd(
    .alu_result(seven_segment_display_value)
  );
  
  initial begin
    
    instructions[0] = 16'b0000_1111_0000_0001; //ADD R0 AND R1
    instructions[1] = 16'b0001_1111_0000_0001; //SUB R0 FROM R1
    instructions[2] = 16'b0010_1111_0000_0001; //R0 & R1
    instructions[3] = 16'b0011_1111_0000_0001; //R0 | R1
    instructions[4] = 16'b0100_1111_0000_0001; //R0 ^ R1
    instructions[5] = 16'b0101_1111_0000_0001; //~R0
    instructions[6] = 16'b0110_1111_0000_0001; //~(R0 & R1)
    instructions[7] = 16'b0111_1111_0000_0001; //~(R0 | R1)
    instructions[8] = 16'b1000_1111_0000_0001; //LEFTSHIFT R0
    instructions[9] = 16'b1001_1111_0000_0001; //RIGHTSHIFT R0
    instructions[10] = 16'b1010_1111_0000_0001; //INC R0
    instructions[11] = 16'b1101_1111_0000_0001; //HALT
    
    //Randomly generated starting memory, note that most of these registers are currently useless because there aren't enough instructions for them
    regs[0]  = 4'b1010;
    regs[1]  = 4'b0001;
    regs[2]  = 4'b0010;
    regs[3]  = 4'b0011;
    regs[4]  = 4'b0100;
    regs[5]  = 4'b0101;
    regs[6]  = 4'b0110;
    regs[7]  = 4'b0111;
    regs[8]  = 4'b1000;
    regs[9]  = 4'b1001;
    regs[10] = 4'b1010;
    regs[11] = 4'b1011;
    regs[12] = 4'b0100;
    regs[13] = 4'b1101;
    regs[14] = 4'b1110;
    regs[15] = 4'b0110;
  end
    
  
  always_ff @(posedge clk or posedge reset) begin
    
    //If the CPU needs to reset
        
    if (reset) begin
      pc 			<= '0;
      state 		<= '0;
      instr			<= '0;
      opcode 		<= '0;
      op_reg1		<= '0;
      op_reg2		<= '0;
      op_dest		<= '0;
      cpu_result 	<= '0;
      reg1			<= '0;
      reg2			<= '0;
      halt			<= '0;
      write_enable 	<= '0;
      jmp_counter	<= '0;
    end
    //END RESET PROCEDURE
    
    //If clk is positive
    else if (halt == 0) begin
      case (state)
        2'b00: //FETCH
          begin
            write_enable = 1'b0;
            instr <= instructions[pc];
            pc <= pc + 1;
            pc_out <= pc;
            
            state <= 2'b01;
          end
        2'b01: //DECODE
          begin
            //Split the instructions
            opcode 	<= instr[15:12]; //Operation
            op_dest <= instr[11:8]; //Destination register
            op_reg1 <= instr[7:4]; //Data source register 1
            op_reg2 <= instr[3:0]; //Data source register 2
                        
            //Read information from source registers
            reg1 <= regs[instr[7:4]];
            reg2 <= regs[instr[3:0]];
                                                
            state <= 2'b10;
          end
        2'b10: //EXECUTE
          begin
            case (opcode)
              //Move
              4'b1011: begin
                regs[op_dest] <= reg1; //Replace the destination register info with register 1 info
                step_result <= reg1;
                
                state <= 2'b00;
              end
              //Jump
              4'b1100: begin
                //Use op_dest for pc# to jump to
                //Use op_reg1 and reg1 for info on how many times to jump
                
                if (reg1 >= jmp_counter) begin
                  jmp_counter <= jmp_counter + 1;
                  pc <= op_dest;
                  
                end else begin
                  jmp_counter <= '0;
                end
                
                step_result <= 4'b0000;
                
                state <= 2'b00;
              end
              //Halt
              4'b1101: begin
                step_result <= 4'b0000;
                
                halt <= 1'b1;
              end
              //Load from memory
              4'b1110: begin
                regs[op_dest] <= ram_out;
                step_result <= ram_out;
                
                state <= 2'b00;
              end
              //Store into memory
              4'b1111: begin
                cpu_result <= reg1; //Output write information to bench
                write_enable <= 1'b1; //Store to ram
                step_result <= reg1;
                
                state <= 2'b11; //Store state
              end
              default: begin 
                regs[op_dest] <= alu_out; //Write calculation to register
                step_result <= alu_out;
                seven_segment_display_value <= alu_out;
                
                state <= 2'b00;
              end 
            endcase
          end
        //Store state. will not always be used. 
        2'b11: begin
          state <= 2'b00;
          
          //gives the CPU a cycle to store the data
        end
      endcase
      
      state_out <= state;
      //The following assignments are for the test bench
      
      instruction_test <= instr;
      reg1_info <= reg1;
      reg2_info <= reg2;
    end
  end
endmodule
