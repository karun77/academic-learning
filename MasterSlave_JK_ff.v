//we require two always bocks here, one will run at the pos edge and the other at
//the neg edge of the clock cycle (master and slave respectively)

//basically we'll use two jk flipflops here
//this module will have 8 inputs and four outputs

module MasterSlave_JK_ff(clk,J,K,PRE,CLR,Q1b,Q1cb,Q2b,Q2cb,Q1,Q1c,Q2,Q2c);

//PRE and CLR should not be high at the same time, since they perform opposite 
//functions
input clk,J,K,PRE,CLR,Q1b,Q1cb,Q2b,Q2cb;
output reg Q1,Q1c,Q2,Q2c;
//doh is just a dummy variable to deal with the condition Q1=1,Q1c=1 (in the 2nd 
//always block) - which 
//will ofcourse never happen (since JK flipflop's outputs are always opposite)
reg doh;

//the master jk ff is active
always @(posedge clk) begin

if(PRE==1'b1) begin
	Q1<=1;
	Q1c<=0;
end
else if(CLR==1'b1) begin
	Q1<=0;
	Q1c<=1;
end
else if(J==1'b0 && K==1'b0) begin
	Q1<=Q1b;
	Q1c<=Q1cb;	
end
else if(J==1'b0 && K==1'b1) begin
	Q1<=0;
	Q1c<=1;	
end
else if(J==1'b1 && K==1'b0) begin
	Q1<=1;
	Q1c<=0;	
end
else begin
	Q1<=!(Q2b);
	Q1c<=!(Q2cb);
end

end


//the slave ff is active
always @(negedge clk) begin

if(Q1==1'b0 && Q1c==1'b0) begin
	Q2<=Q2b;
	Q2c<=Q2cb;	
end
else if(Q1==1'b0 && Q1c==1'b1) begin
	Q2<=0;
	Q2c<=1;	
end
else if(Q1==1'b1 && Q1c==1'b0) begin
	Q2<=1;
	Q2c<=0;	
end
else begin
	doh=0;
end

end

endmodule