function sol = lungModel_peripheralReg_breathing1R
% Wheldon's model of chronic granuloctic leukemia 
% from N. MacDonald, Time Lags in Biological Models, 
% Springer-Verlag, Berlin, 1978.

% Copyright 2002, The MathWorks, Inc.

tau = [20, 30, 4];
options=ddeset('MaxStep',0.05);
sol = dde23(@exer3f,tau,[44.3; 38],[0, 1500],options);
%sol = dde23(@exer3f,tau,[44.3; 38],[0, 200],options);

p_tiss = sol.y(1,:);
p_lungs = sol.y(2,:);
pressures = zeros(size(sol.x));
pressures(1,:)=p_tiss;
pressures(2,:)=p_lungs;

%figure
hold on
%subplot(2,1,1);
% plot(sol.x,p_tiss,'LineWidth',1.5)
% legend('combined','central','peripheral')
% subplot(2,1,2);
plot(sol.x,p_lungs,'LineWidth',1.5)
legend('combined','central','peripheral')
%legend('Pt (lambda_p=8)','Pl (lambda_p=8)','Pt (lambda_p=16)','Pl (lambda_p=16)','Pt (lambda_p=24.86)','Pl (lambda_p=24.86)','Pt (rect)','Pl (rect)')
%legend('Pt (lin f-rectPulse)','Pl (lin f-rectPulse)','Pt (lin T-rectPulse)','Pl (lin T-rectPulse)','Pt (lin f-sinusoid)','Pl (lin f-sinusoid)','Pt (lin T-sinusoid)','Pl (lin T-sinusoid)')
% legend('Tissue PCO2','Lung PCO2')
% title([' Stability of eq. point for peripheral reg: ra=',num2str(tau(1,1)),'s, rv=',num2str(tau(1,2)),'s, rp=',num2str(tau(1,3)), 's.'])
% xlabel('time t (in s)')
% ylabel('CO2 partial pressure (in mm Hg)')
% hold on
% plot(sol.x,pressures,'LineWidth',1.5)
% legend('Pt (VL)','Pl (VL)','Pt (VL-500)','Pl (VL-500)','Pt (VL+500)','Pl (VL+500)')
% legend('Pt (og)','Pl (og)','Pt (br)','Pl (br)');

% figure;
% GP=500*exp(-0.05*82);
% IP=35.5;
% Mu_p=-GP*IP;
% lambda_p=GP;
% vdotA = max(0,lambda_p*p_lungs + Mu_p);
% plot(sol.x,vdotA);
% xlabel('time (in s)'),ylabel('alveolar ventilation, VdotA(t+rB) (in ml/s)');


%-----------------------------------------------------------------------

function yp = exer3f(t,y,Z)
%EXER3F  The derivative function for Exercise 3 of the DDE Tutorial.

GP=1500*exp(-0.05*82);
IP=35.5;

B = 760;
Mu_c = -1445;
%Mu_p = -1250;
Mu_p=-GP*IP;
P1 = 0.3;
lambda_c = 33.3;
%lambda_p = 33.3;
lambda_p=GP;
qdot = 100;
Mdot = 3.8;
Vt = 15000;

% (alveolar ventilation) Vdot = lambda_p*PL(t-rp) + mu_p => frequency of
% breaths, f = Vdot/V_T (V_T=tidal volume)
V_T=500;
% Vl=breathingLung_volume(t)*1000;
% vldot=breathingLung_volumeChangeRate(t)*1000;
Vl=2800;
vldot=0;
alpha = 0.0065;

%f=V_T/(lambda_p*ylag3(2) + Mu_p);
a = qdot/Vt;
c1 = Mdot/(alpha*Vt);
%b = alpha*qdot*B/Vl;
b = alpha*qdot*B;
% c = Mu_p*(1-pulsewav(t,5,0.4))/Vl;
% d = lambda_p*pulsewav(t,5,0.4)*P1/Vl;
% e = lambda_p*(1-pulsewav(t,5,0.4))/Vl;
% c2 = Mu_p*P1*pulsewav(t,5,0.4)/Vl;
% c = Mu_p/Vl;
% d = lambda_p*P1/Vl;
% e = lambda_p/Vl;
% c2 = Mu_p*P1/Vl;
c3 = vldot;

ylag1 = Z(:,1);
ylag2 = Z(:,2);
ylag3 = Z(:,3);
yp = zeros(2,1);

yp(1) = -a*y(1) + a*ylag1(2) + c1;
%yp(2) = b*ylag2(1) - (b+c+c3)*y(2) - d*ylag3(2) - e*y(2)*ylag3(2) + c2;
%yp(2) = (b/Vl)*ylag2(1) - (b+(lambda_p*ylag3(2) + Mu_p)*(1-pulsewav(t,V_T/(lambda_p*ylag3(2) + Mu_p),0.4))+c3)*y(2)/Vl + (pulsewav(t,V_T/(lambda_p*ylag3(2) + Mu_p),0.4)*(lambda_p*ylag3(2) + Mu_p)*P1)/Vl;

%yp(2) = (b/Vl)*ylag2(1) - (b+max(0,lambda_p*ylag3(2) + Mu_p)*(1-pulsewav1(t,V_T/max(0,lambda_p*ylag3(2) + Mu_p),0.4))+c3)*y(2)/Vl + pulsewav1(t,V_T/max(0,lambda_p*ylag3(2) + Mu_p),0.4)*max(0,lambda_p*ylag3(2) + Mu_p)*P1/Vl;
%yp(2) = (b*ylag2(1) - (b+max(0,lambda_p*ylag3(2) + Mu_p)*(1-pulsewav(t,V_T/max(0,lambda_p*ylag3(2) + Mu_p),0.4))+bvlc_smooth(t,0.4,V_T/max(0,lambda_p*ylag3(2) + Mu_p),V_T))*y(2) + pulsewav(t,V_T/max(0,lambda_p*ylag3(2) + Mu_p),0.4)*max(0,lambda_p*ylag3(2) + Mu_p)*P1)/bvl_smooth(t,0.4,V_T/max(0,lambda_p*ylag3(2) + Mu_p),V_T);
%yp(2) = (b/Vl)*ylag2(1) - (b+(lambda_p*ylag3(2) + Mu_p)*(1-pulsewav1(t,5,0.4))+c3)*y(2)/Vl + (pulsewav1(t,5,0.4)*(lambda_p*ylag3(2) + Mu_p)*P1)/Vl;

yp(2) = (b/Vl)*ylag2(1) - (b+max(0,lambda_p*ylag3(2) + Mu_p)*(1-pulsewav1(t,(5+max(0,-0.98*(ylag3(2)-40.8)+6.45)),0.4))+c3)*y(2)/Vl + (pulsewav1(t,(5+max(0,-0.98*(ylag3(2)-40.8)+6.45)),0.4)*max(0,lambda_p*ylag3(2) + Mu_p)*P1)/Vl;


%yp(2) = (b*ylag2(1) - (b+max(0,lambda_p*ylag3(2) + Mu_p)+bvlc_smooth(t,0.4,V_T/max(0,lambda_p*ylag3(2) + Mu_p),V_T))*y(2) + max(0,lambda_p*ylag3(2) + Mu_p)*P1)/bvl_smooth(t,0.4,V_T/max(0,lambda_p*ylag3(2) + Mu_p),V_T);

%yp(2) = (b/Vl)*ylag2(1) - (b+max(0,lambda_p*ylag3(2) + Mu_p)*(0.5-0.5*sin(2*pi*t*max(0,lambda_p*ylag3(2) + Mu_p)/V_T))+c3)*y(2)/Vl + 0.5*(1+sin(2*pi*t*max(0,lambda_p*ylag3(2) + Mu_p)/V_T))*max(0,lambda_p*ylag3(2) + Mu_p)*P1/Vl;

%yp(2) = (b/Vl)*ylag2(1) - (b+max(0,lambda_p*ylag3(2) + Mu_p)*(0.5-0.5*sin(2*pi*t/(5+max(0,-0.98*(ylag3(2)-40.8)+6.45))))+c3)*y(2)/Vl + 0.5*(1+sin(2*pi*t/(5+max(0,-0.98*(ylag3(2)-40.8)+6.45))))*max(0,lambda_p*ylag3(2) + Mu_p)*P1/Vl;
%yp(2) = (b/Vl)*ylag2(1) - (b+max(0,lambda_p*ylag3(2) + Mu_p)*(0.5-0.5*sin(2*pi*0.1*t/V_T))+c3)*y(2)/Vl + 0.5*(1+sin(2*pi*0.1*t/V_T))*max(0,lambda_p*ylag3(2) + Mu_p)*P1/Vl;


%yp(2) = (b/(bvl(t,0.4,V_T/(lambda_p*ylag3(2) + Mu_p),V_T)*1000))*ylag2(1) - ((b+(lambda_p*ylag3(2) + Mu_p)*(1-pulsewav(t,V_T/(lambda_p*ylag3(2) + Mu_p),0.4))+bvlc(t,0.4,V_T/(lambda_p*ylag3(2) + Mu_p),V_T)*1000)/(bvl(t,0.4,V_T/(lambda_p*ylag3(2) + Mu_p),V_T)*1000))*y(2) + (pulsewav(t,V_T/(lambda_p*ylag3(2) + Mu_p),0.4)*P1*(lambda_p*ylag3(2) + Mu_p)/(bvl(t,0.4,V_T/(lambda_p*ylag3(2) + Mu_p),0.5)*1000));
%vdotA = max(0,lambda_p*ylag3(2) + Mu_p);
%Vl=breathingLung_volume(t,0.4,V_T/vdotA,0.5)*1000;
%vldot=breathingLung_volumeChangeRate(t,0.4,V_T/vdotA,0.5)*1000;

% 0.5*(1+sin(2*pi*max(0,lambda_p*ylag3(2) + Mu_p)*t/V_T))
