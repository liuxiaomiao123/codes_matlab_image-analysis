% written by hao (ver_18.06.03)
% rock3.hao@gmail.com
% qinlab.BNU
restoredefaultpath
clear

%% ------------------------------ Set Up ------------------------------- %%
% Set Path
spm_dir     = '/Users/haol/Dropbox/Toolbox/spm12';
script_dir  = '/Users/haol/Dropbox/Codes/Image/univar_acti/firstlv_spm12';
preproc_dir = '/Users/haol/Downloads/scr_test/Preproc';
results_dir = '/Users/haol/Desktop/bc/xxx';

% Basic Configure
postfix     = 'hao';
sess_num    = 2;
sess_name   = 'ANT';
sess_list   = 'ANT1'',''ANT2'; % Single Run: 'Run'; Multiple Run: 'Run1'',''Run2'',''Run3'.
task_design = 'ANT_rig_hao.m';

sublist     = fullfile(script_dir,'list_test.txt');
contrasts   = fullfile(script_dir,'contrast','ANT_3c_hao.mat');

%% The following do not need to be modified
% ------------------------- Individual Analysis ------------------------- %
addpath (genpath (spm_dir));
addpath (genpath (script_dir));

cd (script_dir)
if ~exist('log','dir')
    mkdir (fullfile(script_dir,'log'))
end

iconfigname = ['config_indivstats_',sess_name,'_',postfix,'.m'];
iconfig     = fopen(iconfigname,'a');
fprintf (iconfig,'%s\n',['paralist.sessnum = ',num2str(sess_num),';']);
fprintf (iconfig,'%s\n',['paralist.postfix = ''',postfix,''';']);
fprintf (iconfig,'%s\n','paralist.data_type = ''nii'';');
fprintf (iconfig,'%s\n','paralist.pipeline = ''swcar'';');
fprintf (iconfig,'%s\n',['paralist.server_path = ''',preproc_dir,''';']);
fprintf (iconfig,'%s\n',['paralist.stats_path = ''',results_dir,''';']);
fprintf (iconfig,'%s\n','paralist.parent_folder = '''';');
fprintf (iconfig,'%s\n',['fid = fopen(''',sublist,''');']);
fprintf (iconfig,'%s\n','SubLists = {};');
fprintf (iconfig,'%s\n','Cnt_List = 1;');
fprintf (iconfig,'%s\n','while ~feof(fid)');
fprintf (iconfig,'%s\n','    linedata = textscan(fgetl(fid), ''%s'', ''Delimiter'', ''\t'');');
fprintf (iconfig,'%s\n','    SubLists(Cnt_List,:) = linedata{1}; %#ok<*SAGROW>');
fprintf (iconfig,'%s\n','    Cnt_List = Cnt_List + 1;');
fprintf (iconfig,'%s\n','end');
fprintf (iconfig,'%s\n','fclose(fid);');
fprintf (iconfig,'%s\n','paralist.subjectlist = SubLists;');
if sess_num == 1
    fprintf (iconfig,'%s\n',['paralist.exp_sesslist = ''',sess_list,''';']);
end
if sess_num > 1
    fprintf (iconfig,'%s\n',['paralist.exp_sesslist = {''',sess_list,'''};']);
end
fprintf (iconfig,'%s\n',['paralist.task_dsgn = ''',task_design,''';']);
fprintf (iconfig,'%s\n',['paralist.contrastmat = ''',contrasts,''';']);
fprintf (iconfig,'%s\n','paralist.preprocessed_folder = ''smoothed_spm12'';');
fprintf (iconfig,'%s\n',['paralist.stats_folder = ''',sess_name,'/stats_spm12_swcar'';']);
fprintf (iconfig,'%s\n','paralist.include_mvmnt = 1;');
fprintf (iconfig,'%s\n','paralist.include_volrepair = 0;');
fprintf (iconfig,'%s\n','paralist.volpipeline = ''swavr'';');
fprintf (iconfig,'%s\n','paralist.volrepaired_folder = ''volrepair_spm12'';');
fprintf (iconfig,'%s\n','paralist.repaired_stats = ''stats_spm12_VolRepair'';');
fprintf (iconfig,'%s\n',['paralist.template_path = ''',fullfile(script_dir,'depend'),''';']);
fclose (iconfig);

movefile (iconfigname,fullfile(script_dir,'depend'))
indivstats_spm12 (iconfigname)

movefile (fullfile(script_dir,'depend',iconfigname),fullfile(script_dir,'log'))
movefile ('indivstats*',fullfile(script_dir,'log'))

%% All Done
clear