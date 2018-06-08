% written by hao (ver_18.06.08)
% rock3.hao@gmail.com
% qinlab.BNU
restoredefaultpath
clear

%% Set Up
spm_dir    = '/Users/haol/Dropbox/Toolbox/spm12';
firlv_dir  = '/Users/haol/Downloads/scr_test/FirstLv/FirstLv_3Cond';
seclv_dir  = '/Users/haol/Downloads/scr_test/SecLv';
script_dir = '/Users/haol/Dropbox/Codes/Image/univar_acti/seclv_spm12';
subjlist   = fullfile (script_dir, 'list_multireg.txt');

task_name  = 'ANT';
tconweig   = [0 0 1];
res_folder = 'MultiReg_CBDC';
cond_name  = {'Alert'; 'Orient'; 'Conflict'};

%% Run Second Level
addpath (genpath (spm_dir));
addpath (genpath (script_dir));
load (fullfile (script_dir,'depend','seclv_multireg.mat'));

subtab = readtable(subjlist,'Delimiter','\t');
[rowi,coli] = size(subtab);
sublist = table2array(subtab(:,1));

for col_i = 2:coli
matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov(col_i-1).c = table2array(subtab(:,col_i));
matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov(col_i-1).cname = subtab.Properties.VariableNames{col_i};
matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov(col_i-1).iCC = 1;
end

for i = 1:length(cond_name)
    con_name = cond_name{i};
    imgdir = {};
    for j = 1:length(sublist)
        yearID = ['20', sublist{j,1}(1:2)];
        imgdir{j,1} = fullfile (firlv_dir, yearID, sublist{j,1}, ...
            ['fmri/stats_spm12/', task_name, '/stats_spm12_swcar'], ...
            ['con_000', num2str(i), '.nii']); %#ok<*SAGROW>
    end
    res_save_dir = fullfile (seclv_dir, res_folder, cond_name{i});
    
    run (fullfile (script_dir, 'depend', 'seclv_multireg.m'));
end

%% Analysis Done
disp ('=== Second Level Analysis Done ===');
