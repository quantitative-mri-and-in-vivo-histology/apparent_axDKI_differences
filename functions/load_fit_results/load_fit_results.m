function [fit_results,image_names_AxTM,image_names_BP] = load_fit_results(path_of_script,VG)

    path_results = [path_of_script filesep '..' filesep 'data' filesep 'results'];


    image_names_AxTM = {'MW_map','AW_map','RW_map','AD_map','RD_map'};
    image_names_BP = {'AWF_map','KAPPA_map','DE-PERP_map','DE-PARA_map','DA_map'};

    fit_results = struct;
%% Noise-free results        
    [noise_free_whole_brain_simulation,coregisered_noise_free_whole_brain_simulation] = load_noise_free_whole_brain_simulation(path_results,image_names_AxTM,image_names_BP,VG);
    fit_results.noise_free_whole_brain_simulation = noise_free_whole_brain_simulation;
    fit_results.coregisered_noise_free_whole_brain_simulation = coregisered_noise_free_whole_brain_simulation;    
%% Coregisterd SNR=39 results 
    
    [coregistered_results,coregistered_results_bias_maps] = load_coregistered_SNR39_whole_brain_simulation(path_results,coregisered_noise_free_whole_brain_simulation.dki);
    fit_results.coregistered_SNR39_simulation.results = coregistered_results;
    fit_results.coregistered_SNR39_simulation.bias = coregistered_results_bias_maps;
     

end