//to detect the sequence '10110'
module sequenceDetector_Moore(clk,in,out,state);

input clk,in;
reg doh;//dummy variable
output reg out;
output reg [2:0] state;

initial begin
	state <= 3'b000;
end

always @(posedge clk) begin
	if(in==1'b0 && state==3'b000) begin
		state<=3'b000;
	end 
	else if(in==1'b1 && state==3'b000) begin
		state<=3'b001;	
	end
	else if(in==1'b0 && state==3'b001) begin
		state<=3'b010;	
	end
	else if(in==1'b1 && state==3'b001) begin
		state<=3'b001;	
	end
	else if(in==1'b0 && state==3'b010) begin
		state<=3'b000;	
	end
	else if(in==1'b1 && state==3'b010) begin
		state<=3'b011;	
	end
	else if(in==1'b0 && state==3'b011) begin
		state<=3'b010;	
	end
	else if(in==1'b1 && state==3'b011) begin
		state<=3'b100;	
	end
	else if(in==1'b0 && state==3'b100) begin
		state<=3'b101;	
	end
	else if(in==1'b1 && state==3'b100) begin
		state<=3'b001;	
	end
	else if(in==1'b0 && state==3'b101) begin
		state<=3'b000;	
	end
	else if(in==1'b1 && state==3'b101) begin
		state<=3'b001;	
	end	
    else begin
		doh<=1;
	end
	
	if(state == 3'b101) begin 
		out<=1'b1;
	end
	else begin 
		out<=1'b0;
	end
end

endmodule

