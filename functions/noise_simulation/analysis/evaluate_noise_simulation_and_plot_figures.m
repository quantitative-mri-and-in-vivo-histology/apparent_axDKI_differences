function evaluate_noise_simulation_and_plot_figures(masks,path_of_script,VG,fit_results,apparent_differences)

simulation_parameters.number_of_noise_samples  = 100;
simulation_parameters.measurement_protocol = {'standard','fast_199'};


%% Simulation








%% Analysis
analysis_mask = logical(masks.wm .* masks.westin_indices);   

dki_model ={'DKI-NLLS', 'DKIax-NLLS'};
dki_model_name ={'DKI', 'DKIax'};
AxTM_names = {'MW','AW','RW','AD','RD'};
latex_map_names = {'$\overline{W}$','$W_{\parallel}$','$W_{\perp}$','$D_{\parallel}$','$D_{\perp}$',};

pth = ['/projects/crunchie/Malte/AxDKI_Inherent_Bias_Paper/simulation/epilepsy_pilot_subject2/noise_simulation'];


%% Figure 4
% Or load: /projects/crunchie/Malte/apparent_axdki_differences_paper/data/direct_values_table_from_single_voxels_delete_before_publishing.mat
profile clear
profile on
 [direct_values_table,voxel_names] = read_noise_simulation_results_single_voxels(pth,VG,dki_model,simulation_parameters);
profile viewer
 plot_noise_simulation_results_single_voxels(direct_values_table,voxel_names,simulation_parameters,'directly subtracting the fit results')
%% Figure 5
[is_precision_better_than_bias_in_perecent,precision_direct_values] = read_noise_simulation_results_bias_bigger_std_analysis(pth,simulation_parameters,dki_model,dki_model_name,AxTM_names,VG,fit_results,apparent_differences,analysis_mask);
plot_noise_simulation_results_bias_bigger_std_analysis(simulation_parameters,is_precision_better_than_bias_in_perecent,precision_direct_values,latex_map_names,AxTM_names,apparent_differences,analysis_mask);







end