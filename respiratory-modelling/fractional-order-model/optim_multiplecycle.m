clc
clear all;
%% The optimised value got is alpha=0.9485
% Range for alpha1
alphamin=1.22;
alphamax=1.26;

X_ini=[];%Collection of all initial controller values
X=[];%Collection of all controller values obtained through optimization
Y=[];%Collection of optimized controller values which satisfies the constraints
Y_ini=[];%
for i=1:1:4
   % Lower and upper bounds declaration
    lb=alphamin;
    ub=alphamax;
%     lb=[alpha1min alpha2min];
%     ub=[alpha1max alpha2max];
%     
    %%
    disp(i)
    alpha=alphamin+rand(1,1)*(alphamax-alphamin);%uniform distribution
    
     x_0=alpha;
    X_ini=[X_ini;x_0];
%options = optimoptions('fmincon','Algorithm','sqp'); % 'active-set'
 options = optimset('Algorithm','sqp','Display','final','TolX',1e-8,'TolCon',1e-8,'MaxIter',150);
%options = optimoptions('fmincon','Algorithm','interior-point');
%options = optimoptions('fmincon','Algorithm','active-set');
%     [x,fval,exitflag,output] = fmincon(@objfun_multi,x_0,[],[],[],[],[lb],[ub],@nonlconstr_multi,options);
    [x,fval,exitflag,output] = fmincon(@(x) objfun_multi(x),x_0,[],[],[],[],lb,ub,@nonlconstr_multi,options);
    X=[X;x];
    if(exitflag==1)
        Y_ini=[Y_ini;x_0];
        Y=[Y;x];
    end   
end      