module OneSecondBlink (
	input clk,    // Clock	
	output wire [7:0] PMOD2_D
);

//24 Mhz maximum

reg [26-1:0] timecounter;
reg LED;

initial begin
	LED <= 1;
end

always @(posedge clk) begin : proc_
	casez (timecounter)
		12_000_000-1: begin 
			timecounter <= 0;
			LED <= ~LED;
		end
		default : timecounter<=timecounter+1;
	endcase
end

assign PMOD2_D[0]=LED;


endmodule : OneSecondBlink


// This checks if outputs are inverted on board, as well as frequency of clock
module LedOn (
	input clk,    // Clock
	output wire [7:0] PMOD1_D,
	output wire [7:0] PMOD2_D,
	output wire [7:0] PMOD3_D
	
);

reg [26-1:0] timecounter;
reg [7:0] LED;


initial begin
	LED <= 8'b 11111111;
end

always @(posedge clk) begin : proc_
	casez (timecounter)
		12_000_000-1: begin 
			timecounter <= 0;
			LED[2] <= ~LED[2];
		end
		default : timecounter<=timecounter+1;
	endcase
end

// Values are inverted on iceSugar board!
assign PMOD1_D=~LED;
assign PMOD2_D=~LED;
assign PMOD3_D=~LED;


endmodule : LedOn

module TestClocks (
	input clk,    // Clock
	output wire VGAMOD_VS,
	output wire VGAMOD_HS
);

reg LED_24Mhz;
reg [26-1:0] timecounter_24mhz;

// Tests clocks of 12Mhz and 24 Mhz
wire clk_24Mhz;
	sysmgr sys_mgr_I (
		.clk_in  (clk),
		.clk_24Mhz  (clk_24Mhz)
	);

// Will blink at 1Hz if clk_24Mhz is really 24 Mhz, at icesugar PMOD3, LED D0
always @(posedge clk_24Mhz) begin : proc_
	case (timecounter_24mhz)
		24_000_000-1: begin 
			timecounter_24mhz <= 0;
			LED_24Mhz <= ~ LED_24Mhz;
		end
		default: timecounter_24mhz <=timecounter_24mhz+1;
	endcase
end

assign VGAMOD_VS = LED_24Mhz;
assign VGAMOD_HS = LED_24Mhz;

endmodule : TestClocks