function  plot_median_values_SNR39_simulation(inx_protocol,precision_direct_values_for_specific_lambda,simulation_parameters,AxTM_names,inx_AxTM,analysis_mask,display_name_median,mean_bias,color_median)


            if inx_protocol ~=2

                for inx_snr = 1:numel(simulation_parameters.simulated_SNRs)
                    [outlier_removed_precision,rows_cols_removed] = rmoutliers(precision_direct_values_for_specific_lambda.(['SNR_' num2str(simulation_parameters.simulated_SNRs(inx_snr))]).(simulation_parameters.measurement_protocol{inx_protocol}).DKI.(AxTM_names{inx_AxTM})(analysis_mask),'median');
                    mean_value = median(outlier_removed_precision,'omitnan');
                    std_value = std(outlier_removed_precision,0,1,'omitnan');
                    disp(['Standard DKI: ' num2str(nnz(rows_cols_removed)*100/nnz(analysis_mask)) '% outlier voxels removed, parameter: ' AxTM_names{inx_AxTM} ', protocol: ' simulation_parameters.measurement_protocol{inx_protocol} ', SNR: ' num2str(simulation_parameters.simulated_SNRs(inx_snr))])
                end
            end



            for inx_snr = 1:numel(simulation_parameters.simulated_SNRs)
                [outlier_removed_precision,rows_cols_removed] = rmoutliers(precision_direct_values_for_specific_lambda.(['SNR_' num2str(simulation_parameters.simulated_SNRs(inx_snr))]).(simulation_parameters.measurement_protocol{inx_protocol}).DKIax.(AxTM_names{inx_AxTM})(analysis_mask),'median');
                mean_value = median(outlier_removed_precision,'omitnan');
                std_value = std(outlier_removed_precision,0,1,'omitnan');
                if inx_snr  == 1
                    errorbar(simulation_parameters.simulated_SNRs(inx_snr),mean_value, std_value,'Color',color_median,'Marker','_','LineWidth',2,'DisplayName',display_name_median,'LineStyle','none')
                else
                    errorbar(simulation_parameters.simulated_SNRs(inx_snr),mean_value, std_value,'Color',color_median,'Marker','_','LineWidth',2,'HandleVisibility','off','LineStyle','none')
                end
                disp(['AxDKI: ' num2str(nnz(rows_cols_removed)*100/nnz(analysis_mask)) '% outlier voxels removed, parameter: ' AxTM_names{inx_AxTM} ', protocol: ' simulation_parameters.measurement_protocol{inx_protocol} ', SNR: ' num2str(simulation_parameters.simulated_SNRs(inx_snr))])
                pbaspect([1  1.2 1])
                if mean_bias> mean_value
                    cprintf('*red',['Tipping point reached for, parameter: '  AxTM_names{inx_AxTM}  ', protocol: ' simulation_parameters.measurement_protocol{inx_protocol} ', SNR: ' num2str(simulation_parameters.simulated_SNRs(inx_snr))])
                end
            end



end