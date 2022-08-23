function[c,ceq] = nonlconstr_multi(x)
 alpha=x;
% tintial=0;
% tfinal=50;
% h=0.008;
%      if alpha <=1
%          y_ini=80;
% [t, y_fde12] = fde12(alpha,@fdefun2,tintial,tfinal,y_ini,h) ; %windkessel model 4
%     else
%        y_ini=[80 0]; 
% [t, y_fde12] = fde12(alpha,@fdefun2,tintial,tfinal,y_ini,h) ; %windkessel model 4
%      end
%     ysim_new=[];
% for i=590:1:length(t)
%     ysim_new=[ysim_new y_fde12(i)];
% end

h=get_param('lungModel1','modelworkspace');
h.assignin('alpha1',2-alpha);
SimOut = sim('lungModel1','ReturnWorkspaceOutputs','on');

respRate = getdatasamples(SimOut.RR,1:9401);
respRate = respRate';

ysim_new = respRate;
     
eq1 = max(ysim_new)-40;
eq2 = 0-min(ysim_new);
% 
% eq3= min(pao_sim)-85;
% eq4= 75-min(pao_sim);
% eq1 = max(pao_sim)-120;
% 
% eq4= 50-min(pao_sim);
% 
% eq5 = max(plv_sim)-125;
% eq6= 115-max(plv_sim);

% eq7 = min(plv_sim)-12;
% eq8= 8-min(plv_sim);

ceq=[];
%c=[eq1;eq2];
c=[eq1,eq2];

