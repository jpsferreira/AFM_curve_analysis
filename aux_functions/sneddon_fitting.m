function [e,cp,ind_limit,r2] = sneddon_fitting(e0,cp0,kk,vp,angle,limit,z_ac,d_ac)

%initial guess
x0=[e0, cp0];

%aux_variable
aux=(1/(1-vp*vp))*tan(deg2rad(angle))*2/pi();
%aux2=aux^(0.5);

%ind_ac=z_ac-cp0-d_ac;
x_ac=z_ac-d_ac;

%remove negative indentations from fitting
%ind_ac=ind_ac(find(ind_ac>=0));

%experimental measured force
f_exp=kk*d_ac;
%limit fitting region
[ ~, f_limit ] = min( abs( f_exp-limit ) );
f_exp=f_exp(1:f_limit);
%f_exp2=f_exp.^(0.5);

x_ac=x_ac(1:f_limit);

SneddonModel =  @(a,x) aux* (  a(1)  ) * (x-a(2)).^2.0;


ffit = nlinfit(x_ac, f_exp, SneddonModel, x0);
 
e=ffit(1);
cp=ffit(2);
 
r2=rsquare(f_exp,SneddonModel(ffit,x_ac),true);

ind_limit=x_ac(f_limit)-cp;

% take a look at this!!!! https://www.mathworks.com/help/stats/nlpredci.html
    
end