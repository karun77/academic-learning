function f = objfun_multi(x,flula)
alpha=x;

if ~exist('flula','var')
    flula = false;
end

if(flula)
    alphamin=0.85;alphamax=0.95;
    randNumber = alphamin+rand(1,1)*(alphamax-alphamin);
    alpha = (alpha + randNumber)/2
else
    alpha
end


% tintial=400;
% tfinal=700;
dt=0.05;
% %alpha=0.9;
%      if alpha <=1
%          y_ini=80;
% %[t,objfun y_fde12] = fde12(alpha,@fdefun,t0,tfinal,y0,h) ; %windkessel model 2
% %[t, y_fde12] = fde12(alpha,@fdefun1,t0,tfinal,y0,h) ; %windkessel model 3
% [t, y_fde12] = fde12(alpha,@fdefun2,tintial,tfinal,y_ini,dt) ; %windkessel model 4
%     else
%        y_ini=[80 0]; 
% %[t, y_fde12] = fde12(alpha,@fdefun,t0,tfinal,y0,h) ; %%windkessel model 2
% %[t, y_fde12] = fde12(alpha,@fdefun1,t0,tfinal,y0,h) ; %%windkessel model 3
% [t, y_fde12] = fde12(alpha,@fdefun2,tintial,tfinal,y_ini,dt) ; %windkessel model 4
%      end

h=get_param('lungModel1','modelworkspace');
h.assignin('alpha1',2-alpha);
SimOut = sim('lungModel1','ReturnWorkspaceOutputs','on');

%% experimental data
% [X_exp,Y_exp]=dataATM('a40002_000007m');
% for i=1:length(X_exp)-16
%     Y_data(i)=Y_exp(i+16);
%     X_data(i)=X_exp(i);
% end
% 
% Y_final=Y_data(1:length(t));

[rr,t] = calcPatientRR('bidmc02m');
rr = rr*60;
t1 = 0:0.05:470;
rr1 = interp1(t,rr,t1);

yexp_new = rr1;


%% intially the system is having high error

% ysim_new=[];
% yexp_new=[];
% for i=590:1:length(t)
%     ysim_new=[ysim_new y_fde12(i)];
%     yexp_new=[yexp_new Y_final(i)];
% end

respRate = getdatasamples(SimOut.RR,1:9401);
respRate = respRate';

ysim_new = respRate;

%plot(ysim_new)
e=ysim_new-yexp_new;
ind=~isnan(e);
e=e(ind);
%e=Y_final-y_fde12;
ISE=trapz(dt,e.^2);
%ISE=sum(e*e'.*dt);
% ISE=sum(abs(e).^2)*dt;
f=ISE