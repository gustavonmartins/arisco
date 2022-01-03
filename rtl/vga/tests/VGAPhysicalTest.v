`default_nettype none


// This is a physical test. Needs to connect icesugarboard to led/TV to test it.
module VGAPhysicalTest (
	input clk,
	output reg [3:0] VGAMOD_R, 
	output reg [3:0] VGAMOD_G, 
	output reg [3:0] VGAMOD_B,
	
	output wire VGAMOD_VS, 
	output wire VGAMOD_HS
	);
	
	//Gets 24Mhz Clock from 48 Mhz (ICE40 clock is 12Mhz, and this makes it 48Mhz)
			sysmgr sys_mgr_I (
				.clk_in  (clk),
				.clk_4x  (clk_4x)
			);
	
	wire clk_4x;

	always @(posedge clk_4x) begin
		clk_24Mhz <= ~clk_24Mhz;
	end
	
	reg clk_24Mhz;


	// Passes to VGA signal generator
	VGA vga(.clk25175KHz(clk_24Mhz),.o_HPos(HPos),.o_VPos(VPos), .hSync(VGAMOD_HS), .vSync(VGAMOD_VS));
	wire [9:0] HPos;
	wire [9:0] VPos;

	//Sets pixel color based on position

	initial begin
		VGAMOD_G[0] <= 0;
		VGAMOD_G[1] <= 0;
	end


	initial begin
		debug_hcounter<=0;
		debug_vcounter<=0;
	end

	// Should blink at 1Hz in real circuit
	reg VGAMOD_HS_FF; 
	reg [16-1:0] debug_hcounter;
	always @(posedge clk_4x) begin 					//Do not use posedge sync here, because I tried and glitches make you crazy
		VGAMOD_HS_FF <= VGAMOD_HS; 					//Gets a delayed sync value
		if(VGAMOD_HS_FF==1 && VGAMOD_HS==0) begin 	// Detects if there was a pos edge
			case (debug_hcounter) 
			31500*2-1: begin 
					debug_hcounter <= 0;
					VGAMOD_G[0]<= ~VGAMOD_G[0];
				end
			default: debug_hcounter <= debug_hcounter+1;
		endcase
		end
	end

	// Should blink at 1Hz in real circuit
	reg VGAMOD_VS_FF; 
	reg [7-1:0] debug_vcounter;
	always @(posedge clk_4x) begin					//Do not use posedge sync here, because I tried and glitches make you crazy
		VGAMOD_VS_FF <= VGAMOD_VS; 					//Gets a delayed sync value
		if(VGAMOD_VS_FF==1 && VGAMOD_VS==0) begin 	// Detects if there was a pos edge
			case (debug_vcounter) 
			60*2-1: begin 
					debug_vcounter <= 0;
					VGAMOD_G[1]<= ~VGAMOD_G[1];
				end
			default: debug_vcounter <= debug_vcounter+1;
		endcase
		end
	end
	
	/**
	always @(posedge clk_4x) begin
		if ((HPos> 200) && (HPos<300)) begin
			VGAMOD_R<=4'b 1111;
		end else begin
			VGAMOD_R<=4'b 0;
			VGAMOD_G<=4'b 0;
			VGAMOD_B<=4'b 0;
		end
	end
	**/

endmodule