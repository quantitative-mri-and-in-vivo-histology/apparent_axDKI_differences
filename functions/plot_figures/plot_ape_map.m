function plot_ape_map(fit_results,masks,apparent_differences,image_names_AxTM,image_names_BP)

%properties of contour plot:
lw = 1;
ls = '-';
lc = 'g';
adj = 12; % Adjusts LineWidth of Contourplot, the higher the thinner

fig = figure;
tiledlayout(2,5,'TileSpacing','Compact','Padding','Compact');
colormap(gray)
slice = 40;

latex_map_names_AxTM = {'$\overline{W}$','$W_{\parallel}$','$W_{\perp}$','$D_{\parallel}$','$D_{\perp}$',};
latex_map_names_BP = {'AWF','$\kappa$','$D_{e,\perp}$','$D_{e,\parallel}$','$D_{a}$',};

a1 = 27;
a2 = 93;
a3 = 18;
a4 = 103;

 [thresholds_for_plotting] = set_thresholds_for_image_plotting;

 for parameters = {'AxTM', 'BP'}

     if strcmp(parameters, 'AxTM')
         image_names = image_names_AxTM;
         thresholds = thresholds_for_plotting.AxTM;
         latex_names = latex_map_names_AxTM;
     elseif strcmp(parameters, 'BP')
         image_names = image_names_BP;
         thresholds = thresholds_for_plotting.BP;
         latex_names = latex_map_names_BP;
     end



     for inx_map = 1:5
         ax.(['num_' num2str(inx_map)]) = nexttile;

         [valid_field_name] = convert_image_names_to_valied_field_names(image_names{inx_map});

         image = fit_results.dki.(valid_field_name);
       

         image_slice = image((a1:a2),(a3:a4),slice);
         imagesc(imrotate(image_slice,90),[thresholds.lower thresholds.upper.(valid_field_name)]);
         title(latex_names{inx_map},'FontWeight','normal','Interpreter','latex');


         cl = colorbar('eastoutside');
%          cl.Position(1) = cl.Position(1) +0.06;

             if thresholds.upper.(valid_field_name) < 0.5
                 title(cl,'[$\frac{mm^2}{s}]$','Interpreter','latex')
             end

         clear cl
         set(gca,'xtick',[])
         set(gca,'ytick',[])

         apparent_differences_image = apparent_differences.bias.(parameters{1}).(valid_field_name);
         apparent_differences_image(~masks.wm) = 0;

         substantially_differnt_voxels_mask = false(size(apparent_differences_image));
         substantially_differnt_voxels_mask(find(apparent_differences_image>=5)) = true;

         substantially_differnt_voxels_mask_slice = substantially_differnt_voxels_mask((a1:a2),(a3:a4),slice);
         substantially_differnt_voxels_mask_slice = imrotate(substantially_differnt_voxels_mask_slice,90);

         [y,x] = find(substantially_differnt_voxels_mask_slice == true);

         hold on
         plot(x,y,'.r','DisplayName','A-PE > 5%','MarkerSize',9)
         hold off
         
         wm_slice = masks.wm((a1:a2),(a3:a4),slice) *20;
         wm_slice = imrotate(wm_slice,90);
         hold on
         [contour_plot,properties] = contour(wm_slice,lc,'LineWidth',lw,'LineStyle',ls,'LevelStep',adj,'LineColor',lc,'DisplayName','White matter contour');
         hold off


         set(gca,'xtick',[])
         set(gca,'ytick',[])
         pbaspect([1 1 1]);

         if inx_map == 5; legend; end


        clear substantially_differnt_voxels_mask substantially_differnt_voxels_mask_slice image image_slice 

     end
 end
 set(findall(gcf,'-property','FontSize'),'FontSize',24)


end