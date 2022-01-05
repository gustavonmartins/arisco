`default_nettype none


// This is a physical test. Needs to connect icesugarboard to led/TV to test it.
module VGAPhysicalTest (
	input clk,
	output wire [3:0] VGAMOD_R, 
	output wire [3:0] VGAMOD_G, 
	output wire [3:0] VGAMOD_B,
	
	output wire VGAMOD_VS, 
	output wire VGAMOD_HS
	);
	
	//Gets 24Mhz using PLL
	wire clk_24Mhz;
	sysmgr sys_mgr_I (
		.clk_in  (clk),
		.clk_24Mhz  (clk_24Mhz)
	);


	
	// Passes to VGA signal generator
	wire hSync, vSync;
	wire [9:0] HPos;
	wire [9:0] VPos;
	VGA vga(.clk25175KHz(clk_24Mhz),.o_HPos(HPos),.o_VPos(VPos), .hSync(hSync), .vSync(vSync));
	
	/**
	//Physical test using LEDS.
	reg hSync_1Hz;
	reg vSync_1Hz;

	initial begin
		vSync_1Hz <= 0;
		hSync_1Hz <= 0;

		debug_hcounter<=0;
		debug_vcounter<=0;
	end

	// Should blink at 1Hz in real circuit
	reg hSync_FF; 							// This is the 1-cycle delayed hS signal
	reg [15-1:0] debug_hcounter;
	always @(posedge clk_24Mhz) begin 		//Do not use posedge sync here, because I tried and glitches make you crazy
		hSync_FF <= hSync; 					//Gets a delayed sync value
		if(hSync_FF==1 && hSync==0) begin 	// Detects if there was a pos edge
			case (debug_hcounter) 
			31500-1: begin 
					debug_hcounter <= 0;
					hSync_1Hz <= ~hSync_1Hz;
				end
			default: debug_hcounter <= debug_hcounter+1;
		endcase
		end
	end


	// Should blink at 1Hz in real circuit
	reg vSync_FF; 							// This is the 1-cycle delayed vS signal
	reg [6-1:0] debug_vcounter;
	always @(posedge clk_24Mhz) begin		//Do not use posedge sync here, because I tried and glitches make you crazy
		vSync_FF <= vSync; 					//Gets a delayed sync value
		if(vSync_FF==1 && vSync==0) begin 	// Detects if there was a pos edge
			case (debug_vcounter) 
			60-1: begin 
					debug_vcounter <= 0;
					vSync_1Hz<= ~vSync_1Hz;
				end
			default: debug_vcounter <= debug_vcounter+1;
		endcase
		end
	end

	assign VGAMOD_G[1:0] = ~(2'b 00);
	assign VGAMOD_G[2] = hSync_1Hz;
	assign VGAMOD_G[3] = vSync_1Hz;
	assign VGAMOD_HS = hSync;
	assign VGAMOD_VS = vSync;
	**/
	
	
	reg [3:0] red, green, blue;

	always @(posedge clk_24Mhz) begin
		if ((HPos> 200) && (HPos<300)) begin
			red<=4'b 1100;
		end else begin
			red<=4'b 0;
			green<=4'b 1010;
			blue<=4'b 1;
		end
	end

	assign VGAMOD_R=~red;
	assign VGAMOD_G=~green;
	assign VGAMOD_B=~blue;
	assign VGAMOD_HS = ~hSync;
	assign VGAMOD_VS = ~vSync;
	
	
	

endmodule