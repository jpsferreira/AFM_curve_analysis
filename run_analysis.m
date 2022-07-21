%%%%%%%%%%%%%%%%%%%%%%%%     %initializations      %%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear all;
warning off;
addpath('./sensitivity');
addpath('./sample');
addpath('./aux_functions');
%%%%%%%%%%%%%%%%%%%%%%%%     %working parameters   %%%%%%%%%%%%%%%%%%%%%%%%
ramp_size=1000; %nm
ratio=0.5; %50% of the contact approach curve is used for linear fitting
spring_constant=0.01; %(nN/nm)
probe_radius = 1980/2; %(nm)
v_poisson=0.5;
angle=17.5; %MLCT veeco probe
model = 'Hertz';
%model = 'Sneddon';
%model = 'JKR';
fit_limit = 0.5; %(nN)
%%
%%%%%%%%%%% %read data file names in current directory  %%%%%%%%%%%%%%%%%%%
%mat files retrieved from Nanoscope software
%     struct.Tstart
%     struct.Tinterval
%     struct.ExtraSamples
%     struct.RequestedLength
%     struct.Length
%     struct.A
%     struct.Version


%find all mat files from current base directory
%sensitivity calibration files
cpwd=pwd;
cd sensitivity/
sensitivityFiles = dir( fullfile('ss*.mat') );
sensitivityNames = { sensitivityFiles.name };
sens_wd=strcat(cpwd,'/sensitivity/');
cd(cpwd)
cd sample/
sample_wd=strcat(cpwd,'/sample/');
%
     %sample test files
testFiles = dir( fullfile('pp_*.mat') );
testNames = { testFiles.name };
cd(cpwd)
%% sensitivity data set
opt_plot=1; %option to--> 1: plot | 0: do not plot
sensitivity=analyse_sensitivity_curves(cpwd,ramp_size,ratio,...
           sensitivityFiles,sensitivityNames,opt_plot);
cd(cpwd)
% save(strcat('new_','sensitivity','.mat'),'sensitivity');
sens=mean(sensitivity,1);

 %% samples data set
opt_plot=1;
sens=mean(sensitivity,1);
%sens=9.75;
%sens=30;
%ramp_size = 1000;
analyse_samples_curves(cpwd,sens,ramp_size,ratio,...
                       spring_constant,probe_radius,v_poisson,angle,fit_limit,...
                       testFiles,testNames,opt_plot,model)
cd(cpwd)
%% analyse results

 %sample test results
%cd(cpwd)
%run_statistics()

