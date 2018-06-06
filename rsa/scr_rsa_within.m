% written by hao (ver_18.06.06)
% rock3.hao@gmail.com
% qinlab.BNU
restoredefaultpath
clear

%% Set up
task_name = 'ANT';
img_type  = 'con'; % 'spmT' or 'con'
cond_num  = {'12';'13';'23'};

spm_dir    = '/Users/haol/Dropbox/Toolbox/spm12';
roi_dir    = '/Users/haol/Downloads/scr_test/ROI/NeuroSynth_Fan';
firlv_dir  = '/Users/haol/Downloads/scr_test/FirstLv/FirstLv_3Cond';
subjlist   = '/Users/haol/Dropbox/Codes/Image/rsa/list_test.txt';

%% RSA correlation
% Read subject list
fid = fopen(subjlist); sublist = {}; cnt_list = 1;
while ~feof(fid)
    linedata = textscan(fgetl(fid), '%s', 'Delimiter', '\t');
    sublist(cnt_list,:) = linedata{1}; cnt_list = cnt_list + 1; %#ok<*SAGROW>
end
fclose(fid);

% Acquire ROI file & list
roi_list = dir(fullfile(roi_dir,'*.nii'));
roi_list = struct2cell(roi_list);
roi_list = roi_list(1,:)';

% Add path
addpath(genpath(spm_dir));

for con_i = 1:length(cond_num)
    allres = {'Scan_ID'};
    for roi_i = 1:length(roi_list)
        allres{1,roi_i+1} = roi_list{roi_i,1}(1:end-4);
        roi_file = fullfile(roi_dir, roi_list{roi_i,1});
        mask = spm_read_vols(spm_vol(roi_file));
        
        for sub_i = 1:length(sublist)
            allres{sub_i+1,1} = sublist{sub_i,1};
            
            yearID = ['20', sublist{sub_i,1}(1:2)];
            img_1  = fullfile(firlv_dir, yearID, sublist{sub_i,1},...
                ['fmri/stats_spm12/', task_name, '/stats_spm12_swcar'], ...
                [img_type,'_000',cond_num{con_i,1}(1),'.nii']);
            img_2  = fullfile(firlv_dir, yearID, sublist{sub_i,1},...
                ['fmri/stats_spm12/', task_name, '/stats_spm12_swcar'], ...
                [img_type,'_000',cond_num{con_i,1}(2),'.nii']);
            
            sub_img1 = spm_read_vols(spm_vol(img_1));
            sub_vect1 = sub_img1(mask(:)==1);
            sub_img2 = spm_read_vols(spm_vol(img_2));
            sub_vect2 = sub_img2(mask(:)==1);
            
            [rsa_r, rsa_p] = corr(sub_vect1, sub_vect2);
            allres{sub_i+1,roi_i+1} = rsa_r;
        end
    end
    
    save_name = ['res_rsa_within_',cond_num{con_i,1}, '_', img_type, '.csv'];
    fid = fopen(save_name, 'w');
    [nrows,ncols] = size(allres);
    col_num = '%s';
    for col_i = 1:(ncols-1); col_num = [col_num,',','%s']; end %#ok<*AGROW>
    col_num = [col_num, '\n'];
    for row_i = 1:nrows; fprintf(fid, col_num, allres{row_i,:}); end;
    fclose(fid);
end

%% Done
disp('=== RSA Calculate Done ===');