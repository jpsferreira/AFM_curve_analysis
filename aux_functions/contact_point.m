function [ind_cp,cp] = contact_point(z_a,d_a, indPeak, ref)
    

        start_pt=round(size(d_a,1)*0.5);
        end_pt=round(size(d_a,1));
      pts=findchangepts(...
        sgolayfilt( smooth(diff(d_a(start_pt:end_pt)),0.1,'rloess') ,0,9), ...
         'Statistic', 'mean', 'MaxNumChanges',2);
%     
% %         n = find(d_a == min(d_a)) ;
% %         ind_cp = max(n);
% %         cp = z_a(ind_cp);
%         %predict contact point
%         delta = 1000;
%         n = indPeak-1;
%         while ((delta >= ref) && (n >= pts(1)-20))
%             delta = d_a(n);
%             ind_cp = n;
%             n = n - 1;
%         end
            
        pp=start_pt+pts(1);
        ind_cp=max(find(d_a==min(d_a(round(0.5*pp):pp))));
        
        cp = z_a(ind_cp);
end

% function [indCP,CP, pts] = contact_point(z_a,v_a, indPeak )
%     %predict contact point using sgolay filter (CP)
% slope=zeros(indPeak-2,1);
% for i=1:indPeak-2
%     slope(i)=v_a(i+1)-v_a(i);
% end
% pts=findchangepts(...
%    sgolayfilt(slope,0,9), ...
%     'Statistic', 'mean', 'MaxNumChanges',2);   

% indCP=round(mean(pts));
% CP=z_a(indCP);


% end