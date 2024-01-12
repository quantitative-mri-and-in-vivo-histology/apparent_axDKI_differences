function [twoDhistogram,angle_between_first_ev_and_c,linear_regression_model, pts_angle, pts_bias] = analyze_difference_between_c_and_firstEV(image_names_DKI,apparent_differences,VG,masks,path_of_script)    



         first_ev_path = [path_of_script filesep '..'  filesep 'data' filesep 'results' filesep 'noise_free_whole_brain_simulation' filesep 'derivatives' filesep 'DKI-NLLS' filesep 'NoiseFree_simulation_whole_brain_desc-DKI-NLLS-V1_map.nii'];

         axis_of_symmetry_path = { [path_of_script filesep '..'  filesep 'data' filesep 'results' filesep 'noise_free_whole_brain_simulation' filesep 'derivatives' filesep 'DKIax-NLLS' filesep 'NoiseFree_simulation_whole_brain_desc-DKIax-NLLS-aos-x_map.nii']
                                   [path_of_script filesep '..'  filesep 'data' filesep 'results' filesep 'noise_free_whole_brain_simulation' filesep 'derivatives' filesep 'DKIax-NLLS' filesep 'NoiseFree_simulation_whole_brain_desc-DKIax-NLLS-aos-y_map.nii']
                                   [path_of_script filesep '..'  filesep 'data' filesep 'results' filesep 'noise_free_whole_brain_simulation' filesep 'derivatives' filesep 'DKIax-NLLS' filesep 'NoiseFree_simulation_whole_brain_desc-DKIax-NLLS-aos-z_map.nii']};
    
        struct4D = nifti(first_ev_path);
        dim4D = struct4D.dat.dim;
        n = dim4D(4);

    ev_files = strcat(repmat(first_ev_path(1:end), n, 1), ',', num2str([1:n]'));

    volume = spm_vol(ev_files(1,:));
    volume = volume(1);
    first_ev = zeros([volume.dim,3]);

    for i =1:3
        ev_masked = zeros(VG.dim);

        vol_ev = spm_vol(ev_files(i,:));
        ev_tmp = acid_read_vols(vol_ev,volume,1);
        ev_masked(masks.wm) = ev_tmp(masks.wm);

        first_ev(:,:,:,i) = ev_masked;
    end

    for j =1:3
        c_masked = zeros(VG.dim);

        vol_c = spm_vol(axis_of_symmetry_path{j,:});
        c_tmp = acid_read_vols(vol_c,volume,1);
        c_masked(masks.wm) = c_tmp(masks.wm);
        
        c(:,:,:,j) = c_masked;
    end

angle_between_first_ev_and_c =  zeros([volume.dim,1]);

for x = 1:VG.dim(1)
    for y = 1:VG.dim(2)
        for z = 1:VG.dim(3)
         angle_between_first_ev_and_c(x,y,z) = acosd(abs(dot(squeeze(first_ev(x,y,z,1:3)),squeeze(c(x,y,z,1:3))) ./ (norm(squeeze(first_ev(x,y,z,1:3))) * norm(squeeze(c(x,y,z,1:3))))));
        end
    end
end


     twoDhistogram = struct;
     linear_regression_model = struct;
     nnz_mask = struct;

    map = zeros(size(angle_between_first_ev_and_c));

    for i = 1:numel(image_names_DKI)
        map(masks.wm) = apparent_differences.noise_free_whole_brain_simulation.bias.AxTM.(image_names_DKI{i})(masks.wm);
    
        nnz_mask.(image_names_DKI{i}) = (~isnan(map) & map < inf & angle_between_first_ev_and_c.*masks.wm <90);
    

        pts_angle = linspace(0,90,900);
        pts_bias = linspace(0,300,3000);

        twoDhistogram.(image_names_DKI{i}) = histcounts2(squeeze(angle_between_first_ev_and_c(nnz_mask.(image_names_DKI{i}))),squeeze(map(nnz_mask.(image_names_DKI{i}))),pts_angle,pts_bias);
        linear_regression_model.(image_names_DKI{i}) = fitlm(squeeze(angle_between_first_ev_and_c(nnz_mask.(image_names_DKI{i}))),squeeze(map(nnz_mask.(image_names_DKI{i}))), 'RobustOpts', 'off');
  
    
    end



end



