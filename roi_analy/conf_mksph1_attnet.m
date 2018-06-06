% hao adapted for his poject on September 12, 2017 from Qin
% ======================================================================== %
% written by hao (ver_18.06.05)
% rock3.hao@gmail.com
% qinlab.BNU
restoredefaultpath
clear

%% Set up configure
% Set up
roi_form   = 'nii';
roinum     = 'no'; % 'yes' or 'no'
radius     = 8;
spm_dir    = '/Users/haol/Dropbox/Toolbox/spm12';
script_dir = '/Users/haol/Dropbox/Codes/Image/roi_analy';

% This is the folder which you will save defined ROIs
roi_save = '/Users/haol';

% Define ROIs by specifying name, coordinates and radius
myroi{1}.name    = 'DAN_A_l';
myroi{1}.coords  = [-22,-8,54];
myroi{1}.radius  = radius;

myroi{2}.name    = 'DAN_A_r';
myroi{2}.coords  = [22,-8,54];
myroi{2}.radius  = radius;

myroi{3}.name    = 'DAN_B_l';
myroi{3}.coords  = [-34,-38,44];
myroi{3}.radius  = radius;

myroi{4}.name    = 'DAN_B_r';
myroi{4}.coords  = [34,-38,44];
myroi{4}.radius  = radius;

myroi{5}.name    = 'DAN_C_l';
myroi{5}.coords  = [-18,-69,51];
myroi{5}.radius  = radius;

myroi{6}.name    = 'DAN_C_r';
myroi{6}.coords  = [18,-69,51];
myroi{6}.radius  = radius;

myroi{7}.name    = 'DAN_D_l';
myroi{7}.coords  = [-51,-64,-2];
myroi{7}.radius  = radius;

myroi{8}.name    = 'DAN_D_r';
myroi{8}.coords  = [51,-64,-2];
myroi{8}.radius  = radius;

myroi{9}.name    = 'DAN_E_l';
myroi{9}.coords  = [-8,-63,57];
myroi{9}.radius  = radius;

myroi{10}.name    = 'DAN_E_r';
myroi{10}.coords  = [8,-63,57];
myroi{10}.radius  = radius;

myroi{11}.name    = 'DAN_F_l';
myroi{11}.coords  = [-49,3,34];
myroi{11}.radius  = radius;

myroi{12}.name    = 'DAN_F_r';
myroi{12}.coords  = [49,3,34];
myroi{12}.radius  = radius;

myroi{13}.name    = 'VAN_A_l';
myroi{13}.coords  = [-31,39,30];
myroi{13}.radius  = radius;

myroi{14}.name    = 'VAN_A_r';
myroi{14}.coords  = [31,39,30];
myroi{14}.radius  = radius;

myroi{15}.name    = 'VAN_B_l';
myroi{15}.coords  = [-54,-36,27];
myroi{15}.radius  = radius;

myroi{16}.name    = 'VAN_B_r';
myroi{16}.coords  = [54,-36,27];
myroi{16}.radius  = radius;

myroi{17}.name    = 'VAN_C_l';
myroi{17}.coords  = [-60,-59,11];
myroi{17}.radius  = radius;

myroi{18}.name    = 'VAN_C_r';
myroi{18}.coords  = [60,-59,11];
myroi{18}.radius  = radius;

myroi{19}.name    = 'VAN_D_l';
myroi{19}.coords  = [-5,15,32];
myroi{19}.radius  = radius;

myroi{20}.name    = 'VAN_D_r';
myroi{20}.coords  = [5,15,32];
myroi{20}.radius  = radius;

myroi{21}.name    = 'VAN_E_l';
myroi{21}.coords  = [-8,-24,39];
myroi{21}.radius  = radius;

myroi{22}.name    = 'VAN_E_r';
myroi{22}.coords  = [8,-24,39];
myroi{22}.radius  = radius;

myroi{23}.name    = 'VAN_F_l';
myroi{23}.coords  = [-31,11,8];
myroi{23}.radius  = radius;

myroi{24}.name    = 'VAN_F_r';
myroi{24}.coords  = [31,11,8];
myroi{24}.radius  = radius;