module FPGA (
	clk,
	reset,
    anode,
    catode
);
	input wire clk;
	input wire reset;
    output wire[3:0] anode;
    output wire[7:0] catode;
	
    wire [31:0] WriteData;
	wire [31:0] Adr;
	wire MemWrite;
    wire [31:0] RegMonitored;
    wire scl_clk;
    wire display_clk;
    
    assign reset_n = ~reset;

    clkdivider #(30000000) sc(
        .clk(clk),
        .reset(reset),
        .t(scl_clk)
    );

    clkdivider #(10000) display_div(
        .clk(clk),
        .reset(reset),
        .t(display_clk)
    );

	top top(
		.clk(scl_clk),
		.reset(reset),
		.WriteData(WriteData),
		.Adr(Adr),
		.MemWrite(MemWrite),
		.RegMonitored(RegMonitored)
	);

    hexdisplay hexdisp(
		.clk(display_clk),
		.reset(reset),
		.data(RegMonitored[15:0]),
		.anode(anode),
		.catode(catode)
	);
endmodule