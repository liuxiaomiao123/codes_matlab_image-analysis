paralist.sessnum = 2;
paralist.postfix = 'hao';
paralist.data_type = 'nii';
paralist.pipeline = 'swcar';
paralist.server_path = '/Users/haol/Desktop/bc';
paralist.stats_path = '/Users/haol/Desktop/bc/xxx';
paralist.parent_folder = '';
fid = fopen('/Users/haol/Dropbox/Codes/Image/univar_acti/firstlv_spm12/SubList_MS.txt');
SubLists = {};
Cnt_List = 1;
while ~feof(fid)
    linedata = textscan(fgetl(fid), '%s', 'Delimiter', '\t');
    SubLists(Cnt_List,:) = linedata{1}; %#ok<*SAGROW>
    Cnt_List = Cnt_List + 1;
end
fclose(fid);
paralist.subjectlist = SubLists;
paralist.exp_sesslist = {'MS_01','MS_02'};
paralist.task_dsgn = 'taskdesign_MS_xjh.m';
paralist.contrastmat = '/Users/haol/Dropbox/Codes/Image/univar_acti/firstlv_spm12/contrast/contrasts_MS_old.mat';
paralist.preprocessed_folder = 'smoothed_spm12';
paralist.stats_folder = 'MS/stats_spm12_swcar';
paralist.include_mvmnt = 1;
paralist.include_volrepair = 0;
paralist.volpipeline = 'swavr';
paralist.volrepaired_folder = 'volrepair_spm12';
paralist.repaired_stats = 'stats_spm12_VolRepair';
paralist.template_path = '/Users/haol/Dropbox/Codes/Image/univar_acti/firstlv_spm12/depend';
