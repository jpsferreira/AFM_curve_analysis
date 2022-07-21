function sens = analyse_sensitivity_curves(cpwd,ramp_size,ratio,...
                                          files,files_names,opt_plot)
    sens=zeros(length(files),1);
%%%%%%%%%%   %loop over each sensitivity data set     %%%%%%%%%%%%%%%%%%%%%
    for k = 1 : length(files)
    cd(files(k).folder)
    %load file name
    FileName = files_names{k};
    %load file data
    data=load(FileName);
    ramp_size=data.Ramp;
    
    cd(cpwd);
    %get approach and withdraw curves
    [zpiezo,...
    zpiezo_approach,v_approach_raw,...
    zpiezo_withdraw,v_withdraw_raw,i_peak,data]=get_curves(data,ramp_size);

        %remove drift and offset curves
   % v_approach=detrend(v_approach_raw,1);
   % v_withdraw=detrend(v_withdraw_raw,1);
    v_approach=v_approach_raw;
    v_withdraw=v_withdraw_raw;
    
    %v_approach_raw=detrend(v_approach_raw,0);
    %v_withdraw_raw=detrend(v_withdraw_raw,0);
    
    %get baseline of dV curve
    curve_baseline_a = get_base(zpiezo_approach,v_approach,zpiezo_approach,ratio); 
    
     %predict contact point
     %ref=mean(curve_baseline_a,1);
     ref = mean(curve_baseline_a(round(0.5*size(curve_baseline_a,1)):size(curve_baseline_a,1),1));
    [i_cp,Z_glass]=contact_point_glass(zpiezo_approach,v_approach,i_peak,ref);

     %select range of contact approach
    zpiezo_approach_contact = approach_contact(i_cp,zpiezo_approach);
    v_approach_contact = approach_contact(i_cp,v_approach);

    %linear fit
         %only a fraction of the curve is used
    b=round(size(zpiezo_approach_contact,1)*ratio*0.5);
    
    %intermediate portion
    x_eval=zpiezo_approach_contact(b:size(zpiezo_approach_contact,1)-b);
    y_eval=v_approach_contact(b:size(v_approach_contact,1)-b);
    
    %last portion 
   % x_eval=zpiezo_approach_contact(size(zpiezo_approach_contact,1)-b:size(zpiezo_approach_contact,1));
   % y_eval=v_approach_contact(size(v_approach_contact,1)-b:size(v_approach_contact,1));
         
    [slope,yfit]=linear_fit(x_eval,y_eval);
    sensitivity=1/slope;
    sens(k)=sensitivity;
    
    %predict detachment point
    curve_baseline_w = get_base(zpiezo_approach,v_approach, ...
                  flip(zpiezo_withdraw),ratio);
              
    ref = mean(curve_baseline_w,1);
    [i_dp ,z_dglass]=detach_point(zpiezo_withdraw,v_withdraw,ref);

    %select range of contact withdraw
    zpiezo_withdraw_contact = withdraw_contact(i_dp,zpiezo_withdraw);
    v_withdraw_contact = withdraw_contact(i_dp,v_withdraw);
  
  
  %get deflection curves
    def_approach = deflection_curve(sensitivity,curve_baseline_a,v_approach);
    def_approach=detrend(def_approach,1); %remove drift
    curve_baseline_ac = curve_baseline_a(i_cp:i_peak-1);
    def_approach_contact = deflection_curve(sensitivity,curve_baseline_ac,v_approach_contact);
    def_approach_contact=detrend(def_approach_contact,1);

    def_withdraw = deflection_curve(sensitivity,curve_baseline_w,v_withdraw);
    def_withdraw=detrend(def_withdraw,1);
    curve_baseline_wc = curve_baseline_w(1:i_dp-1);
    def_withdraw_contact = deflection_curve(sensitivity,curve_baseline_wc,v_withdraw_contact);
    def_withdraw_contact=detrend(def_withdraw_contact,1);
    
    def = [def_approach; def_withdraw];
    
   
    %update data file with new fields
    data(:).zpiezo=zpiezo;
    data(:).zpiezo_approach=zpiezo_approach;
    data(:).zpiezo_withdraw=zpiezo_withdraw;
    data(:).v_approach=v_approach;
    data(:).v_withdraw=v_withdraw;
    %
    data(:).zCP=Z_glass;
    data(:).zpiezo_approach_contact=zpiezo_approach_contact;
    data(:).v_approach_contact=v_approach_contact;
    data(:).zDP=z_dglass;
    data(:).zpiezo_withdraw_contact=zpiezo_withdraw_contact;
    %
    data(:).sensitivity=sensitivity;
    %
    data(:).def=def;
    data(:).def_approach=def_approach;
    data(:).def_withdraw=def_withdraw;
    data(:).def_approach_contact=def_approach_contact;
    data(:).def_withdraw_contact=def_withdraw_contact;

    
    %save new data file with new fields
    cd(files(k).folder);
    save(strcat('new_',FileName(1:end-4),'.mat'), '-struct','data')
    cd(cpwd);
     %%%%%% PLOTTING (OPTIONAL) %%%%%%%%%%%
      if opt_plot==1
        %plot approach and withdraw curves
        figure('visible', 'off'); %DV-ZP
        set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
        subplot(2,1,1)
        plot_raw_data(zpiezo_approach,v_approach_raw,...
                        zpiezo_withdraw,v_withdraw_raw);
        hold on
        %mark CP, sensitivity value,linear fitting
        mark_cp(v_approach_raw,i_cp,Z_glass)
        hold on
        label_sensitivity(sensitivity,v_withdraw_raw,ramp_size);
        hold on
        draw_fit_line(x_eval,yfit)
        subplot(2,1,2)
        plot_deflection_curves(zpiezo_approach,def_approach,...
                            zpiezo_withdraw,def_withdraw);
        hold on
        mark_cp(def_approach,i_cp,Z_glass)
        
        cd(files(k).folder);
        savefig(strcat('new_',FileName(1:end-4),'.fig'))
        close
        cd(cpwd);
      end

    end
end