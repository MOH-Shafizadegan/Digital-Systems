`timescale 1ns/1ns

module booth_Multiplier_tb();

   parameter no_of_tests = 2;

//------------------generating clock signal in 100MHz
   reg clk = 1'b1;
   always @(clk)
      clk <= #5 ~clk;
//-----------------------------------------------------
 
//-------------------------------------- reg declaration 
   reg start;
   reg [  7:0] A, B, C, D;
   reg [15:0] expected_product;
//----------------------------------------------------------    
   integer i, j, err = 0;
   
   initial begin
      start = 0;

      @(posedge clk);
      @(posedge clk);
      @(posedge clk);
      #1;
//------------------------------------------repeat the test no_of_tests times with different random numbers
      for(i=0; i<no_of_tests; i=i+1) begin

         A = $random();    
         B = $random();
         expected_product = A * B;
         C = A;
         D = B;
      //----------------------------------generating start signal -------------------------------------------------------------     
         start = 1;
         @(posedge clk);
         #1;
         start = 0;
         A = 'bx; //When start became "1" we register A & B and their changes is not important after start became "0"
         B = 'bx; //When start became "1" we register A & B and their changes is not important after start became "0"
      //----------------------------------------------------------------------------------------------------------------------
         
      //-----------------------------------wait until multiplication become complete
         for(j=0; j<=4; j=j+1) begin        
            @(posedge clk);
            $write  ("%d : adder : %x product : %X \n", j, uut.adder_output, uut.Product);
         end
         @(posedge clk);
      //------------------------------------------------------------------------------

         $write   ("%x (%0d) x %x (%0d) = %x (%0d) ", {C}, {C}, {D}, {D}, uut.Product, uut.Product);

         if (expected_product === uut.Product)
            $display(", OK");
         else 
            $display (", ERROR: expected %x, got %x", expected_product, uut.Product); 

      end

      $stop;
   end


    booth_Multiplier uut (        // unsigned unit
        .clk(clk),
        .start(start),
        .A(A),
        .B(B),
        .Product(),
      .ready(),
      .adder_output()
    );


endmodule