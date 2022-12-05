`timescale 1ns/1ns
module multiplier1(
//-----------------------Port directions and deceleration
   input clk,  
   input start,
   input [7:0] A, 
   input [7:0] B, 
   output reg [15:0] Product,
   output ready
    );



//------------------------------------------------------

//----------------------------------- register deceleration
reg [15:0] Multiplicand ;
reg [7:0]  Multiplier;
reg [3:0]  counter;
//-------------------------------------------------------

//------------------------------------- wire deceleration
wire product_write_enable;
wire [15:0] adder_output;
//---------------------------------------------------------

//-------------------------------------- combinational logic
assign adder_output = Multiplicand + Product;
assign product_write_enable = Multiplier[0];
assign ready = counter[3];
//---------------------------------------------------------

//--------------------------------------- sequential Logic
always @ (posedge clk)

   if(start) begin
      counter <= 4'h0 ;
      Multiplier <= B;
      Product <= 16'h0000;
      Multiplicand <= {8'h00, A} ;
   end

   else if(! ready) begin
         counter <= counter + 1;
         Multiplier <= Multiplier >> 1;
         Multiplicand <= Multiplicand << 1;

      if(product_write_enable)
         Product <= adder_output;
   end   

endmodule
