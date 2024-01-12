function plot_histograms_of_ape_distribution(apparent_differences,AxTM_names,latex_names,BP_names,latex_map_names_BP,msk_wm)

threshold_perc = 5;
linewidth = 2;
figure;

n_wm_msk = nnz(msk_wm);

for inx = 1:numel(AxTM_names)

     axtm_image =  zeros(size(apparent_differences.noise_free_whole_brain_simulation.bias.AxTM.(AxTM_names{inx})));
     axtm_image(msk_wm) = apparent_differences.noise_free_whole_brain_simulation.bias.AxTM.(AxTM_names{inx})(msk_wm);

     bp_image = zeros(size(apparent_differences.noise_free_whole_brain_simulation.bias.BP.(BP_names{inx})));
     bp_image(msk_wm) = apparent_differences.noise_free_whole_brain_simulation.bias.BP.(BP_names{inx})(msk_wm);


    median_mask.(AxTM_names{inx})=find(axtm_image > threshold_perc);
    median_mask.(BP_names{inx})=find(bp_image > threshold_perc);

    median.(AxTM_names{inx}) = nanmedian(squeeze(axtm_image(median_mask.(AxTM_names{inx}))));
    median.(BP_names{inx}) = nanmedian(squeeze(bp_image(median_mask.(BP_names{inx}))));

    percentage.(AxTM_names{inx}) =  size(median_mask.(AxTM_names{inx}),1)*100/n_wm_msk;
    percentage.(BP_names{inx}) =  size(median_mask.(BP_names{inx}),1)*100/n_wm_msk;
                 
          subplot(2,5,inx);

            hold on;
            histogram(squeeze(axtm_image(msk_wm)),'BinEdges',[0:0.5:30],'DisplayName','Differences between models');
            xlabel(['A-PE' newline 'Percentage of SDV:' num2str(round(percentage.(AxTM_names{inx}))) newline 'Median A-PE in SDV:' num2str(round(median.(AxTM_names{inx}))) ])
            ylabel(['Counts of voxels'])
            title([latex_names{inx}],'Interpreter','latex')
            if inx == 5; legend(); end
            xline(threshold_perc,'DisplayName','Threshold substantially differing voxles (SDV)', 'Color','magenta','LineWidth',linewidth);
            xline(median.(AxTM_names{inx}),'DisplayName','Median A-PE, SDV','LineWidth',linewidth, 'Color','blue');
            ylim([0 50000])
            hold off

           subplot(2,5,inx+5);


            hold on;
            histogram(squeeze(bp_image(msk_wm)),'BinEdges',[0:0.5:30],'DisplayName','Differences between models');
            xlabel(['A-PE' newline 'Percentage of SDV:' num2str(round(percentage.(BP_names{inx}))) newline 'Median A-PE in SDV:' num2str(round(median.(BP_names{inx}))) ])
            ylabel(['Voxel counts'])
            title([latex_map_names_BP{inx}],'Interpreter','latex')
%             if i == 5; legend(); end
            xline(threshold_perc,'DisplayName','Threshold substantially differing voxles (SDV)', 'Color','magenta','LineWidth',linewidth);
            xline(median.(BP_names{inx}),'DisplayName','Median A-PE, SDV','LineWidth',linewidth,'Color','blue');
            ylim([0 50000])
            hold off
          
            set(findall(gcf,'-property','FontSize'),'FontSize',24)


end



















