function [ind_dp,dp] = detach_point(z_w,d_w, ref )

    ll=size(z_w,1);
    %guess initial contact interval
      slope=zeros(ll-2,1);
      
      for i=ll-1:-1:1
        slope(i)=d_w(i+1)-d_w(i);
      end
      pts=findchangepts(...
        sgolayfilt(slope,0,9), ...
         'Statistic', 'mean', 'MaxNumChanges',2);


        %predict detach point
        delta = -1000;
        n = find(d_w == min(d_w)) ;
        ind_dp = n;
        dp = z_w(ind_dp);
%         while (delta <= ref) && (n >=pts(1)-2)
%             ind_dp = n ;
%             delta = d_w(n);
%             n = n + 1;
%         end
%     
%         dp = z_w(ind_dp);
end

% function [indDP,DP, pts] = detach_point(z_w,v_w, indPeak )
%     %predict detachment point using sgolay filter (CP)
% slope=zeros(indPeak-2,1);
% for i=indPeak-1:-1:1
%     slope(i)=v_w(i+1)-v_w(i);
% end
% pts=findchangepts(...
%    sgolayfilt(slope,0,9), ...
%     'Statistic', 'mean', 'MaxNumChanges',2);   

% indDP=round(mean(pts));
% DP=z_w(indDP);


% end