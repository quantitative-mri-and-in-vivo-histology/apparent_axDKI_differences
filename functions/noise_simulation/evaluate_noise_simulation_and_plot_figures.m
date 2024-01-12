function evaluate_noise_simulation_and_plot_figures(masks,path_of_script,VG,fit_results,apparent_differences)

simulation_parameters.number_of_noise_samples  = 100;
simulation_parameters.measurement_protocol = {'standard','fast_199'};


%% Analysis
analysis_mask = logical(masks.wm .* masks.westin_indices);   

dki_model ={'DKI-NLLS', 'DKIax-NLLS'};
dki_model_name ={'DKI', 'DKIax'};
AxTM_names = {'MW','AW','RW','AD','RD'};
latex_map_names_AxTM = {'$\overline{W}$','$W_{\parallel}$','$W_{\perp}$','$D_{\parallel}$','$D_{\perp}$',};


BP_names = {'AWF','KAPPA', 'DE_PERP', 'DE_PARA','DA'};
latex_map_names_BP = {'AWF','$\kappa$','$D_{e,\perp}$','$D_{e,\parallel}$','$D_{a}$',};

pth = [path_of_script filesep '..' filesep 'data' filesep 'results' filesep 'noisy_data'];

for inx = 1:numel(AxTM_names)
    parameter_values = fit_results.noise_free_whole_brain_simulation.dki.(AxTM_names{inx});
    noise_free_AxTM_average_in_white_matter.(AxTM_names{inx}) = mean(parameter_values(masks.wm));
end

%% Figure 4
 [direct_values_table,voxel_names] = read_noise_simulation_results_single_voxels(pth,dki_model,simulation_parameters,path_of_script);
 plot_noise_simulation_results_single_voxels(path_of_script,AxTM_names,noise_free_AxTM_average_in_white_matter,direct_values_table,voxel_names,simulation_parameters,'directly subtracting the fit results',VG)
%% Figure 5
[is_precision_better_than_bias_in_perecent.('whole_brains_lambda_equals_100'),precision_direct_values.('whole_brains_lambda_equals_100')] = read_noise_simulation_results_bias_bigger_std_analysis('whole_brains_lambda_equals_100',pth,simulation_parameters,dki_model,dki_model_name,AxTM_names,VG,fit_results,apparent_differences,analysis_mask);
[is_precision_better_than_bias_in_perecent.('whole_brains_lambda_equals_10'),precision_direct_values.('whole_brains_lambda_equals_10')] = read_noise_simulation_results_bias_bigger_std_analysis('whole_brains_lambda_equals_10',pth,simulation_parameters,dki_model,dki_model_name,AxTM_names,VG,fit_results,apparent_differences,analysis_mask);
plot_noise_simulation_results_bias_bigger_std_analysis(simulation_parameters,is_precision_better_than_bias_in_perecent,precision_direct_values,latex_map_names_AxTM,AxTM_names,apparent_differences,analysis_mask);
%% Figure 6 
[rois_used_in_paper,roi_names,atlas_mask_struct,atlas_labels] = load_jhu_atlas_and_rois(masks.wm,VG,path_of_script);
[coregistered_SNR39_whole_brain_simulation_bias_in_roi,coregistered_SNR39_whole_brain_simulation_bias_in_roi_as_array] = compute_statistics_in_rois(rois_used_in_paper,roi_names,fit_results.coregistered_SNR39_simulation.results,fit_results.coregistered_SNR39_simulation.bias);
plot_coregistered_SNR39_whole_brain_simulation(coregistered_SNR39_whole_brain_simulation_bias_in_roi_as_array,roi_names);
%% Figure S1
plot_histograms_of_ape_distribution(apparent_differences,AxTM_names,latex_map_names_AxTM,BP_names,latex_map_names_BP,masks.wm);
%% Figure S3
plot_scatter_density_between_ape_and_angle_phi(AxTM_names,latex_map_names_AxTM,apparent_differences,VG,masks,path_of_script);

end