function plot_voxel_positions_of_single_voxel_simulation(path_of_script,VG,masks)

%properties of contour plot:
lw = 1;
ls = '-';
lc = 'g';
adj = 10; % Adjusts LineWidth of Contourplot, the higher the thinner


a1 = 27;
a2 = 93;
a3 = 18;
a4 = 103;



path_image = [path_of_script filesep '..' filesep 'data' filesep 'dwi_images_used_to_estimate_ground_truth_tensors' filesep 'fit_results' filesep 'derivatives' filesep 'DKI-NLLS' filesep ...
    'eps2_4d_desc-ECMOCO-HySCO-RBC-DKI-NLLS-FA_map.nii'];

V1 = spm_vol(char(path_image));
image = acid_read_vols(V1,VG,1);

[voxel_masks,voxel_names] = get_voxels_to_be_simulated(VG);



groups = {[3,6], [9,10,11], 1,2,4,5,7,8,12};

f = figure('DefaultAxesFontSize',13);
set(0,'defaulttextinterpreter','latex')
tiledlayout(2,5,'TileSpacing','compact');
colormap(gray)
ax.('num_0') = nexttile([1 1]);
colormap(gray)
image_slice = squeeze(image(58,:,:));
% image_slice = image_slice(14:101,7:98);
%  img = imagesc(image_slice,[0 1]);
 img = imagesc(imrotate(image_slice,180),[0,1]);

title('Fractional anisotropy')
set(gca,'xtick',[])
set(gca,'ytick',[])
pbaspect([1 1 1]);
cl = colorbar('westoutside');

ystart = 100;
jj = 0;

for i = 101-sort([63,65,56,58,67,66,68,49,42],'descend')   

    xl = xline(i,'-','Color','white','LineWidth',1.5);

    y1 = ystart - jj*10;

   an = annotation('textarrow', 'String',['Slice ' num2str(101-i)],'Color','red','FontSize',18);
   an.Parent = f.CurrentAxes;
   an.X = [i-10 i];

   an.Y = [y1 y1];
   jj = jj +1;

end

aa = 1;
for inx_group = 1:numel(groups)
     ax.(['num_' num2str(inx_group)]) = nexttile([1 1]);

      group = groups{inx_group};
      kk = 1;
    for inx_voxel = group
        hold on

        name_fix = [voxel_names{inx_voxel}];
        mask = logical(voxel_masks.(voxel_names{inx_voxel}));
        [~,~,slice] = ind2sub(size(mask),find(mask == true));

        mask = mask((a1:a2),(a3:a4),slice);
        mask = imrotate(mask,270);

        if kk == 1
            image_slice = image((a1:a2),(a3:a4),slice);
            imagesc(imrotate(image_slice,270),[0 1]);
            wm_slice = masks.wm((a1:a2),(a3:a4),slice) *20;
            wm_slice = imrotate(wm_slice,270);
%             [contour_plot,properties] = contour(wm_slice,lc,'LineWidth',lw,'LineStyle',ls,'LevelStep',adj,'LineColor',lc,'DisplayName','White matter contour');
            if inx_group == 1 || inx_group == 6
%              cl = colorbar('westoutside');
            end
        end
        
       

        collection_of_slices(inx_group)  = slice;

        clear cl
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        set(gca,'XColor', 'none','YColor','none')

        [x_plot,y_plot] = ind2sub(size(mask),find(mask == true));
        [color,marker] = asign_hex_colors_to_voxels(name_fix);
        
        hold on
         pl(aa)= plot(y_plot,x_plot,'.','Color',color,'MarkerSize',11,'DisplayName',['Voxel' num2str(inx_voxel)]);
%          plot(y_plot,x_plot,'o','Color','white','MarkerSize',10,'DisplayName',['Voxel' num2str(inx_voxel)],'LineWidth', 3);

         an = annotation('textarrow', 'String',[num2str(inx_voxel)],'Color',color,'FontSize',8,'FontWeight','bold','LineWidth',2.5);
         an.Parent = f.CurrentAxes;
         adj_y = -7;
         adj_x = 5;
          if inx_voxel == 6; adj_x = 15; end
          if inx_voxel == 10; adj_x = 15; end
          if inx_voxel == 11; adj_x = -15; end
         an.X = [y_plot+adj_y y_plot];
         an.Y = [x_plot+adj_x x_plot];
        hold off
        title(['Slice ' num2str(slice)])
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        pbaspect([1 1 1]);
        hold off
            
        kk = kk +1;
        aa= aa+1;
    end
end

lgd = legend(pl,'Orientation','horizontal');
lgd.Layout.Tile= 'north';

set(findall(gcf,'-property','FontSize'),'FontSize',20)





end