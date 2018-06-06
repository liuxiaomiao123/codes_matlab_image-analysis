% written by hao (ver_18.06.05)
% rock3.hao@gmail.com
% qinlab.BNU
restoredefaultpath
clear

%% Set up
roi_form   = 'nii';
roi_radius = 6;
coord_list = '/Users/haol/Dropbox/Codes/Image/roi_analy/list_mksph2.txt';
spm_dir    = '/Users/haol/Dropbox/Toolbox/spm12';
roi_save   = '/Users/haol/Downloads/scr_test/ROI';

%% Make Sphere ROI
ROICoord = load(coord_list);
addpath(genpath(spm_dir));

if ~exist (roi_save, 'dir')
    mkdir (roi_save);
end

for i = 1:size(ROICoord, 1)
    n = num2str(i);
    if length(n) == 1
        n = ['00', n]; %#ok<*AGROW>
    elseif length(n) == 2
        n = ['0', n];
    end
    
    coords = ROICoord(i, :);
    name = ['ROI_', n];
    
    roi = maroi_sphere(struct('centre', coords, 'radius', roi_radius));
    roi = label(roi, name);
    
    
    r = num2str(roi_radius);
    x = num2str(coords(1));
    y = num2str(coords(2));
    z = num2str(coords(3));
    
    filename = [name  '_' x '_' y '_' z '_' r 'mm_roi.mat'];
    filepath = fullfile(roi_save, filename);
    
    if strcmp(roi_form,'mat')
        save(filepath, 'roi');
    elseif strcmp(roi_form,'nii')
        save_as_image(roi, [filepath(1:end-4),'.nii'])
    end
end

disp('=== Making ROIs is Done ===');