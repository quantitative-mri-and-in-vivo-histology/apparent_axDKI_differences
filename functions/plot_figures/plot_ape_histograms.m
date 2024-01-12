function plot_ape_histograms(masks,apparent_differences,image_names_AxTM,image_names_BP)

    latex_map_names_AxTM = {'$\overline{W}$','$W_{\parallel}$','$W_{\perp}$','$D_{\parallel}$','$D_{\perp}$',};
    latex_map_names_BP = {'AWF','$\kappa$','$D_{e,\perp}$','$D_{e,\parallel}$','$D_{a}$',};

    threshold_perc = 5;
    
    figure;
    tiledlayout(2,3,'TileSpacing','Compact','Padding','Compact');
    
 for inx_roi = 1:3

    if inx_roi == 1
        roi = masks.wm;
        title_name = 'WM mask';
    elseif inx_roi == 2
        roi = logical(masks.wm .* masks.fa);
        title_name = 'WM mask & FA mask';
    elseif inx_roi == 3
        roi = logical(masks.wm .* masks.westin_indices);
        title_name = 'WM mask & Westin mask';
    end

    n_roi = size(find(roi == true),1);

    for parameters = {'AxTM', 'BP'}
        
        if strcmp(parameters, 'AxTM')
            image_names = image_names_AxTM;
            nexttile(inx_roi)
        elseif strcmp(parameters, 'BP')
            image_names = image_names_BP;
            nexttile(inx_roi + 3)
        end



        for inx_map = 1:5

            [valid_field_name] = convert_image_names_to_valied_field_names(image_names{inx_map});

            masked_image = zeros(size(apparent_differences.bias.(parameters{1}).(valid_field_name)));
            masked_image(roi) = apparent_differences.bias.(parameters{1}).(valid_field_name)(roi);


            ape_mask.(valid_field_name) =  masked_image > threshold_perc;

            percentage.(valid_field_name) = size(find(ape_mask.(valid_field_name)==true),1)*100/n_roi;
            median.(valid_field_name) =  nanmedian(masked_image(ape_mask.(valid_field_name)));

            plot_names{inx_map} = [valid_field_name];
            if strcmp(parameters, 'AxTM')
                latex_plot_names{inx_map} = latex_map_names_AxTM{inx_map};
            elseif strcmp(parameters, 'BP')
                latex_plot_names{inx_map} =  latex_map_names_BP{inx_map};
            end
        end


        names_barplot = categorical(latex_plot_names);
        names_barplot = reordercats(names_barplot,latex_plot_names);


        hold on
        b1 = bar([names_barplot],[percentage.(plot_names{1}),percentage.(plot_names{2}),percentage.(plot_names{3}),percentage.(plot_names{4}),percentage.(plot_names{5}) ...
            ;median.(plot_names{1}),median.(plot_names{2}),median.(plot_names{3}),median.(plot_names{4}),median.(plot_names{5})]);
        ylim([0 75]);
        set(gca,'TickLabelInterpreter','latex')
        title([title_name]);

        labels1 = string(round(b1(1).YData));
        xtips1 = b1(1).XEndPoints;
        ytips1 = b1(1).YEndPoints;
        text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
            'VerticalAlignment','bottom')


        labels2 = string(round(b1(2).YData));
        xtips2 = b1(2).XEndPoints;
        ytips2 = b1(2).YEndPoints;
        text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
            'VerticalAlignment','bottom')

        set(b1(1,1),'DisplayName','Percentage of substantially differing WM voxels','FaceColor',[0.635294117647059 0.0784313725490196 0.184313725490196]);
        set(b1(1,2),'DisplayName','Median bias in percent','FaceColor',[0.0196078431372549 0.32156862745098 0.588235294117647]);


        set(findall(gcf,'-property','FontSize'),'FontSize',24)

        hold off


    end

 end
  legend('Location','northeast')
end

