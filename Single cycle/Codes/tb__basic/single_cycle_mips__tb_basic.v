`timescale 1ns/1ns

module single_cycle_mips__tb_basic;

   reg clk = 1;
   always @(clk) clk <= #5 ~clk;

   reg reset;
   initial begin
      reset = 1;
      @(posedge clk);
      @(posedge clk);
      @(posedge clk);
		#1;
      reset = 0;
   end

   initial
      $readmemh("basic.hex", cpu.imem.mem_data);

   parameter end_pc = 32'hA0; // CHECK THE VALUE

   integer i;

   always @(cpu.PC) begin
      if(cpu.PC == end_pc) begin
         for(i=0; i<21; i=i+1)
            $write("%x \n", cpu.dmem.mem_data[50+i]);
         $stop;
      end
   end

   single_cycle_mips cpu(
      .clk  ( clk   ),
      .reset( reset )
   );

endmodule

//==============================================================================

