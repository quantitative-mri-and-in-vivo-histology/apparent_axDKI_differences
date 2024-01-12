function plot_noise_simulation_results_bias_bigger_std_analysis(simulation_parameters,is_precision_better_than_bias_in_perecent,precision_direct_values,latex_map_names,AxTM_names,apparent_differences,analysis_mask)

    upper_limit_plot = [1,1,1,1*1e-3,1*1e-4];
    lower_limit_plot = [-0.0,-0.0,-0.0,-0.0*1e-3,-0.0*1e-4];
    simulation_parameters.simulated_SNRs = [100,52,30,15,5];

    f = figure;
    tiledlayout(2,5);
    kk =1;

    for inx_protocol = 1 : numel(simulation_parameters.measurement_protocol)
        for inx_AxTM = 1:numel(AxTM_names)
            %%
            parameter_name = latex_map_names{inx_AxTM};
                ax.(['num_' num2str(kk)]) = nexttile;
                pbaspect([1 1 1]); 
            yyaxis(ax.(['num_' num2str(kk)]),'left')
                        set(gca,'YColor','blue')
            hold on
            mean_bias = median(apparent_differences.noise_free_whole_brain_simulation.direct_subtraction.AxTM.([AxTM_names{inx_AxTM}])(analysis_mask),'omitnan');
            plot(ax.(['num_' num2str(kk)]),[0 simulation_parameters.simulated_SNRs(1)],[mean_bias mean_bias],'DisplayName','Median difference between DKI models', 'Color','k','Linestyle' ,'--','LineWidth',2)
            hold off

            yyaxis(ax.(['num_' num2str(kk)]),'left')
            ax.(['num_' num2str(kk)]).YLim =([lower_limit_plot(inx_AxTM) upper_limit_plot(inx_AxTM)]);
            hold on
            plot_median_values_SNR39_simulation(inx_protocol,precision_direct_values.('whole_brains_lambda_equals_10'),simulation_parameters,AxTM_names,inx_AxTM,analysis_mask,'\lambda = 10',mean_bias,'b')
            plot_median_values_SNR39_simulation(inx_protocol,precision_direct_values.('whole_brains_lambda_equals_100'),simulation_parameters,AxTM_names,inx_AxTM,analysis_mask,'\lambda = 100',mean_bias,'cyan')
            hold off
            xlabel(['SNR'])
            if inx_AxTM == 1
              ylabel(['Median std'])
            end
            xlim([0 101])

            if inx_AxTM == 5 && inx_protocol == 1
                legend('Orientation','horizontal')
            end

            yyaxis(ax.(['num_' num2str(kk)]),'right')
            hold on
            set(gca,'YColor','red')
            if inx_AxTM == 5
             ylabel(['Voxels for which bias > std [%]'])
            end
            plot_single_voxel_values_SNR39_simulation(is_precision_better_than_bias_in_perecent.('whole_brains_lambda_equals_10'),AxTM_names,inx_AxTM,simulation_parameters,inx_protocol,'red','\lambda = 10')
            plot_single_voxel_values_SNR39_simulation(is_precision_better_than_bias_in_perecent.('whole_brains_lambda_equals_100'),AxTM_names,inx_AxTM,simulation_parameters,inx_protocol,'magenta','\lambda = 100')

            xticks([5 15 30 52 100])
            xticklabels({'5','15','30','52','100'})
            title(parameter_name,'Interpreter','latex');
            ylim(ax.(['num_' num2str(kk)]),[0 65])
            hold off
            kk = kk +1;
        end
    end
    set(findall(gcf,'-property','FontSize'),'FontSize',20)


end