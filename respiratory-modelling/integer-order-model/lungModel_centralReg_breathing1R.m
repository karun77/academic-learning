function sol = lungModel_centralReg_breathing1R
% Wheldon's model of chronic granuloctic leukemia 
% from N. MacDonald, Time Lags in Biological Models, 
% Springer-Verlag, Berlin, 1978.

% Copyright 2002, The MathWorks, Inc.

tau = [20, 30, 8.4];
options=ddeset('MaxStep',0.05);
sol = dde23(@exer3f,tau,[44.3; 38],[0, 1500],options);

p_tiss = sol.y(1,:);
p_lungs = sol.y(2,:);
pressures = zeros(size(sol.x));
pressures(1,:)=p_tiss;
pressures(2,:)=p_lungs;

%figure
hold on
% subplot(2,1,1);
%plot(sol.x,p_tiss)
% subplot(2,1,2);
plot(sol.x,p_lungs,'LineWidth',1.5)
%legend('Pt (lin f-rectPulse)','Pl (lin f-rectPulse)','Pt (lin T-rectPulse)','Pl (lin T-rectPulse)');
% legend('Tissue PCO2','Lung PCO2')
% title([' Trajectory of plant with central regulation., ra=',num2str(tau(1,1)),'s rv=',num2str(tau(1,2)),'s .'])
% xlabel('time t (in s)')
% ylabel('Partial pressure of CO2 (in mm Hg)')
% % hold on
% plot(sol.x,pressures)
% legend('Pt (no br)','Pl (no br)','Pt (br)','Pl (br)','Pt (real br)','Pl (real br)')
% hold on
% plot(sol.x,pressures,'LineWidth',1.5)
% %legend('Pt (VL)','Pl (VL)','Pt (VL-500)','Pl (VL-500)','Pt (VL+500)','Pl (VL+500)')
% legend('Pt (og)','Pl (og)','Pt (br)','Pl (br)');

%-----------------------------------------------------------------------

function yp = exer3f(t,y,Z)
%EXER3F  The derivative function for Exercise 3 of the DDE Tutorial.

MRB=220/60;
KCO2=0.0057;
FB=100;
IC=35.5;
GC=1500/60;
%GC=15;

B = 760;
%Mu_c = -1445;
Mu_c = -GC*(MRB/(KCO2*FB) + IC);
Mu_c = Mu_c + 150;
%Mu_p = -1250;
P1 = 0.3;
%lambda_c = 33.3;
lambda_c = GC;
lambda_p = 33.3;
qdot = 100;
Mdot = 3.8;
Vt = 15000;
% Vl=breathingLung_volume(t)*1000;
% vldot=breathingLung_volumeChangeRate(t)*1000;
Vl=2800;
vldot=0;
alpha = 0.0065;

V_T=500;
a=qdot/Vt;
c1=Mdot/(alpha*Vt);
%b=(lambda_c*pulsewav(t,5,0.4)*P1+alpha*qdot*B)/Vl;
b = alpha*qdot*B;
%c=(alpha*qdot*B + Mu_c*(1-pulsewav(t,5,0.4)))/Vl;
%c2=lambda_c*(1-pulsewav(t,5,0.4))/Vl;
%c3=(Mu_c*pulsewav(t,5,0.4)*P1)/Vl;
c3=vldot;

ylag1 = Z(:,1);
ylag2 = Z(:,2);
ylag3 = Z(:,3);
yp = zeros(2,1);

yp(1) = (-a*y(1)) + (a*ylag1(2)) + c1;
%yp(2) = (b*ylag2(1)) - ((c+c4)*y(2)) - (c2*y(1)*y(2)) + c3;
%yp(2) = ((lambda_c*pulsewav(t,V_T/(lambda_c*y(1) + Mu_c),0.4)*P1+b)*ylag2(1)/Vl) - ((b+Mu_c*(1-pulsewav(t,V_T/(lambda_c*y(1) + Mu_c),0.4))+c4)*y(2)/Vl) - ((lambda_c*(1-pulsewav(t,V_T/(lambda_c*y(1) + Mu_c),0.4)))*y(1)*y(2)/Vl) + (Mu_c*pulsewav(t,V_T/(lambda_c*y(1) + Mu_c),0.4)*P1)/Vl;
yp(2) = b*ylag2(1)/Vl - (b + (1-pulsewav1(t,V_T/max(0,lambda_c*ylag3(2) + Mu_c),0.4))*max(0,lambda_c*ylag3(2) + Mu_c) + vldot)*y(2)/Vl + pulsewav1(t,V_T/max(0,lambda_c*ylag3(2) + Mu_c),0.4)*max(0,lambda_c*ylag3(2) + Mu_c)*P1/Vl;
%yp(2) = b*ylag2(1)/Vl - (b + (1-pulsewav1(t,V_T/max(0,lambda_c*y(1) + Mu_c),0.4))*max(0,lambda_c*y(1) + Mu_c) + vldot)*y(2)/Vl + pulsewav1(t,V_T/max(0,lambda_c*y(1) + Mu_c),0.4)*max(0,lambda_c*y(1) + Mu_c)*P1/Vl;


%yp(2) = (b/Vl)*ylag2(1) - (b+(lambda_c*ylag3(2) + Mu_c)*(1-pulsewav(t,V_T/(lambda_c*ylag3(2) + Mu_c),0.4))+c3)*y(2)/Vl + (pulsewav(t,V_T/(lambda_c*ylag3(2) + Mu_c),0.4)*(lambda_c*ylag3(2) + Mu_c)*P1)/Vl;


%i changed the central control equation, instead of being controlled by Pt,
%VdotA is controlled by Pl(t-rB)
