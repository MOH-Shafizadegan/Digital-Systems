`timescale 1ns/1ns
module multiplier3_nb
   #(
		parameter nb = 8
	)
   (
//----------	Port directions and deceleration	----------
   input clk,
   input start,
   input [nb-1:0] A, 
   input [nb-1:0] B, 
   output reg [2*nb-1:0] Product,
   output ready,
   output reg [nb:0] adder_output
    );

//----------------    register deceleration    ---------------
reg [nb-1:0] Multiplicand ;
reg [6:0]  counter;
reg check;

//----------------    wire deceleration    ---------------
assign ready = counter === nb;

//----------------    combinational logic    -----------------
always @( * ) begin
   
   if (check && counter === nb-1) begin
      if (Product[0])
         adder_output = ~{Multiplicand[nb-1],Multiplicand} + 1 + {Product[2*nb-1], Product[2*nb-1:nb]};
      else
         adder_output = 0 + {Product[2*nb-1], Product[2*nb-1:nb]};
   end

   else begin
      if (Product[0])
         adder_output = {Multiplicand[nb-1],Multiplicand} + {Product[2*nb-1], Product[2*nb-1:nb]};
      else
         adder_output = 0 + {Product[2*nb-1], Product[2*nb-1:nb]};
   end
end

always @ ( * ) begin
   if (check && ready) begin
            Product = Product +1;
   end
end

//----------------    sequential logic    --------------------
always @ (posedge clk)

   if(start) begin
      counter <= 6'h00 ;
      Product <= {{nb{B[nb-1]}}, B};
      Multiplicand <= A ;
      check <= B[nb-1];
   end

   else if(!ready) begin
         counter <= counter + 1;
         Product <= {adder_output, Product[nb-1:1]};
   end 

endmodule
