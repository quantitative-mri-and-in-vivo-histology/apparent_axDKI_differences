function [first_noise_free_whole_brain_simulation] = load_first_noise_free_whole_brain_simulation(path_results,image_names_AxTM,image_names_BP,VG)


        path_dki_results = [path_results filesep 'first_noise_free_whole_brain_simulation' filesep 'dki' filesep];
        path_axdki_results = [path_results filesep 'first_noise_free_whole_brain_simulation' filesep 'axdki' filesep];

        image_prefix_dki =  'NoiseFree_simulation_whole_brain_eps2_001_desc-DKI-NLLS-';
        image_prefix_axdki =  'NoiseFree_simulation_whole_brain_eps2_001_desc-DKIax-NLLS-';
        
        for inx_images = 1:numel(image_names_AxTM)
            
            [valid_field_name_dki] = convert_image_names_to_valied_field_names(image_names_AxTM{inx_images});
            [valid_field_name_bp] = convert_image_names_to_valied_field_names(image_names_BP{inx_images});


            first_noise_free_whole_brain_simulation.axdki.(valid_field_name_dki) = zeros(VG.dim);
            first_noise_free_whole_brain_simulation.dki.(valid_field_name_dki) = zeros(VG.dim);
            
            V1 = spm_vol(char([path_dki_results filesep image_prefix_dki image_names_AxTM{inx_images} '.nii']));
            dki_map = acid_read_vols(V1,VG,1);

     
            V2 = spm_vol(char([path_dki_results filesep image_prefix_dki 'WMTI-WATSON-PLUS-' image_names_BP{inx_images} '.nii']));
            first_noise_free_whole_brain_simulation.dki.(valid_field_name_bp) = acid_read_vols(V2,VG,1);
        
            V3 = spm_vol(char([path_axdki_results filesep image_prefix_axdki image_names_AxTM{inx_images} '.nii']));
            axdki_map = acid_read_vols(V3,VG,1);



            first_noise_free_whole_brain_simulation.axdki.(valid_field_name_dki)(dki_map >0 & axdki_map >0) = axdki_map(dki_map >0 & axdki_map >0);
     
            first_noise_free_whole_brain_simulation.dki.(valid_field_name_dki)(dki_map >0 & axdki_map >0) = dki_map(dki_map >0 & axdki_map >0);

            V4 = spm_vol(char([path_axdki_results filesep image_prefix_axdki 'WMTI-WATSON-PLUS-' image_names_BP{inx_images} '.nii']));
            first_noise_free_whole_brain_simulation.axdki.(valid_field_name_bp)  = acid_read_vols(V4,VG,1);
        

        end



end