function  plot_coregistered_SNR39_whole_brain_simulation(coregistered_SNR39_whole_brain_simulation_bias_in_roi,roi_names)

statistics_in_atlas_subregions = table();

threshold_perc = 5;
struct_field_names = {'msPOAS_DKIax' , 'msPOAS_DKI'};


latex_map_names = {'$\overline{W}$','$W_{\parallel}$','$W_{\perp}$','$D_{\parallel}$','$D_{\perp}$',};
AxTM_names = {'MW','AW','RW','AD','RD'};



for inx_protocol = 1:2
    if inx_protocol == 1
        protocol_name = 'standard_protocol';
        results = struct_field_names;
    elseif inx_protocol == 2
        protocol_name = 'fast_199_protocol';
        results = {struct_field_names{1}};
    end


for inx_rois = 1:numel(roi_names)

    for inx_results = 1:numel(results)
        for inx_AxTM_names = 1:numel(AxTM_names)

            statistics_in_atlas_subregions_tmp = table();
            statistics_in_atlas_subregions_tmp.protocol = string(protocol_name);
            statistics_in_atlas_subregions_tmp.algorithm = string(results{inx_results});
            statistics_in_atlas_subregions_tmp.parameter = string(AxTM_names{inx_AxTM_names});
            statistics_in_atlas_subregions_tmp.label     = string(roi_names{inx_rois});



            bias_values_in_atlas_subregion = coregistered_SNR39_whole_brain_simulation_bias_in_roi.(protocol_name).(struct_field_names{inx_results}).(AxTM_names{inx_AxTM_names}).(roi_names{inx_rois});

            statistics_in_atlas_subregions_tmp.percentage_above_threshold = size(find(bias_values_in_atlas_subregion > threshold_perc),1) *100 / numel(bias_values_in_atlas_subregion);
            statistics_in_atlas_subregions_tmp.median_in_population_of_sdv = median(bias_values_in_atlas_subregion(find(bias_values_in_atlas_subregion > threshold_perc)),'omitnan');
            statistics_in_atlas_subregions_tmp.median = median(bias_values_in_atlas_subregion,'omitnan');

            statistics_in_atlas_subregions = [statistics_in_atlas_subregions;statistics_in_atlas_subregions_tmp];

        end
    end


end

end






figure;
tiledlayout(1,5,'TileSpacing','compact','Padding','loose');

    protocol_name = 'standard_protocol';
    results = struct_field_names;

    for inx_AxTM_names = 1:numel(AxTM_names)
        nexttile;
        
        hold on
        title([latex_map_names{inx_AxTM_names}],'FontWeight','normal','Interpreter','latex');

        for inx_results = 1:numel(results)

            if inx_results == 1
                data_color = 'red';
                marker = '.';
            elseif inx_results == 2
                data_color = 'blue';
                marker = '*';
            end
            ylabel(['Median bias in %']);
            xlabel(['ROI']);

            median_values = statistics_in_atlas_subregions.median(statistics_in_atlas_subregions.algorithm== string(results{inx_results}) & ...
                statistics_in_atlas_subregions.parameter == string(AxTM_names{inx_AxTM_names}) & ...
                statistics_in_atlas_subregions.protocol ==protocol_name);

            names_of_rois =  statistics_in_atlas_subregions.label(statistics_in_atlas_subregions.algorithm== string(results{inx_results}) & ...
                statistics_in_atlas_subregions.parameter == string(AxTM_names{inx_AxTM_names}) & ...
                statistics_in_atlas_subregions.protocol ==protocol_name);

            display_name = [protocol_name ', ' results{inx_results}];

            plot(1:5, median_values, 'DisplayName',display_name,'LineWidth',2, 'LineStyle','none','Color',data_color,'Marker',marker);

        end

        
            median_values_fast_protocol = statistics_in_atlas_subregions.median(statistics_in_atlas_subregions.algorithm== string(results{1}) & ...
                statistics_in_atlas_subregions.parameter == string(AxTM_names{inx_AxTM_names}) & ...
                statistics_in_atlas_subregions.protocol =='fast_199_protocol');

            display_name = ['fast 199 protocol, ' results{1}];

            plot(1:5, median_values_fast_protocol, 'DisplayName',display_name,'LineWidth',2, 'LineStyle','none','Color','magenta','Marker','^');


        xticks([1:5])
        xticklabels(names_of_rois)
        ylim([0 30])

        hold off
        if inx_AxTM_names == 5
           lgd =  legend('Orientation','horizontal');
           lgd.Layout.Tile = 'North';
        end
    end

set(findall(gcf,'-property','FontSize'),'FontSize',20)








 
end