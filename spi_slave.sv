module spi_slave #(parameter DATA_WIDTH = 8) (
	input                   clk     , // Clock
	input                   srst    , // srst
	input  [DATA_WIDTH-1:0] data_in , //data to be send to slave
	input                   send    ,
	input  [           1:0] mode    ,
	output                   miso   ,
	output                  busy ,
	input                  sck     ,
	input                  cs      ,
	input                  mosi    ,
	output [DATA_WIDTH-1:0] data_out
);

	typedef enum logic [2:0] {IDLE='d0,SENT='d1,TRANSFER='d2,DONE='d3} state_t;


	// clk  	mode cpol  Cpha  description
	//	0 	0     0     0     sample on rising edge/shift on negedge
	//	0 	1     0     1     sample on fall edge/shift on negedge
	//	1 	2     1     0     sample on rising edge/shift on negedge
	//	1 	3     1     1     sample on fall edge/shift on negedge

	logic [      DATA_WIDTH-1:0] mosi_reg  ;
	logic [      DATA_WIDTH-1:0] miso_reg  ;
	logic [$clog2(DATA_WIDTH):0] index     ;
	state_t                      curr_state;
	state_t                      next_state;


	always_ff @(posedge sck) begin : proc_
		if(rst) begin
			curr_state <= IDLE;
			cs         <= 1;
			index      <= 0;
		end else begin
			case (curr_state)
				IDLE : begin
					if(send)begin
						curr_state <= SENT;
					end
					else
						begin
							curr_state <= IDLE;
						end
					cs <= 1;
				end
				SENT : begin
					cs         <= 0;
					curr_state <= TRANSFER;
					index      <= DATA_WIDTH-1 ;
				end
				TRANSFER :
					if(index==8)
					begin
						curr_state = IDLE;
						cs <=0;
					end
					else
						begin
							index<=index+1;
						end
				default :curr_state =IDLE;
			endcase
		end
	end


	always_ff @(negedge sck) begin : proc_miso_reg
		miso_reg <= miso_reg<<1;
	end

	always_ff @(posedge sck) begin : proc_mosi_reg
		mosi_reg <= {mosi_reg[DATA_WIDTH-2:0],mosi};
		end

assign miso = ~cs ?  miso_reg[DATA_WIDTH-1]:'0;
assign data_out = curr_state == DONE ?  mosi_reg :'0;

endmodule : spi_slave