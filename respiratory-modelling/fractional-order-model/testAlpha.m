function ISE = testAlpha(alpha)

h=get_param('lungModel1','modelworkspace');
h.assignin('alpha1',2-alpha);
SimOut = sim('lungModel1','ReturnWorkspaceOutputs','on');

rrFrac = get(SimOut.RR,'DATA');
rrFrac = rrFrac';
y2 = rrFrac(1:9401);

[rr,t] = calcPatientRR('bidmc02m');

rr = rr*60;
t1 = 0:0.05:470;
rr1 = interp1(t,rr,t1);

% figure;
% plot(t1,y2,LineWidth=1.5)
% hold on
% plot(t1,rr1,LineWidth=1.5)

err = y2 - rr1;
ind = isnan(err);
err(ind)=0;

ISE = trapz(0.05,err.^2);





