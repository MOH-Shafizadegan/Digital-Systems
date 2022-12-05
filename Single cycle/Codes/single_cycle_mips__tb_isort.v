`timescale 1ns/1ns

`define	READ_FROM_FILE		// comment this line if you have problem reading from files 

module single_cycle_mips__tb_isort;

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
	
	reg [ 8:0] err_exp = 0;
	reg [ 8:0] err_unsorted = 0;
	reg [31:0] exp_sorted_num [0:95];
	
	initial begin
		`ifdef READ_FROM_FILE
			$readmemh("isort32.hex", cpu.imem.mem_data);
		`else	// for those whom still has problem reading from file
			cpu.imem.mem_data[ 0]	= 32'h34080000;
			cpu.imem.mem_data[ 1]	= 32'h24090060;
			cpu.imem.mem_data[ 2]	= 32'h3403DEAD;
			cpu.imem.mem_data[ 3]	= 32'hAD030080;
			cpu.imem.mem_data[ 4]	= 32'h2129FFFF;
			cpu.imem.mem_data[ 5]	= 32'h25080004;
			cpu.imem.mem_data[ 6]	= 32'h00631020;
			cpu.imem.mem_data[ 7]	= 32'h00621026;
			cpu.imem.mem_data[ 8]	= 32'h3843BEEF;
			cpu.imem.mem_data[ 9]	= 32'h1409FFF9;
			cpu.imem.mem_data[10]	= 32'h20080004;
			cpu.imem.mem_data[11]	= 32'h20090060;
			cpu.imem.mem_data[12]	= 32'h01294821;
			cpu.imem.mem_data[13]	= 32'h01294821;
			cpu.imem.mem_data[14]	= 32'h0109502A;
			cpu.imem.mem_data[15]	= 32'h1140000E;
			cpu.imem.mem_data[16]	= 32'h00085820;
			cpu.imem.mem_data[17]	= 32'h8D0C0080;
			cpu.imem.mem_data[18]	= 32'h000B502A;
			cpu.imem.mem_data[19]	= 32'h11400007;
			cpu.imem.mem_data[20]	= 32'h216DFFFC;
			cpu.imem.mem_data[21]	= 32'h8DAE0080;
			cpu.imem.mem_data[22]	= 32'h01CC502B;
			cpu.imem.mem_data[23]	= 32'h11400003;
			cpu.imem.mem_data[24]	= 32'hAD6E0080;
			cpu.imem.mem_data[25]	= 32'h000D5820;
			cpu.imem.mem_data[26]	= 32'h1000FFF7;
			cpu.imem.mem_data[27]	= 32'hAD6C0080;
			cpu.imem.mem_data[28]	= 32'h21080004;
			cpu.imem.mem_data[29]	= 32'h1000FFF0;
			cpu.imem.mem_data[30]	= 32'h1000FFFF;
		`endif
	end
	
	initial begin
		`ifdef READ_FROM_FILE
			$readmemh("exp_sorted_numbers.hex", exp_sorted_num);
		`else
			exp_sorted_num[ 0]	= 32'hffff8a4f;
			exp_sorted_num[ 1]	= 32'hff49a03e;
			exp_sorted_num[ 2]	= 32'hed9232cf;
			exp_sorted_num[ 3]	= 32'hed9232cf;
			exp_sorted_num[ 4]	= 32'hec6c3298;
			exp_sorted_num[ 5]	= 32'hec6c3298;
			exp_sorted_num[ 6]	= 32'he6663185;
			exp_sorted_num[ 7]	= 32'he6663185;
			exp_sorted_num[ 8]	= 32'hdddd8526;
			exp_sorted_num[ 9]	= 32'hdbdb842d;
			exp_sorted_num[10]	= 32'hb6b6e9be;
			exp_sorted_num[11]	= 32'hb4b4e947;
			exp_sorted_num[12]	= 32'haac70a4f;
			exp_sorted_num[13]	= 32'haaaaec60;
			exp_sorted_num[14]	= 32'ha48e7be0;
			exp_sorted_num[15]	= 32'ha48e7be0;
			exp_sorted_num[16]	= 32'h9c7a4305;
			exp_sorted_num[17]	= 32'h9c7a4305;
			exp_sorted_num[18]	= 32'h99bd6c60;
			exp_sorted_num[19]	= 32'h8bd654a6;
			exp_sorted_num[20]	= 32'h8bd654a6;
			exp_sorted_num[21]	= 32'h8894b185;
			exp_sorted_num[22]	= 32'h878c0526;
			exp_sorted_num[23]	= 32'h86b259c7;
			exp_sorted_num[24]	= 32'h86b259c7;
			exp_sorted_num[25]	= 32'h82846947;
			exp_sorted_num[26]	= 32'h826e5d18;
			exp_sorted_num[27]	= 32'h826e5d18;
			exp_sorted_num[28]	= 32'h81da5ead;
			exp_sorted_num[29]	= 32'h81da5ead;
			exp_sorted_num[30]	= 32'h8183b298;
			exp_sorted_num[31]	= 32'h8081042d;
			exp_sorted_num[32]	= 32'h807f69be;
			exp_sorted_num[33]	= 32'h802ab2cf;
			exp_sorted_num[34]	= 32'h8019fbe0;
			exp_sorted_num[35]	= 32'h8008c305;
			exp_sorted_num[36]	= 32'h8007d4a6;
			exp_sorted_num[37]	= 32'h8002d9c7;
			exp_sorted_num[38]	= 32'h8001dd18;
			exp_sorted_num[39]	= 32'h8000dead;
			exp_sorted_num[40]	= 32'h8000203e;
			exp_sorted_num[41]	= 32'h8000203e;
			exp_sorted_num[42]	= 32'h7fff8a4f;
			exp_sorted_num[43]	= 32'h7fff8a4f;
			exp_sorted_num[44]	= 32'h7f49a03e;
			exp_sorted_num[45]	= 32'h7f49a03e;
			exp_sorted_num[46]	= 32'h6d9232cf;
			exp_sorted_num[47]	= 32'h6c6c3298;
			exp_sorted_num[48]	= 32'h66663185;
			exp_sorted_num[49]	= 32'h5ddd8526;
			exp_sorted_num[50]	= 32'h5ddd8526;
			exp_sorted_num[51]	= 32'h5bdb842d;
			exp_sorted_num[52]	= 32'h5bdb842d;
			exp_sorted_num[53]	= 32'h36b6e9be;
			exp_sorted_num[54]	= 32'h36b6e9be;
			exp_sorted_num[55]	= 32'h34b4e947;
			exp_sorted_num[56]	= 32'h34b4e947;
			exp_sorted_num[57]	= 32'h2ac70a4f;
			exp_sorted_num[58]	= 32'h2ac70a4f;
			exp_sorted_num[59]	= 32'h2aaaec60;
			exp_sorted_num[60]	= 32'h2aaaec60;
			exp_sorted_num[61]	= 32'h248e7be0;
			exp_sorted_num[62]	= 32'h1c7a4305;
			exp_sorted_num[63]	= 32'h19bd6c60;
			exp_sorted_num[64]	= 32'h19bd6c60;
			exp_sorted_num[65]	= 32'h0bd654a6;
			exp_sorted_num[66]	= 32'h0894b185;
			exp_sorted_num[67]	= 32'h0894b185;
			exp_sorted_num[68]	= 32'h078c0526;
			exp_sorted_num[69]	= 32'h078c0526;
			exp_sorted_num[70]	= 32'h06b259c7;
			exp_sorted_num[71]	= 32'h02846947;
			exp_sorted_num[72]	= 32'h02846947;
			exp_sorted_num[73]	= 32'h026e5d18;
			exp_sorted_num[74]	= 32'h01da5ead;
			exp_sorted_num[75]	= 32'h0183b298;
			exp_sorted_num[76]	= 32'h0183b298;
			exp_sorted_num[77]	= 32'h0081042d;
			exp_sorted_num[78]	= 32'h0081042d;
			exp_sorted_num[79]	= 32'h007f69be;
			exp_sorted_num[80]	= 32'h007f69be;
			exp_sorted_num[81]	= 32'h002ab2cf;
			exp_sorted_num[82]	= 32'h002ab2cf;
			exp_sorted_num[83]	= 32'h0019fbe0;
			exp_sorted_num[84]	= 32'h0019fbe0;
			exp_sorted_num[85]	= 32'h0008c305;
			exp_sorted_num[86]	= 32'h0008c305;
			exp_sorted_num[87]	= 32'h0007d4a6;
			exp_sorted_num[88]	= 32'h0007d4a6;
			exp_sorted_num[89]	= 32'h0002d9c7;
			exp_sorted_num[90]	= 32'h0002d9c7;
			exp_sorted_num[91]	= 32'h0001dd18;
			exp_sorted_num[92]	= 32'h0001dd18;
			exp_sorted_num[93]	= 32'h0000dead;
			exp_sorted_num[94]	= 32'h0000dead;
			exp_sorted_num[95]	= 32'h0000203e;
	`endif
	end
		
	parameter end_pc = 32'h78;		// you might need to change end_pc

	integer i;
	always @(cpu.PC)
		if(cpu.PC == end_pc) begin
			for(i=0; i<96; i=i+1) begin
				$write("%x ", cpu.dmem.mem_data[32+i]);
				if(((i+1) % 16) == 0)
					$write("\n");
			end
			for(i=0; i<96; i=i+1) begin
				if (cpu.dmem.mem_data[32+i] < cpu.dmem.mem_data[32+i+1] ||
					|cpu.dmem.mem_data[32+i] === 1'bx )
					err_unsorted = err_unsorted + 1;
				if (cpu.dmem.mem_data[32+i] !== exp_sorted_num[i])
					err_exp = err_exp + 1;
			end
			
			if (err_unsorted)
				$write("\n\n\n %d Numbers are Not Sorted!!!!!!\n", err_unsorted);
			else
				$write("\n\n\n PASS1, All Sorted!\n");
			
			if (err_exp)
				$write("\n Bad!!!!! %d unexpected Numbers found:\n\n\n", err_exp);
			else
				$write("\n Pass2, Output Matches the expected Numbers!\n\n\n");
			
			$stop;
		end

   single_cycle_mips cpu(
      .clk  ( clk   ),
      .reset( reset )
   );

endmodule

