function [e,cp,ind_limit,r2] = hertz_fitting(e0,cp0,kk,r,vp,limit,z_ac,d_ac)

%initial guess
x0=[e0, cp0];
%aux_variable
aux=(4/3)*(1/(1-vp*vp))*r^(0.5);
aux2=aux^(2);

%sz=round(0.5*ratio*size(d_ac,1))
%remove negative deflection values
% z_ac=z_ac(find ((d_ac > 0)));
% d_ac=d_ac(find ((d_ac > 0)));
%experimental measured force
f_exp=kk*d_ac;
[ ~, f_limit ] = min( abs( f_exp-limit ) );
f_exp=f_exp(1:f_limit);
f_exp2=f_exp.^(2);

%ind_ac=z_ac-cp0-d_ac;
x_ac=z_ac-d_ac;
x_ac=x_ac(1:f_limit);

HertzianModel =  @(a,x) aux2* ( a(1)^(2) )*(x-a(2)).^(3);
ffit = nlinfit(x_ac, f_exp2, HertzianModel, x0);
 
e=ffit(1);
cp=ffit(2);
 
r2=rsquare(f_exp2,HertzianModel(ffit,x_ac),true);

ind_limit=x_ac(f_limit)-cp;



% take a look at this!!!! https://www.mathworks.com/help/stats/nlpredci.html
 
 % fixed contact point
 
 %HertzianModel = fittype( @(E,x) aux2*E*E*x.^3 );

%ffit = fit(ind_ac, f_exp2, HertzianModel,'StartPoint', e0);
 
 %r2=rsquare(kk*d_ac,real(aux*e*ind_ac.^(1.5)),true);
%  
%   e=ffit(1);
%   cp=cp0;
    
end