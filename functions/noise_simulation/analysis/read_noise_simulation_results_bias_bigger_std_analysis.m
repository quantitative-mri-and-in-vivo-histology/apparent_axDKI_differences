function [is_precision_better_than_bias_in_perecent,precision_direct_values] = read_noise_simulation_results_bias_bigger_std_analysis(simulation_folder,pth,simulation_parameters,dki_model,dki_model_name,AxTM_names,VG,fit_results,apparent_differences,analysis_mask)

parameters = zeros([VG.dim 100]);

simulation_parameters.simulated_SNRs = [100,52,30,15,5];

is_precision_better_than_bias_in_perecent = table();
is_precision_better_than_bias_in_perecent_tmp = table();

precision = struct;
precision_direct_values = struct;
is_precision_better_than_bias_tmp = zeros(size(VG.dim));


fit_results_noise_simulation = struct;

for inx_protocol = 1 : numel(simulation_parameters.measurement_protocol)
    if inx_protocol == 1
        model_iterator = 1: numel(dki_model);
    elseif inx_protocol == 2
        model_iterator = 2;
    end
    for inx_snr = 1 : size(simulation_parameters.simulated_SNRs,2)
        snr = simulation_parameters.simulated_SNRs(inx_snr);
        for inx_dki_model = model_iterator
            for inx_AxTM = 1:numel(AxTM_names)
                %%
                for  inx_number_of_noise_samples = 1: simulation_parameters.number_of_noise_samples
                    disp(['SNR: ' num2str(simulation_parameters.simulated_SNRs(inx_snr)) ', noise sample: ' num2str(inx_number_of_noise_samples) ',protocol: ' simulation_parameters.measurement_protocol{inx_protocol} ', parameter: ' AxTM_names{inx_AxTM} ', dki model: ' dki_model{inx_dki_model}]);                                                                                                                                                                                                                                                    
                    volume_tmp = spm_vol([pth filesep simulation_folder filesep 'simulated_SNR_' num2str(snr) filesep 'noise_sample_' num2str(inx_number_of_noise_samples) filesep simulation_parameters.measurement_protocol{inx_protocol} '/derivatives/' dki_model{inx_dki_model} filesep 'SNR_' num2str(simulation_parameters.simulated_SNRs(inx_snr)) '_simulation_with_' simulation_parameters.measurement_protocol{inx_protocol} '_protocol_whole_brain_noise_realisation_' num2str(inx_number_of_noise_samples) '_desc-msPOAS-' dki_model{inx_dki_model} '-' AxTM_names{inx_AxTM} '_map.nii']);
                    parameters(:,:,:,inx_number_of_noise_samples) =  acid_read_vols(volume_tmp,volume_tmp,1);
                end
                        fit_results_noise_simulation.(['SNR_' num2str(simulation_parameters.simulated_SNRs(inx_snr))]).(simulation_parameters.measurement_protocol{inx_protocol}).(dki_model_name{inx_dki_model}).(AxTM_names{inx_AxTM}) = parameters;
                                  %%
                        precision_tmp = zeros(volume_tmp.dim);
                        precision_tmp = std(fit_results_noise_simulation.(['SNR_'  num2str(snr)]).(simulation_parameters.measurement_protocol{inx_protocol}).(dki_model_name{inx_dki_model}).(AxTM_names{inx_AxTM}),0, 4);
                        precision_tmp = 100*(precision_tmp./fit_results.noise_free_whole_brain_simulation.dki.([AxTM_names{inx_AxTM}]));
                        precision_tmp(precision_tmp == inf) = NaN;


                        precision_direct_values_tmp = zeros(volume_tmp.dim); % use direct values to compute differences instead of normalizing it to ground truth
                        precision_direct_values_tmp = std(fit_results_noise_simulation.(['SNR_'  num2str(snr)]).(simulation_parameters.measurement_protocol{inx_protocol}).(dki_model_name{inx_dki_model}).(AxTM_names{inx_AxTM}),0, 4,'omitnan');
                        precision_direct_values_tmp(precision_direct_values_tmp == inf) = NaN;

                        
                        
                        if inx_AxTM <= 2
                            precision_tmp(precision_tmp <0) = NaN;
                            display(['set negative ' AxTM_names{inx_AxTM} ' values to NaN']);
                        end
%%
                        precision_direct_values.(['SNR_' num2str(snr)]).(simulation_parameters.measurement_protocol{inx_protocol}).(dki_model_name{inx_dki_model}).(AxTM_names{inx_AxTM}) = precision_direct_values_tmp;
%%
                        is_precision_better_than_bias_tmp = precision_tmp < apparent_differences.noise_free_whole_brain_simulation.bias.AxTM.([AxTM_names{inx_AxTM}]); %"precision greater bias" means std<bias
                        is_precision_better_than_bias_direct_values_tmp = precision_direct_values_tmp < apparent_differences.noise_free_whole_brain_simulation.direct_subtraction.AxTM.([AxTM_names{inx_AxTM}]); %"precision greater bias" means std<bias

                        is_precision_better_than_bias_in_perecent_tmp.SNR = snr;
                        is_precision_better_than_bias_in_perecent_tmp.dki_model = string(dki_model{inx_dki_model});
                        is_precision_better_than_bias_in_perecent_tmp.AxTM =  string(AxTM_names{inx_AxTM});
                        is_precision_better_than_bias_in_perecent_tmp.protocol =  string(simulation_parameters.measurement_protocol{inx_protocol});

                        is_precision_better_than_bias_in_perecent_tmp.percentage = nnz(is_precision_better_than_bias_tmp(analysis_mask))*100/nnz(analysis_mask);
                        is_precision_better_than_bias_in_perecent_tmp.percentage_direct_values =  nnz(is_precision_better_than_bias_direct_values_tmp(analysis_mask))*100/nnz(analysis_mask);

                        is_precision_better_than_bias_in_perecent = [is_precision_better_than_bias_in_perecent;is_precision_better_than_bias_in_perecent_tmp];


            end
        end

    end
end

end