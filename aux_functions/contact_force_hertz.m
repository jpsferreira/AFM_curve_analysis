function [ff] = contact_force_hertz(e,vv,rr,ind)

    aux=(4/3)*(1/(1-vv*vv))*rr^(0.5);
    ff=e*aux*((ind).^(1.5));
  
end