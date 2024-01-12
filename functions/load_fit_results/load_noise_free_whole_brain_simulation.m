function [noise_free_whole_brain_simulation,coregisered_noise_free_whole_brain_simulation] = load_noise_free_whole_brain_simulation(path_results,image_names_AxTM,image_names_BP,VG)

        path_dki_results = [path_results filesep 'noise_free_whole_brain_simulation' filesep 'derivatives' filesep];
        path_axdki_results = [path_results filesep 'noise_free_whole_brain_simulation' filesep 'derivatives' filesep];

        image_prefix_dki =  'NoiseFree_simulation_whole_brain_desc-DKI-NLLS-';
        image_prefix_axdki =  'NoiseFree_simulation_whole_brain_desc-DKIax-NLLS-';
        
        for inx_images = 1:numel(image_names_AxTM)
            
            [valid_field_name_dki] = convert_image_names_to_valied_field_names(image_names_AxTM{inx_images});
            [valid_field_name_bp] = convert_image_names_to_valied_field_names(image_names_BP{inx_images});



            
            V1 = spm_vol(char([path_dki_results filesep 'DKI-NLLS' filesep image_prefix_dki image_names_AxTM{inx_images} '.nii']));
            noise_free_whole_brain_simulation.dki.(valid_field_name_dki) = acid_read_vols(V1,VG,1);
     
           V2 = spm_vol(char([path_dki_results filesep 'WMTI-WATSON-PLUS' filesep image_prefix_dki 'WMTI-WATSON-PLUS-' image_names_BP{inx_images} '.nii']));
           noise_free_whole_brain_simulation.dki.(valid_field_name_bp) = acid_read_vols(V2,VG,1);
        
            V3 = spm_vol(char([path_axdki_results filesep 'DKIax-NLLS' filesep image_prefix_axdki image_names_AxTM{inx_images} '.nii']));
            noise_free_whole_brain_simulation.axdki.(valid_field_name_dki) = acid_read_vols(V3,VG,1);
     
            V4 = spm_vol(char([path_axdki_results filesep 'WMTI-WATSON-PLUS-Run_2' filesep image_prefix_axdki 'WMTI-WATSON-PLUS-' image_names_BP{inx_images} '.nii']));
            noise_free_whole_brain_simulation.axdki.(valid_field_name_bp)  = acid_read_vols(V4,VG,1);
        

        end


        path_coregistered_dki_results = [path_dki_results filesep 'DKI-NLLS'];

        image_prefix_dki =  'applied_deformation_field_NoiseFree_simulation_whole_brain_desc-DKI-NLLS-';

        for inx_images = 1:numel(image_names_AxTM)
            
            [valid_field_name_dki] = convert_image_names_to_valied_field_names(image_names_AxTM{inx_images});

            
            V1 = spm_vol(char([path_coregistered_dki_results filesep image_prefix_dki image_names_AxTM{inx_images} '.nii']));
            coregisered_noise_free_whole_brain_simulation.dki.(valid_field_name_dki) = acid_read_vols(V1,VG,1);
     
          

        end





end