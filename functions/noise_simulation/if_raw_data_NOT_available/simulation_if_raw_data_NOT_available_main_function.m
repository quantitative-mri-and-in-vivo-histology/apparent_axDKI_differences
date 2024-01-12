function simulation_if_raw_data_NOT_available_main_function(path_of_script,VG,path_defaults)
    load([path_of_script filesep '..' filesep 'data' filesep 'simulation' filesep 'bvals_and_bvecs' filesep 'bval_bvec.mat']);

    %% Single voxels
    fit_data = true;
    simulate_noisy_single_voxels(path_of_script,VG,bval,bvec,fit_data,path_defaults);


end