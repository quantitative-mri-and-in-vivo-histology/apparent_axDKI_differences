function [rois_used_in_paper,roi_names,atlas_mask_struct,atlas_labels] = load_jhu_atlas_and_rois(msk_wm_non_logical,VG,path_of_script)

atlas_labels = importdata([path_of_script filesep '..'  filesep 'data' filesep 'jhu_atlas' filesep 'JHU-WhiteMatter-labels-2mm.txt']);
atlas_mask_struct = struct;

for index_JHU_atlas = 1:numel(atlas_labels)
   jhu_atlas_path =  [path_of_script filesep '..'  filesep 'data' filesep 'jhu_atlas' filesep 'applied_deformation_field_rJHU-ICBM-labels-1mm-label-' num2str(index_JHU_atlas) '_desc-.nii'];

   atlas_volume = spm_vol(jhu_atlas_path);
   atlas = acid_read_vols(atlas_volume,VG,1);


   atlas(find(isnan(atlas))) = 0;  
   threshold_atlas = prctile(atlas(find(atlas ~=0)),99.5,'all');


   atlas(find(atlas >= threshold_atlas)) = 1;
   atlas(find(atlas < threshold_atlas)) = 0;
   
   atlas_mask(:,:,:,index_JHU_atlas) = atlas .* msk_wm_non_logical;
   L = logical(atlas_mask(:,:,:,index_JHU_atlas));
   atlas_mask_cell{index_JHU_atlas} = L;
   

   atlas_mask_struct.(string(['label_number_' num2str(index_JHU_atlas)])) = L;

end




cc_mask = (atlas_mask(:,:,:,3) +  atlas_mask(:,:,:,4 )  + atlas_mask(:,:,:,5)) ;  
cc_mask (find(cc_mask>=1)) = 1;
rois_used_in_paper.cc = logical(cc_mask);

scr_mask = (atlas_mask(:,:,:,25) +  atlas_mask(:,:,:,26));
scr_mask(find(scr_mask>=1)) = 1;
rois_used_in_paper.scr = logical(scr_mask);


exc_mask = (atlas_mask(:,:,:,33) +  atlas_mask(:,:,:,34));
exc_mask(find(exc_mask>=1)) = 1;
rois_used_in_paper.exc = logical(exc_mask);


slf_mask = (atlas_mask(:,:,:,41) +  atlas_mask(:,:,:,42));
slf_mask(find(slf_mask>=1)) = 1;
rois_used_in_paper.slf = logical(slf_mask);

pcr_mask = (atlas_mask(:,:,:,27) +  atlas_mask(:,:,:,28));
pcr_mask(find(pcr_mask>=1)) = 1;
rois_used_in_paper.pcr = logical(pcr_mask);

roi_names = {'cc','scr','exc','slf','pcr'};


end