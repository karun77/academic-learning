`timescale 1ns/10ps
`include "MasterSlave_JK_ff.v"

module MasterSlave_JK_ff_tb;

reg x,y,pi,ci,a1,b1,a2,b2,clock;
wire a3,b3,a4,b4;

MasterSlave_JK_ff test(clock,x,y,pi,ci,a1,b1,a2,b2,a3,b3,a4,b4);

always begin 
	#5;
	clock=!clock;
end

initial begin

$dumpfile("MasterSlave_JK_ff_tb.vcd");
$dumpvars(0,MasterSlave_JK_ff_tb);
$monitor(clock,"|",x,"|",y,"|",pi,"|",ci,"|",a1,b1,"|",a2,b2,"|",a3,b3,"|",a4,b4);

clock=0;
x=1;
y=0;
pi=0;
ci=1;
a1=0;
b1=0;
a2=0;
b2=0;

#15;

x=0;
y=1;
pi=1;
ci=0;
a1=0;
b1=0;
a2=0;
b2=0;

#15;

x=1;
y=1;
pi=0;
ci=1;
a1=0;
b1=0;
a2=0;
b2=0;

#15;

x=1;
y=0;
pi=0;
ci=0;
a1=0;
b1=0;
a2=0;
b2=0;

#15;
$finish;

end

endmodule