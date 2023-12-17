module spi_master#(parameter DATA_WIDTH = 8) (
	input clk,    // Clock
	input srst, // srst
	input [DATA_WIDTH-1:0] data_in,//data to be send to slave
	input send,
	input [1:0]mode,
	input  miso,
	output busy
	output sck,
	output cs,
	output mosi,
	output [DATA_WIDTH-1:0] data_out 
);

typedef enum logic [2:0] {IDLE='d0,SENT='d1,TRANSFER='d2,DONE='d3} state_t;


 // clk  	mode cpol  Cpha  description
 //	0 	0     0     0     sample on rising edge/shift on negedge
 //	0 	1     0     1     sample on fall edge/shift on negedge
//	1 	2     1     0     sample on rising edge/shift on negedge
 //	1 	3     1     1     sample on fall edge/shift on negedge

logic [DATA_WIDTH-1:0] mosi_reg;
logic [DATA_WIDTH-1:0] miso_reg;
logic [$clog2(DATA_WIDTH):0]index;
state_t curr_state;
state_t next_state;


always_ff @(posedge clk) begin 
	if(srst) begin
		curr_state <= IDLE;
	end else begin
		curr_state <= next_state  ;
	end
end

always_ff @(posedge clk) begin : proc_
	if(~logic) begin
		 <= 0;
	end else begin
		 <= ;
	end
end


always_ff @(posedge clk) begin 
	sck <= (curr_state == TRANSFER) ? ~sck : mode[1]; 
	
end

always_comb begin : proc_
case (curr_state)
	IDLE : begin
		if(send)begin
			next_state = SENT;	
		end
		else
			begin
				next_state = IDLE;	 
			end
		cs = 1;
	end
	SENT : begin
		cs = 0;
		next_state = TRANSFER;
		index = DATA_WIDTH-1 ;	
		end
	TRANSFER :

	begin

	end
	
	default : /* default */;
endcase
	
end









endmodule : spi_master