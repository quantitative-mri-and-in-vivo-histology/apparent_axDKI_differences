function  fit_simulated_data(jobfile,dMRI_dataset,bval,bvec,filename,path_defaults,outdir,nworkers,roi)

nrun = 1;
crun = 1;

jobs = repmat(jobfile, 1, nrun);
inputs = cell(8, nrun);
inputs{1, crun} = {dMRI_dataset}; % Startup: dMRI dataset (3D/4D NIfTI) - cfg_files
inputs{2, crun} = bval *1000; % Startup: b-values - cfg_entry
inputs{3, crun} = bvec; % Startup: b-vectors - cfg_entry
inputs{4, crun} = filename; % Startup: Specify filename (without .nii) or leave empty when using "Load defaults only" - cfg_entry
inputs{5, crun} = {outdir}; % Startup: Output directory - cfg_files
inputs{6, crun} = {path_defaults}; % Startup: Customised - cfg_files
inputs{7, crun} = nworkers; % Diffusion Kurtosis Imaging (DKI): Number of workers (parallel programming) - cfg_entry
inputs{8, crun} = roi; % Diffusion Kurtosis Imaging (DKI): Region of interest - cfg_files

spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});

delete([outdir filesep filename '.nii']);



end