function  fit_simulated_noisy_whole_brain_data_variable_lambda(jobfile,dMRI_dataset,bval,bvec,filename,path_defaults,outdir,nworkers,roi_fit,roi_msPOAS,noise)

nrun = 1;
crun = 1;

jobs = repmat(jobfile, 1, nrun);
inputs = cell(12, nrun);

inputs{1, crun} = {dMRI_dataset};% Startup: dMRI dataset (3D/4D NIfTI) - cfg_files
inputs{2, crun} =  bval *1000;  % Startup: b-values - cfg_entry
inputs{3, crun} =  bvec;  % Startup: b-vectors - cfg_entry
inputs{4, crun} = filename; % Startup: Specify filename (without .nii) or leave empty when using "Load defaults only" - cfg_entry
inputs{5, crun} = {outdir};% Startup: Output directory - cfg_files
inputs{6, crun} = {path_defaults}; % Startup: Customised - cfg_files
inputs{7, crun} = roi_msPOAS; % msPOAS: Region of interest - cfg_files
inputs{8, crun} = noise; % msPOAS: Expression/Dependency - cfg_entry
inputs{9, crun} = nworkers; % Diffusion Kurtosis Imaging (DKI): Number of workers (parallel programming) - cfg_entry
inputs{10, crun} = roi_fit; % Diffusion Kurtosis Imaging (DKI): Region of interest - cfg_files
inputs{11, crun} = nworkers; % Diffusion Kurtosis Imaging (DKI): Number of workers (parallel programming) - cfg_entry
inputs{12, crun} = roi_fit; % Diffusion Kurtosis Imaging (DKI): Region of interest - cfg_files




spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});

delete([outdir filesep filename '.nii']);



end

