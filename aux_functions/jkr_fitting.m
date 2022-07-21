function [ej,dg,r2,f_wc] = jkr_fitting(e0,fad0,cp0,i0,i1,kk,rr,vv,z_wc,d_wc)
    %valid only for:
    %compliant samples
    %large radius
    %high adhesion forces


    dg0=fad0*2/(3*rr);
    x0=[e0, dg0];
    
    corr=(4/3)/(1-vv*vv);
    dd_wc=d_wc(i0:i1);
    zz_wc=z_wc(i0:i1);
    
    %dd_wc=dd_wc-dd_wc(1);
    %zz_wc=zz_wc-zz_wc(1);
    %dd_wc=fliplr(-dd_wc);
    %zz_wc=fliplr(-zz_wc);
    % model parameters
% elastic modulus : c(1)
% interfacial energy : c(2)

% adhesive force
 fad = @(c,x) (3*pi()/2)*rr*c(2);
% cantilever force
 f = @(c,x) (kk*x);
% contact radius
%  a   = @(c,x) ( (p(2)/(.75*c(1))) * (  (  fad(c,x)  )^(0.5) ...
%                     +  ( f(c,x) + fad(c,x) ).^(0.5)  ).^2).^(0.5);

a   = @(c,x) ( (rr/((corr)*c(1))) * (f(c,x) + 2*fad(c,x) + ...
             (4*fad(c,x)*f(c,x) + (2*fad(c,x))^2).^(0.5) )).^(0.333333);
 %indentation
 ind   = @(c,x) (a(c,x).^2)/rr-(4/3)*(...
                         fad(c,x).*a(c,x)/(rr*(corr)*c(1))  ).^(0.5);
  %ind = @(c,x) (a(c,x).^2)/rr-(...
   %                      2*pi()*c(2)*a(c,x)/((corr)*c(1))  ).^(0.5);
  %ind   = @(c,x) (a(c,x).^2)/(3*rr)+a(c,x).^2*4*corr/(6*rr);
  
 % ind = @(c,x) (a(c,x).^2)/(3*rr) + 2*f(c,x).*(3*a(c,x)*corr*c(1)).^(-1);
  
 %JKRforce =    @(c,x) (4/3)*c(1)*a(c,dd_wc).^3/rr-2*a(c,x)*c(1).*(...
 %                        2*pi()*c(2)*a(c,x)/((corr)*c(1))  ).^(0.5);
 JKRforce = @(c,x) (corr*c(1)*a(c,x).^3)/(rr)-sqrt(8*pi()*c(2)*corr*c(1)*(3/4)*a(c,x).^3);
 %JKR model
 JKRModel = @(c,x) cp0 + ind(c,x) + x;


%
 ffit = nlinfit(dd_wc, zz_wc, JKRModel, x0);
 %ffit = nlinfit(dd_wc, kk*dd_wc, JKRModelf, x0);
 %
ej=ffit(1);
dg=ffit(2);
 % 
 %i_wc = ind(ffit,dd_wc);
 %i_wc = a(ffit,dd_wc).^3*(4/3)*ej/rr;
 %i_wc = (ej/rr)*(4/3)*a(ffit,dd_wc).^3-2*pi()*dg*rr;
 %i_wc = kk*(zz_wc-cp0-dd_wc)-sqrt(8*pi()*ej*dg*a(ffit,dd_wc).^4.*(ind(ffit,dd_wc)).^(-1));
 %a_wc = (ej/rr)*a(ffit,dd_wc).^3;
 
 %f_wc = JKRforce(ffit,dd_wc);
 %f_wc = smooth(JKRforce(ffit,dd_wc))
 vect = a(ffit,dd_wc);
 domain = linspace(vect(1),vect(size(vect,1)),size(vect,1));
 f_wc = (corr*ej*domain.^3)/(rr)-sqrt(8*pi()*dg*corr*ej*(3/4)*domain.^3);
 %f_wc = (3/4)*ej*a(ffit,dd_wc).^3/rr;
 %
r2=rsquare(zz_wc,JKRModel(ffit,dd_wc),true);
%
end