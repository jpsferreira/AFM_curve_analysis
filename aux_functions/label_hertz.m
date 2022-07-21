function label_hertz(e,r2,f_curve,ind_curve)


txt= ['E = ',num2str(e), ' kPa'];
    tt=text(0.8*min(ind_curve),0.8*max(f_curve),txt);
    tt.FontSize = 12;
    
txt= ['R^2 = ',num2str(r2)];
   tt=text(0.9*max(ind_curve),0.5*max(f_curve),txt);
   tt.FontSize = 12;
    
end