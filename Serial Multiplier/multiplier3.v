`timescale 1ns/1ns
module multiplier3(
//----------	Port directions and deceleration	----------
   input clk,
   input start,
   input [7:0] A, 
   input [7:0] B, 
   output reg [15:0] Product,
   output ready
    );

//----------------    register deceleration    ---------------
reg [7:0] Multiplicand ;
reg [3:0]  counter;
reg check;

//----------------    wire deceleration    ---------------
assign ready = counter === 4'h8;

//----------------    combinational logic    -----------------
reg [8:0] adder_output;

always @( * ) begin
   
   if (check && counter === 4'h7) begin
      if (Product[0])
         adder_output = ~{Multiplicand[7],Multiplicand} + 9'h001 + {Product[15], Product[15:8]};
      else
         adder_output = 9'h000 + {Product[15], Product[15:8]};
   end

   else begin
      if (Product[0])
         adder_output = {Multiplicand[7],Multiplicand} + {Product[15], Product[15:8]};
      else
         adder_output = 9'h000 + {Product[15], Product[15:8]};
   end
end

always @ ( * ) begin
   if (check && counter === 4'h8) begin
            Product = Product +1;
   end
end

//----------------    sequential logic    --------------------
always @ (posedge clk)

   if(start) begin
      counter <= 4'h0 ;
      Product <= {{8{B[7]}}, B};
      Multiplicand <= A ;
      check <= B[7];
   end

   else if(!ready) begin
         counter <= counter + 1;
         Product <= {adder_output, Product[7:1]};
   end 

endmodule
