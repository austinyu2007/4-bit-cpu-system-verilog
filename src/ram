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
