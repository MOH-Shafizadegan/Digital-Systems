`timescale 1ns/1ns
module booth_Multiplier(
//-----------------------Port directions and deceleration
   input clk,  
   input start,
   input [7:0] A, 
   input [7:0] B, 
   output reg [15:0] Product,
   output ready,
   output reg [15:0] adder_output
    );



//------------------------------------------------------

//----------------------------------- register deceleration
reg [15:0] Multiplicand ;
reg [9:0]  Multiplier;
reg [3:0]  counter;
//-------------------------------------------------------

//-------------------------------------- combinational logic
assign ready = counter === 4'h5;
always @ ( * ) begin
	
	case(Multiplier[2:0])
		3'b000 : adder_output = 16'h0000 + Product;
		3'b001 : adder_output =  Multiplicand + Product;
		3'b010 : adder_output =  Multiplicand + Product;
		3'b011 : adder_output =  Multiplicand << 1 + Product;
		3'b100 : adder_output = ~(Multiplicand << 1) + Product + 16'b0001;
		3'b101 : adder_output = ~(Multiplicand << 1) + Product + 16'b0001;
		3'b110 : adder_output = ~Multiplicand + Product + 16'b0001;
		default : adder_output = Product;
	endcase
	
end
//---------------------------------------------------------

//--------------------------------------- sequential Logic
always @ (posedge clk)

   if(start) begin
      counter <= 4'h0 ;
      Multiplier <= {1'b0, B, 1'b0};
      Product <= 16'h0000;
      Multiplicand <= {8'h0000, A} ;
   end

   else if(! ready) begin
         counter <= counter + 1;
         Multiplicand <= Multiplicand << 2;
         Multiplier <= Multiplier >> 2;
         Product <= adder_output;
   end   

endmodule