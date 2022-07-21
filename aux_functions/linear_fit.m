function [slope,yfit] = linear_fit(x,y)

 %X = [ones(size(x,1),1), x];
 % coeff = X\y;
    % slope = coeff(2);
 
 %scatter(x,y,'b','*') 

 p = polyfit(x,y,1);
% hold on
 yfit = p(1)*x+p(2);
% plot(x,yfit,'r-.');
 %   hold on
% plot(x(20:60),yfit(20:60)+0.1*mean(yfit),'b-.');
 
 slope=p(1);
 
end