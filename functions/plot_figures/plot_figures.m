function plot_figures(fit_results,masks,apparent_differences,image_names_AxTM,image_names_BP,path_of_script,VG)


plot_ape_map(fit_results,masks,apparent_differences,image_names_AxTM,image_names_BP); %Figure 2

plot_ape_histograms(masks,apparent_differences,image_names_AxTM,image_names_BP); %Figure 3

plot_voxel_positions_of_single_voxel_simulation(path_of_script,VG,masks); %S4

end