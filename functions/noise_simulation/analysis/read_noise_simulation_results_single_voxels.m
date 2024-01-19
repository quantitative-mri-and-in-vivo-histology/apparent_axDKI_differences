function [direct_values_table,voxel_names] = read_noise_simulation_results_single_voxels(pth,dki_model,simulation_parameters,path_of_script)

    [voxel_names] = get_voxels_to_be_simulated;

    table_entries = {'RD','AD', 'RW', 'AW', 'MW','voxel_name','snr','protocol','algorithm'};
    results_table_tmp = table();
    results_table = table();

    simulation_parameters.simulated_SNRs = 1:1:140;

    load([path_of_script filesep '..' filesep 'data' filesep 'simulation' filesep 'noisy_data' filesep 'single_voxels' filesep 'ground_truth_tables' filesep 'ground_truth_AxTM_table.mat'])

    b0_simulation_volume = spm_vol([pth filesep 'single_voxels'  filesep 'AW_voxel1_minus_0_comma_039'  filesep 'simulated_SNR_100'  filesep 'standard'  filesep 'derivatives'  filesep 'DKIax-NLLS' filesep 'SNR_100_standard_protocol_voxel_1_desc-DKIax-NLLS-S0.nii']);
    b0_simulation = acid_read_vols(b0_simulation_volume,b0_simulation_volume,1);
    mask = find(b0_simulation ~=0);


    for inx_protocol = 1: numel(simulation_parameters.measurement_protocol)
        for inx_snr = 1 : size(simulation_parameters.simulated_SNRs,2)
            for inx_dki_model = 1: numel(dki_model)
                  derivatives_subfolder = dki_model{inx_dki_model};
                for inx_voxel = 1:numel(voxel_names)
                    for inx_AxTM = 1:numel(table_entries)
                        if inx_AxTM <= 5

                            if inx_protocol == 1
                                protocol_folder = 'standard';
                            elseif inx_protocol == 2
                                protocol_folder = 'fast_199';
                            end

                            path_out = [pth filesep 'single_voxels' filesep voxel_names{inx_voxel} filesep 'simulated_SNR_' num2str(simulation_parameters.simulated_SNRs(inx_snr)) filesep protocol_folder filesep];

                            parameter_path = [path_out 'derivatives' filesep derivatives_subfolder filesep 'SNR_' num2str(simulation_parameters.simulated_SNRs(inx_snr)) ...
                                '_' simulation_parameters.measurement_protocol{inx_protocol} '_protocol_voxel_' num2str(inx_voxel) '_desc-' dki_model{inx_dki_model} '-' table_entries{inx_AxTM} '_map.nii'];

                            vol_tmp = spm_vol(parameter_path);
                            parameter = acid_read_vols(vol_tmp,vol_tmp,1);
                            results_table_tmp.(table_entries{inx_AxTM}) = parameter(mask);

                        elseif inx_AxTM == 6
                            results_table_tmp.(table_entries{inx_AxTM}) =  repmat(string(voxel_names{inx_voxel}),size(mask,1),1);
                        elseif inx_AxTM == 7
                            results_table_tmp.(table_entries{inx_AxTM}) =  repmat(simulation_parameters.simulated_SNRs(inx_snr),size(mask,1),1);
                        elseif inx_AxTM == 8
                            results_table_tmp.(table_entries{inx_AxTM}) =  repmat(string(simulation_parameters.measurement_protocol{inx_protocol}),size(mask,1),1);
                        elseif inx_AxTM == 9
                            results_table_tmp.(table_entries{inx_AxTM}) =  repmat(string(dki_model{inx_dki_model}),size(mask,1),1);
                        end

                    end
                    results_table = [results_table;results_table_tmp];

                end
            end
        end
    end



    bias_table_tmp =table();
    bias_table = table();

    direct_values_table_tmp =table();
    direct_values_table = table();
    for inx_protocol = 1: numel(simulation_parameters.measurement_protocol)
        for inx_snr = 1 : size(simulation_parameters.simulated_SNRs,2)
            for inx_dki_model = 1: numel(dki_model)
                for inx_voxel = 1:numel(voxel_names)
                    for inx_AxTM = 1:numel(table_entries)
                        %%
                        if inx_AxTM <= 5
                            Ground_Truth_Value = ground_truth_AxTM_table.(table_entries{inx_AxTM})(ground_truth_AxTM_table.voxel_name == voxel_names{inx_voxel});
                            bias_table_tmp.(table_entries{inx_AxTM}) = 100 * abs( Ground_Truth_Value - mean(results_table.(table_entries{inx_AxTM})(results_table.algorithm == dki_model{inx_dki_model} & results_table.protocol == simulation_parameters.measurement_protocol{inx_protocol} & results_table.snr == simulation_parameters.simulated_SNRs(inx_snr) &  results_table.voxel_name == voxel_names{inx_voxel} ,1)) ) / Ground_Truth_Value ;
                            bias_table_tmp.(['standard_deviation_' table_entries{inx_AxTM} ]) = 100 * std(results_table.(table_entries{inx_AxTM})(results_table.algorithm == dki_model{inx_dki_model} & results_table.protocol == simulation_parameters.measurement_protocol{inx_protocol} & results_table.snr == simulation_parameters.simulated_SNRs(inx_snr) &  results_table.voxel_name == voxel_names{inx_voxel},1),0,1)  / Ground_Truth_Value ;

                            direct_values_table_tmp.(table_entries{inx_AxTM}) = mean(results_table.(table_entries{inx_AxTM})(results_table.algorithm == dki_model{inx_dki_model} & results_table.protocol == simulation_parameters.measurement_protocol{inx_protocol} & results_table.snr == simulation_parameters.simulated_SNRs(inx_snr) &  results_table.voxel_name == voxel_names{inx_voxel} ,1));
                            direct_values_table_tmp.(['standard_deviation_' table_entries{inx_AxTM}]) = std(results_table.(table_entries{inx_AxTM})(results_table.algorithm == dki_model{inx_dki_model} & results_table.protocol == simulation_parameters.measurement_protocol{inx_protocol} & results_table.snr == simulation_parameters.simulated_SNRs(inx_snr) &  results_table.voxel_name == voxel_names{inx_voxel},1),0,1);


                        elseif inx_AxTM == 6
                            bias_table_tmp.(table_entries{inx_AxTM}) =  string(voxel_names{inx_voxel});
                            direct_values_table_tmp.(table_entries{inx_AxTM}) =  string(voxel_names{inx_voxel});
                        elseif inx_AxTM == 7
                            bias_table_tmp.(table_entries{inx_AxTM}) =  simulation_parameters.simulated_SNRs(inx_snr);
                            direct_values_table_tmp.(table_entries{inx_AxTM}) =  simulation_parameters.simulated_SNRs(inx_snr);
                        elseif inx_AxTM == 8
                            bias_table_tmp.(table_entries{inx_AxTM}) =  string(simulation_parameters.measurement_protocol{inx_protocol});
                            direct_values_table_tmp.(table_entries{inx_AxTM}) =  string(simulation_parameters.measurement_protocol{inx_protocol});
                        elseif inx_AxTM == 9
                            bias_table_tmp.(table_entries{inx_AxTM}) =  string(dki_model{inx_dki_model});
                            direct_values_table_tmp.(table_entries{inx_AxTM}) =  string(dki_model{inx_dki_model});
                        end


                    end
                    bias_table = [bias_table;bias_table_tmp];
                    direct_values_table = [direct_values_table;direct_values_table_tmp];
                end
            end
        end
    end







end