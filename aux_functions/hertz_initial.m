function e0 = hertz_initial(z_ac,i_ac,d_ac, ratio,vv,kk,rr)

    b=round(size(z_ac,1)*ratio*.5);
    i_min = i_ac(b);
    i_max = i_ac(size(i_ac,1)-b);
    d_min = d_ac(b);
    d_max = d_ac(size(d_ac,1)-b);
    
    aux=(4/3)*(1/(1-vv*vv))*rr^(0.5);
    e_min = (kk*d_min/aux)*(i_min^(-1.5));
    e_max = (kk*d_max/aux)*(i_max^(-1.5));
    
    %initial guess for the hertz fitting
    e0=0.5*(e_min+e_max);
end 