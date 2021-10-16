`timescale 1ns/10ps
`include "sequenceDetector_Moore.v"

module sequenceDetector_Moore_tb;

reg x, clock;
wire y;
wire [2:0] yS;

always begin
	#5;
	clock = !clock;
end

sequenceDetector_Moore test(clock,x,y,yS);

initial begin

$dumpfile("sequenceDetector_Moore_tb.vcd");
$dumpvars(0,sequenceDetector_Moore_tb);
$monitor(clock,"|",x,"|",y,"|",yS,"|",);

clock=1'b0;
x=1'b0; #4;
x=1'b1; #10;
x=1'b0; #10;
x=1'b1; #10;
x=1'b1; #10;
x=1'b1; #10;
x=1'b0; #10;
x=1'b1; #10;
x=1'b1; #10;
x=1'b0; #10;
x=1'b0; #10;

$finish;

end

endmodule