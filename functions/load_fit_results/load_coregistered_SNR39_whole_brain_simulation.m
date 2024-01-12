function [coregistered_results,coregistered_results_bias_maps] = load_coregistered_SNR39_whole_brain_simulation(path_results,standard_DKI_noise_free_results)



source_path_standard_with_POAS =  [path_results filesep 'noisy_data' filesep 'whole_brains_lambda_equals_100' filesep 'simulated_SNR_39' filesep 'noise_sample_1' filesep 'standard' filesep 'derivatives'];
source_path_fast_with_POAS = [path_results filesep 'noisy_data' filesep 'whole_brains_lambda_equals_100' filesep 'simulated_SNR_39' filesep 'noise_sample_1' filesep 'fast_199' filesep 'derivatives'];


folders_standard_protocol_with_poas = {'DKIax-NLLS',  'DKI-NLLS'};
struct_field_names_standard_protocol ={ 'msPOAS_DKIax' ,   'msPOAS_DKI'};


AxTM_names = {'MW','AW','RW','AD','RD'};


for inx_protocol = 1:2
    if inx_protocol == 1
        folder_results = source_path_standard_with_POAS;
        protocol_name = 'standard_protocol';
        struct_field_names = struct_field_names_standard_protocol;
        sub_folder_results = folders_standard_protocol_with_poas;
    elseif inx_protocol == 2
        folder_results = source_path_fast_with_POAS;
        protocol_name = 'fast_199_protocol';
        struct_field_names = {struct_field_names_standard_protocol{1}};
        sub_folder_results = {folders_standard_protocol_with_poas{1}};
    end

    for inx_result_sub_folders = 1:numel(sub_folder_results)
        for inx_AxTM_names = 1:numel(AxTM_names)

            ground_truth = standard_DKI_noise_free_results.([AxTM_names{inx_AxTM_names}]);

            image_path = [folder_results filesep sub_folder_results{inx_result_sub_folders} filesep 'applied_deformation_field_SNR_39_simulation_with_' protocol_name '_whole_brain_noise_realisation_1_desc-msPOAS-' sub_folder_results{inx_result_sub_folders} '-' AxTM_names{inx_AxTM_names}  '_map.nii' ];
            image_vol = spm_vol(image_path);
            image = acid_read_vols(image_vol,image_vol,1);

            coregistered_results.(protocol_name).(struct_field_names{inx_result_sub_folders}).(AxTM_names{inx_AxTM_names}) = image;
            coregistered_results_bias_maps.(protocol_name).(struct_field_names{inx_result_sub_folders}).(AxTM_names{inx_AxTM_names}) = 100 * abs( (ground_truth - image)./ground_truth);

        end
    end
end


end





