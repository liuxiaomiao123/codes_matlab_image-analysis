% written by hao (ver_18.06.05)
% rock3.hao@gmail.com
% qinlab.BNU
clear
restoredefaultpath

%% Set Up
spm_dir    = '/Users/haol/Dropbox/Toolbox/spm12';
firlv_dir  = '/Users/haol/Downloads/scr_test/FirstLv/FirstLv_3Cond';
seclv_dir  = '/Users/haol/Downloads/scr_test/SecLv';
script_dir = '/Users/haol/Dropbox/Codes/Image/univar_acti/seclv_spm12';
subjlist   = fullfile(script_dir,'list_test.txt');

task_name  = 'ANT';
res_folder = 'OneANOVA_CBDC_CondDep';
cond_name  = {'Alert';'Orient';'Conflict'};
cond_contr = [1,0,0; 0,1,0; 0,0,1];
cond_dep   = 1; % dep:1 & indep:0

%% Run Second Level
addpath ( genpath (spm_dir));
addpath ( genpath (script_dir));
load (fullfile (script_dir,'depend','seclv_1anova.mat'));

fid = fopen(subjlist); sublist = {}; cntlist = 1;
while ~feof(fid)
    linedata = textscan(fgetl(fid), '%s', 'Delimiter', '\t');
    sublist(cntlist,:) = linedata{1}; cntlist = cntlist + 1; %#ok<*SAGROW>
end
fclose(fid);

imgdir = {};
for i = 1:length(cond_name)
    for j = 1:length(sublist)
        yearID = ['20', sublist{j,1}(1:2)];
        imgdir{j,i} = fullfile(firlv_dir, yearID, sublist{j,1},...
            ['fmri/stats_spm12/', task_name, '/stats_spm12_swcar'], ...
            ['con_000',num2str(i),'.nii']); %#ok<*AGROW>
    end
    
    matlabbatch{1}.spm.stats.factorial_design.des.anova.icell(i).scans = imgdir(:,i);
    
    matlabbatch{3}.spm.stats.con.consess{i}.tcon.name = cond_name{i,1};
    matlabbatch{3}.spm.stats.con.consess{i}.tcon.weights = cond_contr(i,:);
    matlabbatch{3}.spm.stats.con.consess{i}.tcon.sessrep = 'none';
end
res_dir = fullfile (seclv_dir, res_folder);
run (fullfile(script_dir,'depend','seclv_1anova.m'));

%% Analysis Done
disp('=== Second Level Analysis Done ===');
