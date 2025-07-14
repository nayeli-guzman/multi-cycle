`timescale 1ns / 1ps

module testbench;
	reg clk;
	reg reset;
	wire [31:0] WriteData;
	wire [31:0] Adr;
	wire MemWrite;
	wire [3:0] anode;
	wire [7:0] catode;

	//top dut(
		//.clk(clk),
		//.reset(reset),
		//.WriteData(WriteData),
		//.Adr(Adr),
		//.MemWrite(MemWrite)
	//);
	//testbench para simulation
	
	FPGA dut_fpga(
	    .clk(clk),
	    .reset(reset),
	    .anode(anode),
	    .catode(catode)
	);
	//testbench para implementation
	
  initial begin
		reset <= 1;
		#(5);
		reset <= 0;
	end
	always begin
		clk <= 1;
		#(5);
		clk <= 0;
		#(5);
	end
endmodule
