function sol = lungModel_PerAndCentral_breathing1R
% Wheldon's model of chronic granuloctic leukemia 
% from N. MacDonald, Time Lags in Biological Models, 
% Springer-Verlag, Berlin, 1978.

% Copyright 2002, The MathWorks, Inc.

tau = [20, 30, 4, 8.4];
options=ddeset('MaxStep',0.05);
sol = dde23(@exer3f,tau,[47.3; 41.6],[0,1000],options);

p_tiss = sol.y(1,:);
p_lungs = sol.y(2,:);
pressures = zeros(size(sol.x));
pressures(1,:)=p_tiss;
pressures(2,:)=p_lungs;

figure
%subplot(2,1,1);
plot(sol.x,pressures)
xlabel('time t (in s)'),ylabel('PCO2 partial pressure (in mm Hg)')%,title('in tissues');
%subplot(2,1,2);
%plot(sol.x,p_lungs,'LineWidth',1.5)
%xlabel('time t (in s)'),ylabel('P_CO2 (in mm Hg)'),title('in lungs');
legend('Tissue PCO2','Lung PCO2')
%title([' Trajectory of PCO2 for combined control: ra=',num2str(tau(1,1)),'s, rv=',num2str(tau(1,2)),'s, rp=',num2str(tau(1,3)), 's.'])

% hold on
% plot(sol.x,pressures,'LineWidth',1.5)
% legend('Pt (VL)','Pl (VL)','Pt (VL-500)','Pl (VL-500)','Pt (VL+500)','Pl (VL+500)')
% legend('Pt (og)','Pl (og)','Pt (br)','Pl (br)');

%obtaining the lung PCO2 delayed by 4s and 8.4s to calculate VdotA and from
%that RR (resp. rate)

pCO2_p = [zeros(1,168),p_lungs];
pCO2_c = [zeros(1,80),p_lungs,zeros(1,88)];

%GP=500*exp(-0.05*82);
%GP=387.5*exp(-0.05*99);
GP=2000*exp(-0.05*82);
IP=39;
%IP=33;
MRB=50/60;
%MRB=11/60;
KCO2=0.0057;
%KCO2=0.005;
FB=80;
%FB=238/60;
IC=39;
%IC=33;
GC=1500/60;
%GC=22.8;

B = 760;
Mu_c = -GC*(MRB/(KCO2*FB) + IC);
%Mu_c = Mu_c;
Mu_p=-GP*IP;
lambda_c=GC;
lambda_p=GP;

V_T=500;

vdotA = max(0,lambda_c*pCO2_c + Mu_c)+max(0,lambda_p*pCO2_p + Mu_p);
rr = vdotA/V_T;
rr = rr*60;
figure
plot(sol.x(1,2000:19000),rr(2000:19000))
xlabel('time (in s)'),ylabel('respiratory rate (in breaths/min)')

%-----------------------------------------------------------------------

function yp = exer3f(t,y,Z)
%EXER3F  The derivative function for Exercise 3 of the DDE Tutorial.

%GP=500*exp(-0.05*82);
%GP=387.5*exp(-0.05*99);
GP=2000*exp(-0.05*82);
IP=39;
%IP=33;
MRB=50/60;
%MRB=11/60;
KCO2=0.0057;
%KCO2=0.005;
FB=80;
%FB=238/60;
IC=39;
%IC=33;
GC=1500/60;
%GC=22.8;

B = 760;
Mu_c = -GC*(MRB/(KCO2*FB) + IC);
%Mu_c = Mu_c;
Mu_p=-GP*IP;
P1 = 0.3;
lambda_c=GC;
lambda_p=GP;
qdot = 100;
%qdot=1160/60;
Mdot = 220/60;
%Mdot=34/60;
%Mdot=80/60;
Vt = 15000;
%Vt=2000;
%Vt=6000;
%Vt=8000;

% (alveolar ventilation) Vdot = lambda_p*PL(t-rp) + mu_p => frequency of
% breaths, f = Vdot/V_T (V_T=tidal volume)
V_T=500;
%V_T=130.86;
% Vl=breathingLung_volume(t)*1000;
% vldot=breathingLung_volumeChangeRate(t)*1000;
Vl=3200;
%Vl=210;
%Vl=630;
%Vl=840;
vldot=0;
alpha = 0.0065;
%alpha=0.005;

a = qdot/Vt;
c1 = Mdot/(alpha*Vt);
b = alpha*qdot*B;
c3 = vldot;

ylag1 = Z(:,1);
ylag2 = Z(:,2);
ylag3 = Z(:,3);
ylag4 = Z(:,4);
yp = zeros(2,1);

% load('rr_interp.mat','rr_interp');
% i = t/0.05+1;
% i = int64(i);
% rr_interp = rr_interp/60; %converting to breaths per second


yp(1) = -a*y(1) + a*ylag1(2) + c1;
yp(2) = (b/Vl)*ylag2(1) - (b+(max(0,lambda_c*ylag4(2) + Mu_c)+max(0,lambda_p*ylag3(2) + Mu_p))*(1-pulsewav1(t,V_T/(max(0,lambda_c*ylag4(2) + Mu_c)+max(0,lambda_p*ylag3(2) + Mu_p)),0.4))+c3)*y(2)/Vl + (pulsewav1(t,V_T/(max(0,lambda_c*ylag4(2) + Mu_c)+max(0,lambda_p*ylag3(2) + Mu_p)),0.4)*(max(0,lambda_c*ylag4(2) + Mu_c)+max(0,lambda_p*ylag3(2) + Mu_p))*P1)/Vl;
%yp(2) = (b/Vl)*ylag2(1) - (b+(V_T*rr_interp(i))*(1-pulsewav1(t,rr_interp(i),0.4))+c3)*y(2)/Vl + (pulsewav1(t,rr_interp(i),0.4)*(V_T*rr_interp(i))*P1)/Vl;


