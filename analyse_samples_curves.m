function analyse_samples_curves(cpwd,sensitivity,ramp_size,ratio,...
                 kk,rr,vv,angle,fit_limit,files,files_names,opt_plot,model)
%%%%%%%%%%   %loop over each sample data set     %%%%%%%%%%%%%%%%%%%%%
 for k = 1 : length(files)
    cd(files(k).folder)
    %load file name
    FileName = files_names{k};
   
    
    %if exist(strcat('new_',FileName(1:length(FileName)-4),'.fig')) ~= 2
    
        
        %load file data
    data=load(FileName);
    ramp_size=data.Ramp;
    cd(cpwd);
  %% curve analysis
  %
    %get approach and withdraw curves
    [zpiezo,...
    zpiezo_approach,v_approach,...
    zpiezo_withdraw,v_withdraw,i_peak,data]=get_curves(data,ramp_size);

    %%%%% analyse approach curve %%%%%

      %get baseline of dV curve
    v_baseline_a = get_base(zpiezo_approach,v_approach,zpiezo_approach,ratio);
    
      %predict contact point
    ref = mean(v_baseline_a(round(0.5*size(v_baseline_a,1)):size(v_baseline_a,1),1));
    [i_cp,z_cp]=contact_point(zpiezo_approach,v_approach,i_peak,ref);
%     %select range of contact approach
    zpiezo_approach_contact = approach_contact(i_cp,zpiezo_approach);
    v_approach_contact = approach_contact(i_cp,v_approach);

      %predict detachment point
    v_baseline_w = get_base(zpiezo_withdraw,v_withdraw,(zpiezo_withdraw),0.4*ratio);
    ref = mean(v_baseline_w,1);
    [i_dp ,z_dp]=detach_point(zpiezo_withdraw,v_withdraw,ref);

%     %select range of contact withdraw
    zpiezo_withdraw_contact = withdraw_contact(i_dp,zpiezo_withdraw);
    v_withdraw_contact = withdraw_contact(i_dp,v_withdraw);


  %get deflection curves
  def_approach = deflection_curve(sensitivity,v_baseline_a,v_approach);
  v_baseline_ac = v_baseline_a(i_cp:i_peak-1);
  def_approach_contact = deflection_curve(sensitivity,v_baseline_ac,v_approach_contact);

  def_withdraw = deflection_curve(sensitivity,v_baseline_w,v_withdraw);
  v_baseline_wc = v_baseline_w(1:i_dp-1);
  def_withdraw_contact = deflection_curve(sensitivity,(v_baseline_wc),v_withdraw_contact);
  
  def = [def_approach; def_withdraw];

  %get indentation curves     
  %ind_approach = indentation_curve(zpiezo_approach,def_approach,z_cp);
  %ind_withdraw = indentation_curve(zpiezo_withdraw,def_withdraw,z_cp);
  ind_approach_contact = indentation_curve(zpiezo_approach_contact,def_approach_contact,z_cp);
  %ind_withdraw_contact = indentation_curve(zpiezo_withdraw_contact,def_withdraw_contact,z_cp);
  
  
  %% hertz fitting
   % always done as a first iteration for the other contact models
   %inital guess: slope of portion of contact approach curve
    e0 = hertz_initial(zpiezo_approach_contact,ind_approach_contact,...
                        def_approach_contact,ratio,vv,kk,rr);
    %% run Hertz model: nonlinear fitting find young's modulus and adjusts contact point
   if strcmp(model,'Hertz')
    [eh,z_cp1,ind_lim,r2h]= hertz_fitting(e0,z_cp,kk,rr,vv,fit_limit,...
             zpiezo_approach_contact,...
             def_approach_contact);
      %convert to kPa
     ef=eh*(1e6); %kPa %!!!!!!!!!
      %update indentation curves with the new contact point
     ind_approach = indentation_curve(zpiezo_approach,def_approach,z_cp1);
     ind_withdraw = indentation_curve(zpiezo_withdraw,def_withdraw,z_cp1);
     [ ~, i_cp1 ] = min( abs( zpiezo_approach - z_cp1 ) );
     zpiezo_approach_contact = approach_contact(i_cp1,zpiezo_approach);
     v_approach_contact = approach_contact(i_cp1,v_approach);
     v_baseline_ac = v_baseline_a(i_cp1:i_peak-1);
     def_approach_contact = deflection_curve(sensitivity,v_baseline_ac,v_approach_contact);
     ind_approach_contact = indentation_curve(zpiezo_approach_contact,def_approach_contact,z_cp1);
         %
     ind_withdraw_contact = indentation_curve(zpiezo_withdraw_contact,def_withdraw_contact,z_cp1);
     
      %experimental measured force
     f_exp_ac=kk*def_approach;
     [ ~, i_lim ] = min( abs( ind_approach_contact-ind_lim ) );
          %force curve predicted by Hertz model
     ffit_hertz=contact_force_hertz(eh,vv,rr,ind_approach_contact(1:i_lim));
    end
  %%  Sneddon model
      if strcmp(model,'Sneddon')
      [es,z_cp1,ind_lim,r2s]= sneddon_fitting(e0,z_cp,kk,vv,angle,fit_limit,...
             zpiezo_approach_contact,...
             def_approach_contact);
      %convert to kPa
       eff=es*(1e6); %kPa %!!!!!!!!!
        %update indentation curves with the new contact point
     ind_approach = indentation_curve(zpiezo_approach,def_approach,z_cp1);
     ind_withdraw = indentation_curve(zpiezo_withdraw,def_withdraw,z_cp1);
     [ ~, i_cp1 ] = min( abs( zpiezo_approach - z_cp1 ) );
     zpiezo_approach_contact = approach_contact(i_cp1,zpiezo_approach);
     v_approach_contact = approach_contact(i_cp1,v_approach);
     v_baseline_ac = v_baseline_a(i_cp1:i_peak-1);
     def_approach_contact = deflection_curve(sensitivity,v_baseline_ac,v_approach_contact);
     ind_approach_contact = indentation_curve(zpiezo_approach_contact,def_approach_contact,z_cp1);
         %
     ind_withdraw_contact = indentation_curve(zpiezo_withdraw_contact,def_withdraw_contact,z_cp1);
     
       %experimental measured force
     f_exp_ac=kk*def_approach;
     
     [ ~, i_lim ] = min( abs( ind_approach_contact-ind_lim ) );
     ffit_sneddon=contact_force_sneddon(es,vv,angle,ind_approach_contact(1:i_lim));
       
      end
%% JKR fitting (unfinished)
     if strcmp(model,'JKR')
    %maximum value of force during detachment
     fad=kk*max(-def_withdraw_contact);
     %zero force point
     %i_f0 = find( abs(def_withdraw_contact) == min(abs(def_withdraw_contact)));
     i_f0 = 1;
     i_f1 = find( (def_withdraw_contact) == min((def_withdraw_contact)));
    % run JKR model: use only compressive portion of the retraction curve 
     [ej,dg,r22, ffit_jkr] = jkr_fitting(eh,fad,z_cp1,i_f0,i_f1,kk,rr,vv,...
          zpiezo_withdraw_contact,def_withdraw_contact);
     
      %convert to kPa
      eff=ej*(1e6);
      %experimental measured force
     f_exp_wc=kk*def_withdraw;
      %force curve predicted by JKR model
      %ffit_jkr=contact_force(ej,vv,rr,i_wc);
     % ffit_jkr=i_wc;
      %ffit_jkr=i_wc;
     end
    %% data storage
    %update data file with new fields
    %raw data
    data(:).zpiezo=zpiezo;
    data(:).zpiezo_approach=zpiezo_approach;
    data(:).zpiezo_withdraw=zpiezo_withdraw;
    data(:).v_approach=v_approach;
    data(:).v_withdraw=v_withdraw;
    %%contact part
    data(:).zCP=z_cp;
    data(:).zpiezo_approach_contact=zpiezo_approach_contact;
    data(:).v_approach_contact=v_approach_contact;
    data(:).zDP=z_dp;
    data(:).zpiezo_withdraw_contact=zpiezo_withdraw_contact;
    data(:).v_withdraw_contact=v_withdraw_contact;
    %deflection sensitivity
    data(:).sensitivity=sensitivity;
    % deflection
    data(:).def=def;
    data(:).def_approach=def_approach;
    data(:).def_withdraw=def_withdraw;
    data(:).def_approach_contact=def_approach_contact;
    data(:).def_withdraw_contact=def_withdraw_contact;
    % indentation
    data(:).ind_approach=ind_approach;
    data(:).ind_withdraw=ind_withdraw;
    data(:).ind_approach_contact=ind_approach_contact;
    data(:).ind_withdraw_contact=ind_withdraw_contact;
    % force and elastic modulus (Hertz contact model)
    if strcmp(model,'Hertz')
    data(:).fexpac=f_exp_ac;
    data(:).fhertz=ffit_hertz;
    data(:).ehertz=ef;
    data(:).r2hertz=r2h;
    data(:).z_cphertz=z_cp1;
    end
    % force and elastic modulus (Sneddon contact model)
    if strcmp(model,'Sneddon')
    data(:).fexp=f_exp_ac;
    data(:).ffit=ffit_sneddon;
    data(:).efit=real(eff);
    data(:).r2sneddon=real(r2s);
    data(:).c_cp=z_cp1;
    end
    % force, adhesion, and elastic modulus (JKR contact model)
    if strcmp(model,'JKR')
    data(:).fexp=f_exp_ac;
    data(:).ffit=ffit_jkr;
    data(:).efit=eff;
    data(:).c_cp=z_cp1;
    data(:).dgjkr=dg;
    end
    %save new data file with new fields
    cd(files(k).folder)
    save(strcat('new_',FileName(1:end-4),'.mat'), '-struct','data')
    cd(cpwd);

  %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%%%%% PLOTTING (OPTIONAL) %%%%%%%%%%%
      if opt_plot==1
        %plot approach and withdraw curves
        figure('visible', 'off'); 
        set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')
        subplot(2,4,[1 2]) %raw data curves
        plot_raw_data(zpiezo_approach,v_approach,zpiezo_withdraw,v_withdraw);
        hold on
        mark_cp(v_approach,i_cp,z_cp) %mark CP
%         subplot(2,4,2) %deflection curvs
%         plot_deflection_curves(zpiezo_approach,def_approach,...
%                             zpiezo_withdraw,def_withdraw);
%         hold on
%         mark_cp(def_approach,i_cp,z_cp)         %contact point
        
        subplot(2,4,[3 4]) %indentation curves
        plot_indentation_curves(ind_approach,def_approach,...
                    ind_withdraw,def_withdraw);
        subplot(2,4,[5 6 7 8]) %force indentation curve and fitting: hertz  
        if strcmp(model,'Hertz')
        plot_force_curves_hertz(ind_approach,f_exp_ac,ind_approach_contact(1:i_lim),ffit_hertz,ef,r2h);
        hold on
        %label_hertz(ef,r2h,f_exp_ac,ind_approach_contact)3
        %hold on
        end
        if strcmp(model,'Sneddon')
        plot_force_curves_sneddon(ind_approach,f_exp_ac,ind_approach_contact(1:i_lim),...
                                   ffit_sneddon,eff,r2s); 
        
        end
        if strcmp(model,'JKR')
        subplot(2,4,[7 8]) %force indentation curve and fitting  JKR
        plot_force_curves_jkr(ind_withdraw,f_exp_wc,ind_withdraw_contact(i_f0:i_f1),ffit_jkr);
        hold on
        label_jkr(eff,r22,f_exp_wc,ind_withdraw_contact)
        end
        %save to fig
        cd(files(k).folder);
        savefig(strcat('new_',FileName(1:end-4),'.fig'))
        close
        cd(cpwd);
      end
      
 end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %  end
end
