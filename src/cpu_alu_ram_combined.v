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
    input logic reset,
    
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
  
  always_ff @(posedge write_enable) begin
    memory[address] <= data_in;
  end
  
  assign data_out = memory[address];
endmodule


module cpu
  (
    input logic clk,
    input logic reset,
    
    output logic [3:0] cpu_result,   
    
    
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
  logic [15:0] instructions [0:7]; //Each instruction will follow the format of opcode, destination reg, reg1, reg2
  logic [15:0] instr;
  logic [3:0] regs [0:15]; //16 pieces of 4 bit memory
  logic [3:0] opcode, op_reg1, op_reg2, op_dest; //Instruction sections
  logic [3:0] alu_out;
  logic [3:0] reg1, reg2; //Information from reg1 and reg2
  logic [3:0] ram_out;
  logic [3:0] jmp_counter;
    
  logic write_enable
  
  //Instantiate the alu module
  
  alu alu_cpu(
    .data1(reg1),
    .data2(reg2),
    .select(opcode),
    
    .result(alu_out)
  );
  
  //Instantiate the ram module
  
  ram ram_cpu(
    .clk(clk),
    .reset(reset),
    
    .write_enable(write_enable),
    .data_in(reg1),
    .address(op_reg2),
    
    .data_out(ram_out)
  );
  
  initial begin
    
    //Randomly generated instructions
    instructions[0] = 16'b1110_0000_0000_0010; //LOAD (first number 0)
    instructions[1] = 16'b1110_0001_0000_0011; //LOAD (second number 1)
    instructions[2] = 16'b1110_0111_0000_1111; //LOAD (loop count 3)
    instructions[3] = 16'b0000_0010_0000_0001; //ADD (add r1 and r2)
    instructions[4] = 16'b1011_0000_0001_0000; //MOV (replace useless)
    instructions[5] = 16'b1011_0001_0010_0000; //MOV (replace vacant)
    instructions[6] = 16'b1100_0011_1100_0000; //JMP to pc2 3 times
    instructions[7] = 16'b1101_0101_1001_0111; //HALT
    
    //Randomly generated starting memory
    regs[0]  = 4'b0000;
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
            state <= 2'b00;
            case (opcode)
              //Overwrite
              4'b1011: begin
                regs[op_dest] <= reg1;
                step_result <= reg1;
              end
              //Jump
              4'b1100: begin
                //Use op_dest for pc# to jump to
                //Use op_reg1 and reg1 for info on how many times to jump
                
                if (reg1 > jmp_counter) begin
                  jmp_counter <= jmp_counter + 1;
                  pc <= op_dest;
                  
                end else begin
                  jmp_counter <= '0;
                end
                
                step_result <= 4'b0000;
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
              end
              //Store into memory
              4'b1111: begin
                cpu_result <= reg1; //Output register information to bench
                write_enable = 1'b1; //Store to ram
                step_result <= reg1;
              end
              default: begin 
                regs[op_dest] <= alu_out; //Write calculation to register
                step_result <= alu_out;
              end 
            endcase
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
