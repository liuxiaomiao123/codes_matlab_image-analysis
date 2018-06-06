% written by hao (ver_18.06.05)
% rock3.hao@gmail.com
% qinlab.BNU
restoredefaultpath
clear

%% Set up
threshold = 0; % 0.005=2.6; 0.001=3.1
task_name = 'ANT';
img_type  = 'spmT'; % 'spmT' or 'con'

spm_dir    = '/Users/haol/Dropbox/Toolbox/spm12';
roi_dir    = '/Users/haol/Downloads/scr_test/ROI/NeuroSynth_Fan';
firlv_dir  = '/Users/haol/Downloads/scr_test/FirstLv/FirstLv_3Cond';
script_dir = '/Users/haol/Dropbox/Codes/Image/univar_acti';
list_file  = fullfile(script_dir,'list_test.txt');

%% Calculate Overlap Voxels in Mask
% Read subject list
fid = fopen(list_file); sublist = {}; cnt = 1;
while ~feof(fid)
    linedata = textscan(fgetl(fid), '%s', 'Delimiter', '\t');
    sublist(cnt,:) = linedata{1}; cnt = cnt+1; %#ok<*SAGROW>
end
fclose(fid);

% Acquire ROI file & list
roi_list = dir(fullfile(roi_dir,'*.nii'));
roi_list = struct2cell(roi_list);
roi_list = roi_list(1,:)';

% Add path
addpath(genpath(spm_dir));
addpath(genpath(script_dir));

allres = {'Scan_ID'};
for iroi = 1:length(roi_list)
    allres{1,iroi+1} = roi_list{iroi,1}(1:end-4);
    mask = spm_read_vols(spm_vol(fullfile(roi_dir,roi_list{iroi,1})));
    
    for isub = 1:length(sublist)
        allres{isub+1,1} = sublist{isub,1};
        yearID = ['20',sublist{isub,1}(1:2)];
        sub_file1 = fullfile(firlv_dir, yearID, sublist{isub,1},...
            ['fmri/stats_spm12/', task_name, '/stats_spm12_swcar'], ...
            [img_type,'_0001.nii']);
        sub_file2 = fullfile(firlv_dir, yearID, sublist{isub,1},...
            ['fmri/stats_spm12/', task_name, '/stats_spm12_swcar'], ...
            [img_type,'_0002.nii']);
        sub_file3 = fullfile(firlv_dir, yearID, sublist{isub,1},...
            ['fmri/stats_spm12/', task_name, '/stats_spm12_swcar'], ...
            [img_type,'_0003.nii']);
        
        sub_img1 = spm_read_vols(spm_vol(sub_file1));
        sub_img1(sub_img1<threshold)  = 0;
        sub_img2 = spm_read_vols(spm_vol(sub_file2));
        sub_img2(sub_img2<threshold)  = 0;
        sub_img3 = spm_read_vols(spm_vol(sub_file3));
        sub_img3(sub_img3<threshold)  = 0;
        
        overlap_comb = sub_img1 & sub_img2 & sub_img3 & mask;
        sub_vect = overlap_comb(mask(:)==1);
        voxelnum = num2str(sum(sub_vect==1));
        allres{isub+1,iroi+1} = voxelnum;
    end
end

%% Save Results
save_name = ['res_acti_overlap_aoc_',img_type,'_',num2str(threshold),'.csv'];
fid = fopen(save_name, 'w');[nrows,ncols] = size(allres);col_num = '%s';
for col_i = 1:(ncols-1); col_num = [col_num,',','%s']; end %#ok<*AGROW>
col_num = [col_num, '\n'];
for row_i = 1:nrows; fprintf(fid, col_num, allres{row_i,:}); end;
fclose(fid);

%% Done
disp('=== overlap voxels calculate done ===');