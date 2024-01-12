function simulation_and_analysis_if_raw_data_NOT_available(path_of_script)
path_defaults = [path_of_script filesep '..' filesep 'functions' filesep 'auxiliary' filesep 'acid_local_defaults_axDKI_inherent_bias_study.m'];

PATH_Template = [path_of_script filesep '..' filesep  'data' filesep 'single_voxel_simulation_files_if_raw_data_not_available' filesep 'TEMPLATE.nii'];
VG = spm_vol(PATH_Template);

pth = [path_of_script filesep '..' filesep 'data' filesep 'results' filesep 'noisy_data'];
dki_model ={'DKI-NLLS', 'DKIax-NLLS'};
AxTM_names = {'MW','AW','RW','AD','RD'};
simulation_parameters.measurement_protocol = {'standard','fast_199'};
load([path_of_script filesep '..' filesep 'data' filesep 'single_voxel_simulation_files_if_raw_data_not_available' filesep 'noise_free_AxTM_average_in_white_matter.mat'])

%% Simulation
simulation_if_raw_data_NOT_available_main_function(path_of_script,VG,path_defaults)


%% Figure 4
[direct_values_table,voxel_names] = read_noise_simulation_results_single_voxels(pth,dki_model,simulation_parameters,path_of_script);
plot_noise_simulation_results_single_voxels(path_of_script,AxTM_names,noise_free_AxTM_average_in_white_matter,direct_values_table,voxel_names,simulation_parameters,'directly subtracting the fit results',VG)

end