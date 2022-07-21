function [d]=deflection_curve(sens,baseline,v)

d=sens*(v-baseline);

end

% function [d,d_a,d_w,d_ac,d_wc] = get_deflection_curves( ...
%             sens,v_a,v_w,icp,ipeak)
% 
%         
% v_point=findchangepts(sgolayfilt(v_a,0,9),...
%                 'Statistic', 'mean', 'MaxNumChanges',1);
% baseline=mean(v_approach(1:v_point));
% 
% d_a=sens*(v_a-baseline);
% d_w=sens*(v_w-baseline);
% d=[d_a;d_w];
% 
% end

