function  plot_noise_simulation_results_single_voxels(path_of_script,table_entries,noise_free_AxTM_average_in_white_matter,bias_table,voxel_names,simulation_parameters,bias_computed_via,VG)


load([path_of_script filesep '..' filesep 'data' filesep 'simulation' filesep 'noisy_data' filesep 'single_voxels' filesep 'ground_truth_tables' filesep 'axDKI_difference_table_single_voxel_noise_simulation.mat'])
table_with_noise_free_differences_between_axDKI_and_sDKI = axDKI_difference_table_single_voxel_noise_simulation;


latex_map_names = {'$\overline{W}$','$W_{\parallel}$','$W_{\perp}$','$D_{\parallel}$','$D_{\perp}$'};

simulation_parameters.simulated_SNRs = 1:1:140;
[voxel_names_original] = get_voxels_to_be_simulated;


perc = 5;
threshold_table = table();
%%
 for inx_protocol = 1: numel(simulation_parameters.measurement_protocol)
    for inx_voxel = 1:numel(voxel_names)

            for inx_AxTM = 1:5
                hold on
                parameter = table_entries{inx_AxTM};
                voxel = voxel_names{inx_voxel};
                Ground_Truth_Value =  0;


                standardDKI = bias_table.(table_entries{inx_AxTM})(bias_table.algorithm == 'DKI-NLLS' & bias_table.protocol == simulation_parameters.measurement_protocol{inx_protocol} & bias_table.voxel_name == voxel,1);
                standardDKI_std = bias_table.(['standard_deviation_' table_entries{inx_AxTM}])(bias_table.algorithm == 'DKI-NLLS' & bias_table.protocol == simulation_parameters.measurement_protocol{inx_protocol} & bias_table.voxel_name == voxel,1);
                
                axDKI = bias_table.(table_entries{inx_AxTM})(bias_table.algorithm == 'DKIax-NLLS' & bias_table.protocol == simulation_parameters.measurement_protocol{inx_protocol} & bias_table.voxel_name == voxel,1);
                axDKI_std = bias_table.(['standard_deviation_' table_entries{inx_AxTM}])(bias_table.algorithm == 'DKIax-NLLS' & bias_table.protocol == simulation_parameters.measurement_protocol{inx_protocol} & bias_table.voxel_name == voxel,1);

                axDKI_inherent_bias = table_with_noise_free_differences_between_axDKI_and_sDKI.(table_entries{inx_AxTM})(table_with_noise_free_differences_between_axDKI_and_sDKI.voxel_name == voxel);

                [SNR_threshold_axDKI,SNR_threshold_DKI] = find_snr_threhsold_single_voxel_simulation(axDKI_inherent_bias,standardDKI_std,axDKI_std,simulation_parameters.simulated_SNRs);
                threshold_table_tmp = table();
                threshold_table_tmp.('threshold') = SNR_threshold_axDKI;
                threshold_table_tmp.('parameter') = string(table_entries{inx_AxTM});
                threshold_table_tmp.('voxel_name') = string(voxel);
                threshold_table_tmp.('protocol') = string(simulation_parameters.measurement_protocol{inx_protocol});                
                threshold_table_tmp.('algorithm') = "DKIax-NLLS";
                threshold_table =[threshold_table;threshold_table_tmp];

                threshold_table_tmp = table();
                threshold_table_tmp.('threshold') = SNR_threshold_DKI;
                threshold_table_tmp.('parameter') = string(table_entries{inx_AxTM});
                threshold_table_tmp.('voxel_name') = string(voxel);
                threshold_table_tmp.('protocol') = string(simulation_parameters.measurement_protocol{inx_protocol});                
                threshold_table_tmp.('algorithm') = "DKI-NLLS";
                threshold_table =[threshold_table;threshold_table_tmp];


                


            end
    end
end


position_of_bars = [0:1.5:16.5];

real_x_axis_figure_table_tmp = table();
real_x_axis_figure_table = table();


f = figure('DefaultAxesFontSize',13);
set(0,'defaulttextinterpreter','latex')
tiledlayout(2,5,'TileSpacing','compact');
kk = 1;
for inx_protocol = 1: numel (simulation_parameters.measurement_protocol)

        for inx_AxTM = 1:5
            parameter_name = string(table_entries{inx_AxTM});
            table_sorted_by_parameter = sortrows(table_with_noise_free_differences_between_axDKI_and_sDKI,parameter_name);

            voxel_names = table_sorted_by_parameter.voxel_name;

            ax.(['num_' num2str(kk)]) = nexttile;


            hold on
            for inx =1: numel(voxel_names)
                    voxel_name = voxel_names{inx};
                     voxel_number = find(strcmp(voxel_name,voxel_names_original));
                   [voxel_color,marker_symbol] = asign_hex_colors_to_voxels(voxel_name);
                    value = threshold_table.threshold(threshold_table.parameter ==  table_entries{inx_AxTM} &  threshold_table.algorithm == "DKIax-NLLS" &  threshold_table.protocol == simulation_parameters.measurement_protocol{inx_protocol} & threshold_table.voxel_name == voxel_name);
                    label = num2str(round(value));
                    is_value_nan = false;
                    if isnan(value) || value>140
                        value = 140;
                        label = '';
                        hb.(['num_' num2str(kk)])=bar(position_of_bars(inx),value,'HandleVisibility','off');
                        is_value_nan = true;

                    else
                     hb.(['num_' num2str(kk)])=bar(position_of_bars(inx),value,'HandleVisibility','off');
                    end

                    text(position_of_bars(inx), value, label,'HorizontalAlignment','center','VerticalAlignment','bottom')
               


                    if inx_protocol == 1
                        if ~is_value_nan
                            hb.(['num_' num2str(kk)]).FaceColor = 'white';
                            hb.(['num_' num2str(kk)]).EdgeColor = [.7 .7 .7];
                        else
                            hb.(['num_' num2str(kk)])(1).FaceColor = 'white';
                            hb.(['num_' num2str(kk)])(1).EdgeColor = [.7 .7 .7];

                        end
                    elseif inx_protocol == 2
                        if  ~is_value_nan

                            hb.(['num_' num2str(kk)]).FaceColor = 'white';
                            hb.(['num_' num2str(kk)]).EdgeColor = [.7 .7 .7];

                        else
                             hb.(['num_' num2str(kk)])(1).FaceColor = 'white';
                             hb.(['num_' num2str(kk)])(1).EdgeColor = [.7 .7 .7];
                        end
                    end

                    if inx_AxTM == 3 && inx_protocol == 1
                        legend
                    end
                  if strcmp(bias_computed_via,'directly subtracting the fit results')  
                    if inx_AxTM >= 4
                      xtick_names{inx} = (round( (table_sorted_by_parameter.(parameter_name)(inx)/ noise_free_AxTM_average_in_white_matter.([parameter_name]))*100 ,2));
                    else 
                      xtick_names{inx} = (round( (table_sorted_by_parameter.(parameter_name)(inx) / noise_free_AxTM_average_in_white_matter.([parameter_name]))*100,2));
                    end
                    xlabel(['Bias [%]'])

                  else
                    if inx_AxTM >= 4
                      xtick_names{inx} = (round(table_sorted_by_parameter.(parameter_name)(inx),8));
                    else 
                      xtick_names{inx} = (round(table_sorted_by_parameter.(parameter_name)(inx),3));
                    end
                    xlabel(['Bias'])

                  end

                    ylabel(['SNR where bias $>$ variance'])
                    title(latex_map_names{inx_AxTM},'Interpreter','latex')

                    real_x_axis_figure_table_tmp.parameter = string(parameter_name);
                    real_x_axis_figure_table_tmp.voxel_name = string(voxel_name);
                    real_x_axis_figure_table_tmp.snr_threshold = value;
                    real_x_axis_figure_table_tmp.bias = xtick_names{inx};
                    real_x_axis_figure_table_tmp.protocol = string(simulation_parameters.measurement_protocol(inx_protocol));
                    
                    real_x_axis_figure_table = [real_x_axis_figure_table; real_x_axis_figure_table_tmp];

                    xpos = position_of_bars(inx);
                    ypos = real_x_axis_figure_table.snr_threshold(real_x_axis_figure_table.parameter == parameter_name & real_x_axis_figure_table.protocol == simulation_parameters.measurement_protocol(inx_protocol)  & real_x_axis_figure_table.voxel_name == voxel_name)/2;
                    if inx_protocol == 1 && inx_AxTM == 1
                     pl(inx) = plot(xpos, ypos,'Marker',marker_symbol,'Color',voxel_color,'MarkerSize',12,'MarkerFaceColor',voxel_color, 'DisplayName',['Voxel ' num2str(voxel_number)],'LineStyle','none');
                    else
                     plot(xpos, ypos,'Marker',marker_symbol,'Color',voxel_color,'MarkerSize',12,'MarkerFaceColor',voxel_color, 'HandleVisibility','off','LineStyle','none');
                    end

            end
            xticks(position_of_bars);
            xticklabels(xtick_names)
            yline(140,'DisplayName','Max. simulated SNR: 140', 'LineStyle','--','LineWidth',2)
            hold off

            kk = kk + 1;
     
        end
end
    set(findall(gcf,'-property','FontSize'),'FontSize',20)

linkaxes([ax.num_1 ax.num_2 ax.num_3 ax.num_4 ax.num_5 ax.num_6 ax.num_7 ax.num_8 ax.num_9 ax.num_10],'xy')

%%


f = figure('DefaultAxesFontSize',13);
set(0,'defaulttextinterpreter','latex')
tiledlayout(2,5,'TileSpacing','compact');
kk = 1;
for inx_protocol = 1: numel (simulation_parameters.measurement_protocol)

        for inx_AxTM = 1:5
            parameter_name = string(table_entries{inx_AxTM});
            table_sorted_by_parameter = sortrows(table_with_noise_free_differences_between_axDKI_and_sDKI,parameter_name);
            voxel_names = table_sorted_by_parameter.voxel_name;

            ax.(['num_' num2str(kk)]) = nexttile;

            hold on

% 
%             biases = real_x_axis_figure_table.bias(real_x_axis_figure_table.parameter == parameter_name & real_x_axis_figure_table.protocol == simulation_parameters.measurement_protocol(inx_protocol));
%             snr_thresholds = real_x_axis_figure_table.snr_threshold(real_x_axis_figure_table.parameter == parameter_name & real_x_axis_figure_table.protocol == simulation_parameters.measurement_protocol(inx_protocol));
%             plot(biases,snr_thresholds,'Color','black','LineWidth',1.5,'LineStyle',':');

            ms = 35; %marker size
            for inx =1: numel(voxel_names)
                voxel_name = voxel_names{inx};
                voxel_number = find(strcmp(voxel_name,voxel_names_original));
                [voxel_color,marker_symbol] = asign_hex_colors_to_voxels(voxel_name);

                xpos(inx) = real_x_axis_figure_table.bias(real_x_axis_figure_table.parameter == parameter_name & real_x_axis_figure_table.protocol == simulation_parameters.measurement_protocol(inx_protocol)  & real_x_axis_figure_table.voxel_name == voxel_name);
                ypos(inx) = real_x_axis_figure_table.snr_threshold(real_x_axis_figure_table.parameter == parameter_name & real_x_axis_figure_table.protocol == simulation_parameters.measurement_protocol(inx_protocol)  & real_x_axis_figure_table.voxel_name == voxel_name);
                if inx_protocol == 1 && inx_AxTM == 1
                 pl(inx) = plot(xpos(inx), ypos(inx),'Marker','.','Color',voxel_color,'MarkerSize',ms,'MarkerFaceColor',voxel_color, 'DisplayName',['Voxel ' num2str(voxel_number)],'LineStyle','none');
                else
                 plot(xpos(inx), ypos(inx),'Marker','.','Color',voxel_color,'MarkerSize',ms,'MarkerFaceColor',voxel_color, 'HandleVisibility','off','LineStyle','none');
                end

            end
            
            for inx =1: numel(voxel_names)-1
               l = line([xpos(inx) xpos(inx+1)],[ypos(inx) ypos(inx+1)], 'Color',[.6 .6 .6],'Linewidth',2,'LineStyle','--');
                uistack(l,'bottom');
            end


            max_snr = yline(140,'DisplayName','Max. simulated SNR: 140', 'LineStyle','--','LineWidth',2);
            title(latex_map_names{inx_AxTM},'Interpreter','latex')
            xlabel('Bias [%]')
            if inx_AxTM == 1
             ylabel('SNR where bias $>$ std')
            end
            ylim([0 140])
            hold off


            kk = kk + 1;


        end

end
set(findall(gcf,'-property','FontSize'),'FontSize',20)
lgd = legend([pl,max_snr],'Orientation','horizontal');
lgd.Layout.Tile= 'north';






end