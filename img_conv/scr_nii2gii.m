% written by hao (ver_17.09.23)
% rock3.hao@gmail.com
% qinlab.BNU
clear
clc

%% Set up
img_head = 'NS*';
roi_dir  = '/Users/haol/Downloads';
sub_dir  = {'di'};
% group  = {'GrpAll';'NeuroSynth'};
        
%% Set Tranform Surface File
surf_dir  = '~/Dropbox/Toolbox/Template_WB/Conte69_Atlas_32k_v2';
transurfL = fullfile (surf_dir, 'Conte69.L.midthickness.32k_fs_LR.surf.gii');
transurfR = fullfile (surf_dir, 'Conte69.R.midthickness.32k_fs_LR.surf.gii');

%% ===================================================================== %%
% Convert .nii to .shape.gii
% When convert ROI and the resulting surface image have strange shading
% around the edges of the ROIs. Use "-enclosing" instead of "-trilinear"
for grp = 1:length(sub_dir)
    grp_dir     = fullfile(roi_dir, sub_dir{grp,1});
    niiconvlist = dir(fullfile(grp_dir, [img_head,'.nii']));
    for nii = 1: length(niiconvlist)
        niifile = fullfile(grp_dir, niiconvlist(nii).name);
        unix(cat(2,'wb_command -volume-to-surface-mapping ',niifile,' ',transurfL,...
            ' ',fullfile(grp_dir,[niiconvlist(nii).name(1:end-4),'L.shape.gii ']),'-trilinear'));
        unix(cat(2,'wb_command -volume-to-surface-mapping ',niifile,' ',transurfR,...
            ' ',fullfile(grp_dir,[niiconvlist(nii).name(1:end-4),'R.shape.gii ']),'-trilinear'));
    end
end

disp('=== Convert Done ===');