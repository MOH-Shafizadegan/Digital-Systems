`timescale 1ns/1ns
module multiplier2(
//----------	Port directions and deceleration	----------
   input clk,
   input start,
   input [7:0] A,
   input [7:0] B, 
   output reg [15:0] Product,
   output ready
    );

//----------------    register deceleration    ---------------
reg [3:0] counter;
reg [7:0] Multiplicand;

//----------------	  wire deceleration    -------------------
wire [8:0] adder_output;

//----------------    combinational logic    -----------------
assign adder_output = (Product[0] ? Multiplicand : 8'h00) + Product[15:8];
assign ready = counter[3];

//----------------    sequential logic    --------------------
always @ (posedge clk)

   if(start) begin
      counter <= 4'h0 ;
      Product <= {8'h00, B};
      Multiplicand <= A ;  
   end

   else if(! ready) begin
         counter <= counter + 1;
         Product <= {adder_output, Product[7:1]};
   end   

endmodule
