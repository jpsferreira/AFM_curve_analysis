clear all;
clc;

cd sample/

testFiles = dir( fullfile('new_pp_cell_11*.mat') );
testNames = { testFiles.name };

%initialize the array with data
%c(i,j) cell i curve j ; k=i*j
i=0;
j=1;
cells(1)=0;
for count=1:length(testNames)
    file_name = testNames{count};

        cell_id=file_name(13:14);
        cell_id=str2double(cell_id);
     
        
        curve_id=file_name(size(file_name,2)-6:size(file_name,2)-4);
        curve_id=str2double(curve_id);
        
        data=load(file_name);
         
        %fitting quality verification
         rrr2=data.r2sneddon;
         r2min=0.945;
         
        
         rr2_0(cell_id,curve_id+1)=real(data.r2sneddon);
         
        
         %drop bad fittings 
        %if isreal(rrr2) && real(rrr2) > r2min
        if real(rrr2) > r2min
         rr2(cell_id,curve_id+1)=data.r2sneddon;
         elastic_modulus(cell_id,curve_id+1)=real(data.efit);
        end
  
end
        rr2(rr2 == 0) = NaN; 
        curves_per_cell=sum(rr2_0~=0,2) ;
        curves_per_cell_to_eval=sum(~isnan(rr2),2);
        accept_rate=curves_per_cell_to_eval.*(curves_per_cell).^(-1) ;
        reject_rate=1-accept_rate;
        

        
        
        %filter only good results
        for i=1:size(rr2,1)
            for j=1:size(rr2,2)
                if isnan(rr2(i,j))
                    elastic_modulus(i,j) = NaN ;
                end 
            end
        end
        
%            figure
%          for i = 1:size(elastic_modulus,1)
%          str{i}=strcat('Cell ',sprintf('%i',i));
%          tticks(i)= i;
%          scatter(repmat(i,1,size(elastic_modulus,2)),elastic_modulus(i,:),'*');
%          hold on
%          end
%         
%         xlabel('Cell ID ');
%         ylabel('Elastic Modulus (kPa)');
%         xticks(tticks);
        
       % xticklabels(str)
       type='Normal';
   
       
       pool = reshape(elastic_modulus' ,[],1);    
    pool = pool(~isnan(pool));
% 
    is_pool_normal= checknormal(pool',0.05);
    type='Normal';
    pool_dist=fitdist(pool,type);
    
    
        count=0;
       all = [];
      for i = 1:size(elastic_modulus,1)
         clean_elatic_modulus=elastic_modulus(i,find(~isnan(elastic_modulus(i,:))));
         if size(clean_elatic_modulus,2) > 10
            check_if_normal=checknormal(clean_elatic_modulus,0.05);
            if check_if_normal == 'normal dist'
                count=count+1;
              elastic_dist=fitdist(clean_elatic_modulus',type);
              all=[all; clean_elatic_modulus'];
              y(count)=elastic_dist.mu;
              e(count)=elastic_dist.sigma;
              ttick(count)=count;
              c(count)=NaN;
              
            end
         end
      end
    
    all_dist=fitdist(all,type);
      
    figure
    y_all=c;
    y_all(round(.5*size(c,2)))=all_dist.mu;
    e_all=c;
    e_all(round(.5*size(c,2)))=all_dist.sigma;
    yy=[y'; y_all'];
    ee=[e'; e_all'];
    superbar(yy, 'E', ee );
    xlabel('Cell ID ');
    ylabel('Elastic Modulus (kPa)');
    xticks(ttick);
    
% 
       % Plot histogram fitting
%  bins=40;
%  var='Elastic modulus';
%  g1='Knockout';
%  g2='Wildtype';
%  %plothistograms(feret_ko_n,feret_wt_n,bins,type,var,g1,g2)

%     
%  cd sample/
%  wt_files = dir( fullfile('new_p*.mat') );
%  wt_names = { wt_files.name };
%  
%  ko_files = dir( fullfile('new_p*.mat') );
%  ko_names = { ko_files.name };
% 
%  cd(cpwd)
%  
%  e_wt=zeros(length(wt_files),1);
%     
%  for k = 1 : length(wt_files)
%     cd(wt_files(k).folder)
%     %load file name
%     file_name = wt_names{k};
% 
%     %load file data
%     data=load(file_name);
%     cd(cpwd);
%     e_wt(k)=data.ehertz;
%  end
%  
%  e_ko=zeros(length(ko_files),1);
%     
%  for k = 1 : length(ko_files)
%     cd(ko_files(k).folder)
%     %load file name
%     file_name = ko_names{k};
% 
%     %load file data
%     data=load(file_name);
%     cd(cpwd);
%     e_ko(k)=data.ehertz;
%  end
%  
%  is_same_var=checksamevariance(e_wt,e_ko,0.05);
%  is_e_wt_normal= checknormal(e_wt',0.05);
%  is_same_ehertz = checksame(e_wt,e_ko,0.05);
%  
% %lognfit(feret_ko)
%  %lognfit(feret_wt)
%  type='Normal';
%   % Plot histogram fitting
%  bins=40;
%  var='Elastic modulus';
%  g1='Knockout';
%  g2='Wildtype';
%  %plothistograms(feret_ko_n,feret_wt_n,bins,type,var,g1,g2)
%   
%  
%  % Plot ehertz Distribution
%  e_ko_dist=fitdist(e_ko,type);
%  e_wt_dist=fitdist(e_wt,type);
%  
%  %xc_values = 0:1.0:2*e_ko_dist.mu;
%  xc_values = linspace(0,2*e_ko_dist.mu);
%  groups=[{'Knockout'},{'Wild'}];
%  xlbl={'E_{hertz}'};
%  plotdisp(e_ko_dist,e_wt_dist,xc_values,groups,xlbl)
%  
%  
%  % Plot E_mod Bars
%   figure
%   hold on
%   
%   e_avg_n=[e_wt_dist.mu,e_ko_dist.mu];
%   e_dev_n=[e_wt_dist.sigma,e_ko_dist.sigma];
%  
%   x=[1,2];
%   bar(x,cat(2,e_avg_n));
%   errorbar(x,cat(2,e_avg_n), cat(2,e_dev_n),'.');
%   xticks([x])
%   xticklabels({'Wild','Knockout'})
%   ylabel('E_{hertz}','fontsize',14)
%   groups={[1],[2]};
%   hold on
 % H=sigstar(groups,[0.001,0.001]);
 % figLabel = {'N: Normoxic. H: Hypoxic. KO: Knockout. WT: Wildtype.'};
 %   dim = [0.1, 0.07, 0, 0];
 %   annotation('textbox', dim, 'String', figLabel, 'FitBoxToText', 'on', 'LineStyle', 'none','fontsize',14);
  

function [out] = checknormal(data,alpha_val)
 %if kstest(data) == 1
 pp=fitdist(data','Normal');
 if ttest(data,pp.mu,'alpha',alpha_val) == 1
     out = 'not a normal dist';
 else
     out = 'normal dist';
 end    
end 

function [out] = checksame(data1,data2,alpha_val)
 %if kstest2(data1,data2) == 1
 if ttest2(data1,data2,'alpha',alpha_val) == 1
     out = 'not the same dist';
 else
     out = 'same dist';
 end    
end 
function [out] = checksamevariance(data1,data2,alpha_val)
 if vartest2(data1,data2,'alpha',alpha_val) == 1
     out = 'not the same variance';
 else
     out = 'same dist variance';
 end    
end 
function [] = plotdisp(dist1,dist2,x_values,groups,xlbl)
%
 pdfdist1=pdf(dist1,x_values);
 pdfdist2=pdf(dist2,x_values);
figure
plot(x_values,pdfdist1,'LineWidth',2)
hold on
plot(x_values,pdfdist2,'Color','r','LineStyle',':','LineWidth',2)
legend(groups,'Location','NorthEast')
xlabel(xlbl)
hold off

end

function [] = plothistograms(dist1,dist2,bins,type,var,g1,g2)
f=figure ;
p = uipanel('Parent',f,'BorderType','none'); 
p.Title = var;
p.TitlePosition = 'centertop'; 
p.FontSize = 12;
p.FontWeight = 'bold';
ax1 = subplot(2,1,1,'Parent',p);
histfit (dist1,bins,type)
title(g1)
hold on
ax2 = subplot(2,1,2,'Parent',p);
histfit (dist2,bins,type)
title(g2)
hold off

end