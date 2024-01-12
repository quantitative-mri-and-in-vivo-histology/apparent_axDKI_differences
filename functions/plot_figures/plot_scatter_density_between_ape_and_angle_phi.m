function plot_scatter_density_between_ape_and_angle_phi(image_names,latex_map_names,apparent_differences,VG,masks,path_of_script)

 %properties for contour plot:
  lw = 0.6;
  ls = '-';
  lc = 'red';
fig = figure;

[twoDhistogram,angle_between_first_ev_and_c,linear_regression_model, pts_angle, pts_bias] = analyze_difference_between_c_and_firstEV(image_names,apparent_differences,VG,masks,path_of_script);

hold on
t = tiledlayout(5,1,'TileSpacing','Compact','Padding','Compact');
load('blue_white_red_colormap.mat');

 for inx_map = 1:size(image_names,2)
     
            sub = subplot(1,5,inx_map);
            imagesc(pts_angle,pts_bias,twoDhistogram.(image_names{inx_map})'); set(gca, 'YDir','normal','XDir','normal'); % histcount2 puts x(=angle) into rows and y(=differences) into columns, imagesc plots it the other way around, ie. rows to y and columns to x
            set(gca,'YLim',[0 15])
            set(gca,'XLim',[0 15])
            title([latex_map_names{inx_map}],'FontWeight','normal','Interpreter','latex'); 

          
      
            set(gca, 'YDir', 'normal');
            hold on
         if inx_map == 5 ; legend; end
            c2 = colorbar('eastoutside');
            title(c2, 'Counts')

            colormap(sub, blue_white_red_colormap)
            p_value = linear_regression_model.(image_names{inx_map}).Coefficients.pValue(2,1);

            if p_value <= 0.001
                p_value = '<0.001';
            else
                p_value = num2str(p_value);
            end

            xlabel(['Angle $\phi$ [$\circ$] between c and 1st EV'])
            ylabel(['A-PE [%]'])
            hold off
            clear c2
         
 end
    set(findall(gcf,'-property','FontSize'),'FontSize',24)

end