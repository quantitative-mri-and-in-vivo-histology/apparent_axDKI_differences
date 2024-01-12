function apply_deformation_field_main(path_of_script)

path_deformation_field = [path_of_script filesep '..' filesep 'data' filesep 'coregistration' filesep 'y_deformation_field_map.nii'];

path_results = [path_of_script filesep '..' filesep 'data' filesep 'results'];
folder.inx_1 = [path_results filesep 'noise_free_whole_brain_simulation' filesep 'derivatives' filesep 'DKI-NLLS'];
folder.inx_2  = [path_results filesep 'noise_free_whole_brain_simulation' filesep 'derivatives' filesep 'DKIax-NLLS'];

folder.inx_3  = [path_results filesep 'noisy_data' filesep 'whole_brains_lambda_equals_100' filesep 'simulated_SNR_39' filesep 'noise_sample_1' filesep 'standard' filesep 'derivatives' filesep 'DKI-NLLS'];
folder.inx_4  = [path_results filesep 'noisy_data' filesep 'whole_brains_lambda_equals_100' filesep 'simulated_SNR_39' filesep 'noise_sample_1' filesep 'standard' filesep 'derivatives' filesep 'DKIax-NLLS'];
folder.inx_5  = [path_results filesep 'noisy_data' filesep 'whole_brains_lambda_equals_100' filesep 'simulated_SNR_39' filesep 'noise_sample_1' filesep 'fast_199' filesep 'derivatives' filesep 'DKIax-NLLS'];


    for inx_folder = 1:5
    
        folderPath = [folder.(['inx_' num2str(inx_folder)]) filesep];
        if inx_folder <= 2
            pattern = 'NoiseFree_simulation_whole_brain';
            pattern_to_exclude = 'applied_deformation_field_NoiseFree_simulation';
        else
            pattern = 'SNR';
            pattern_to_exclude = 'applied_deformation_field';
        end
        [file_names] = get_files_that_the_deformation_field_is_applied_to(folderPath,pattern,pattern_to_exclude);
        path_template = file_names{1};
        
        apply_deformation_field(path_deformation_field,path_template,file_names)
    end
end