function [ind_cp,cp] = contact_point_glass(z_a,d_a, indPeak, ref)
    
    %guess initial contact interval
      slope=zeros(indPeak-2,1);
      for i=1:indPeak-2
        slope(i)=d_a(i+1)-d_a(i);
      end
%       pts=findchangepts(...
%         sgolayfilt( smooth(slope,0.1,'rloess') ,0,9), ...
%          'Statistic', 'mean', 'MaxNumChanges',2);
     
     pts = findchangepts(...
        sgolayfilt( slope ,0,9), ...
         'Statistic', 'mean', 'MaxNumChanges',2);
    
        
%         %predict contact point
        delta = 1000;
        n = indPeak-1;
        while ((delta >= ref) && (n >= pts(1)))
            delta = d_a(n);
            ind_cp = n;
            n = n - 1;
        end
    
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