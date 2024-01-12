function simulation_main_function(path_of_script,VG,path_defaults)
    path_ground_truth_images = [path_of_script filesep '..' filesep  'data' filesep 'dwi_images_used_to_estimate_ground_truth_tensors' filesep 'fit_results' filesep 'derivatives' filesep 'DKI-NLLS'];
    
    
    simulated_tensors = read_simulation_tensors([path_ground_truth_images filesep 'eps2_4d_desc-ECMOCO-HySCO-RBC-DKI-NLLS-DT_map.nii,1'], ...
                                                [path_ground_truth_images filesep 'eps2_4d_desc-ECMOCO-HySCO-RBC-DKI-NLLS-KT_map.nii,1']); % diffusivities now in ms/um²
    
    b0_vol = spm_vol([path_ground_truth_images filesep 'eps2_4d_desc-ECMOCO-HySCO-RBC-DKI-NLLS-b0.nii']);
    b0 = acid_read_vols(b0_vol,b0_vol,1);
    
    
    masked_volume_tmp = spm_vol([path_of_script filesep '..' filesep 'data' filesep 'masks' filesep 'whole_brain_mask.nii']);
    masked_volume = acid_read_vols(masked_volume_tmp,masked_volume_tmp,1);
    masked_volume = logical(masked_volume);

    load([path_of_script filesep '..' filesep 'data' filesep 'simulation' filesep 'bvals_and_bvecs' filesep 'bval_bvec.mat']);

    %% Noise-free
    fit_data = true;
    simulate_noise_free_data(path_of_script,VG,bval,bvec,simulated_tensors,b0,fit_data,path_defaults,masked_volume);  
    %% Noisy whole brains
    fit_data = true;
    simulate_noisy_whole_brains(path_of_script,VG,bval,bvec,simulated_tensors,b0,fit_data,path_defaults,masked_volume);
    simulate_noisy_whole_brains_SNR_39(path_of_script,VG,bval,bvec,simulated_tensors,b0,fit_data,path_defaults,masked_volume);
    %% Single voxels
    fit_data = true;
    simulate_noisy_single_voxels(path_of_script,VG,bval,bvec,fit_data,path_defaults);
end