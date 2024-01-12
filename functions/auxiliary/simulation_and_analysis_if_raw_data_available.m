function  simulation_and_analysis_if_raw_data_available(path_of_script)


PATH_Template = [path_of_script filesep '..' filesep  'data' filesep 'dwi_images_used_to_estimate_ground_truth_tensors' filesep 'fit_results' filesep 'derivatives' filesep 'DKI-NLLS' filesep 'eps2_4d_desc-ECMOCO-HySCO-RBC-DKI-NLLS-FA_map.nii'];
VG = spm_vol(PATH_Template);
path_defaults = [path_of_script filesep '..' filesep 'functions' filesep 'auxiliary' filesep 'acid_local_defaults_axDKI_inherent_bias_study.m'];
%% Simulation
simulation_main_function(path_of_script,VG,path_defaults)
%% Apply deformation field 
apply_deformation_field_main(path_of_script);
%% Analysis

[fit_results,image_names_AxTM,image_names_BP] = load_fit_results(path_of_script,VG);
[apparent_differences.noise_free_whole_brain_simulation] = compute_apparent_differences(fit_results.noise_free_whole_brain_simulation,image_names_AxTM,image_names_BP);
[masks] = load_or_compute_masks(path_of_script,VG);


evaluate_noise_simulation_and_plot_figures(masks,path_of_script,VG,fit_results,apparent_differences);
plot_figures(fit_results.noise_free_whole_brain_simulation,masks,apparent_differences.noise_free_whole_brain_simulation,image_names_AxTM,image_names_BP,path_of_script,VG)

end