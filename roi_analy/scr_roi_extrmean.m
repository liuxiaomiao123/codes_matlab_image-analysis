% written by hao (ver_18.06.06)
% rock3.hao@gmail.com
% qinlab.BNU
restoredefaultpath
clear

%% Set up
roi_form  = 'nii';
img_type  = 'spmT';
task_name = 'ANT';
con_name  = {'alert';'orient';'conflict'};
con_num   = {'1'    ;     '2';       '3'};

spm_dir   = '/Users/haol/Dropbox/Toolbox/spm12';
roi_dir   = '/Users/haol/Downloads/scr_test/ROI/NeuroSynth_Fan';
firlv_dir = '/Users/haol/Downloads/scr_test/FirstLv/FirstLv_3Cond';
subj_list = '/Users/haol/Dropbox/Codes/Image/roi_analy/list_test.txt';

%% ===================================================================== %%
% Add Path
addpath(genpath(spm_dir));

% Acquire Subject list
fid  = fopen (subj_list); subj = {}; Cnt  = 1;
while ~feof (fid)
    linedata = textscan (fgetl (fid), '%s', 'Delimiter', '\t');
    subj (Cnt,:) = linedata{1}; Cnt = Cnt + 1; %#ok<*SAGROW>
end
fclose (fid);

% Acquire ROI file & list
roi_list = dir (fullfile (roi_dir, ['*.', roi_form]));
roi_list = struct2cell (roi_list);
roi_list = roi_list(1, :)';

%% Extract Mean Value
for con_i = 1:length(con_name)
    mean = {'Scan_ID'};
    for roi_i = 1:length(roi_list)
        mean{1,roi_i+1} = roi_list{roi_i,1}(1:end-4);
        roifile = fullfile(roi_dir, roi_list{roi_i,1});
        for sub_i = 1:length(subj)
            YearID = ['20', subj{sub_i,1}(1:2)];
            subjfile = fullfile (firlv_dir, YearID, subj{sub_i,1}, ...
                ['/fmri/stats_spm12/',task_name,'/stats_spm12_swcar/'], ...
                [img_type,'_000',con_num{con_i,1},'.nii']);
            mean{sub_i+1,1} = subj{sub_i,1};
            if strcmp(roi_form, 'nii')
                mean{sub_i+1,roi_i+1} = rex(subjfile,roifile);
            end
            if strcmp(roi_form, 'mat')
                roi_obj = maroi(roifile);
                roi_data = get_marsy(roi_obj, subjfile, 'mean');
                mean{sub_i+1,roi_i+1} = summary_data(roi_data);
            end
        end
    end
    
    %% Save Results
    save_name = ['res_extrmean_', con_name{con_i}, '_', img_type,'.csv'];
    
    fid = fopen(save_name, 'w');
    [nrows,ncols] = size(mean);
    col_num = '%s';
    for col_i = 1:(ncols-1); col_num = [col_num,',','%s']; end %#ok<*AGROW>
    col_num = [col_num, '\n'];
    for row_i = 1:nrows; fprintf(fid, col_num, mean{row_i,:}); end;
    fclose(fid);
    
end

%% Done
disp('=== Extract Done ===');
