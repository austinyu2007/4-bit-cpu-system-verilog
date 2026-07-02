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
