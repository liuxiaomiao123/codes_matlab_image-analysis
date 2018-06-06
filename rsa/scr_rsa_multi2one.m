% written by hao (ver_18.06.06)
% rock3.hao@gmail.com
% qinlab.BNU
restoredefaultpath
clear

%% Set up
img_type   = 'con'; % 'spmT' or 'con'
task_name  = 'ANT';
cond_name  = {'ChiA_AduA';'ChiO_AduO';'ChiC_AduC'};
rsa_file   = {'/Users/haol/Downloads/scr_test/SecLv/OneANOVA_CBDC_CondDep/con_0001.nii';
              '/Users/haol/Downloads/scr_test/SecLv/OneANOVA_CBDC_CondDep/con_0002.nii';
              '/Users/haol/Downloads/scr_test/SecLv/OneANOVA_CBDC_CondDep/con_0003.nii'};

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
addpath ( genpath (spm_dir));

allres = {'Scan_ID'};
for con_i = 1:length(cond_name)
    
    for roi_i = 1:length(roi_list)
        allres{1,roi_i+1} = roi_list{roi_i,1}(1:end-4);
        roifile = fullfile(roi_dir, roi_list{roi_i,1});
        
        mask     = spm_read_vols(spm_vol(roifile));
        rsa_img  = spm_read_vols(spm_vol(rsa_file{con_i,1}));
        rsa_vect = rsa_img(mask(:)==1);
        
        % rsa_vect(isnan(rsa_vect)) = nanmean(rsa_vect);
        
        for sub_i = 1:length(sublist)
            allres{sub_i+1,1} = sublist{sub_i,1};
            
            yearID  = ['20',sublist{sub_i,1}(1:2)];
            sub_file = fullfile(firlv_dir, yearID, sublist{sub_i,1},...
                ['fmri/stats_spm12/', task_name, '/stats_spm12_swcar'], ...
                [img_type,'_000',num2str(con_i),'.nii']);
            
            sub_img = spm_read_vols(spm_vol(sub_file));
            sub_vect = sub_img(mask(:)==1);
            
            % sub_vect(isnan(sub_vect)) = nanmean(sub_vect);
            
            [rsa_r, rsa_p] = corr(rsa_vect, sub_vect);
            allres{sub_i+1,roi_i+1} = rsa_r;
        end
    end
    % Save Results
    save_name = ['res_rsa_multi2one_', cond_name{con_i,1}, '_', img_type,'.csv'];
    
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