function [ff] = contact_force_sneddon(e,vv,angle,ind)

    aux=(1/(1-vv*vv))*tan(deg2rad(angle))*2/pi();
    ff=e*aux*((ind).^(2.0));
  
end