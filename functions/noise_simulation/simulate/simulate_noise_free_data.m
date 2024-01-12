function simulate_noise_free_data(path_of_script,VG,bval,bvec,simulated_tensors,b0,fit_data,path_defaults,masked_volume)


outdir = [path_of_script filesep '..' filesep 'data' filesep 'simulation' filesep 'noise_free_data'];
create_directories_noise_free_data(outdir);


%% Specify values for simulation
%  bval = bval/1000; %already divided the bval values by 1000

[design_matrix_kurtosis] = design_matrix_standardDKI(bvec,bval(1,:));


%% Simulation
simulated_signals = zeros([size(masked_volume), size(bval,2)]);

for slice = 1: VG.dim(3)
        voxel_position = find(masked_volume(:,:,slice) ==1);
        for inx_voxel = 1: nnz(masked_volume(:,:,slice))
            [x,y] = ind2sub(VG.dim(1:2),voxel_position(inx_voxel));
            traceterm_1 = ((simulated_tensors(x,y,slice,1)+simulated_tensors(x,y,slice,2)+simulated_tensors(x,y,slice,3))/3); %for the trace term in the DKI signal equation
            traceterm = traceterm_1.^2;
            signal = exp(design_matrix_kurtosis(:,1:6) * squeeze(simulated_tensors(x,y,slice,1:6)) +  traceterm.* (design_matrix_kurtosis(:,8:22) * squeeze(simulated_tensors(x,y,slice,8:22)) ) ) .* b0(x,y,slice); %b0(x,y,slice) ; % DKI-MODEL

            simulated_signals(x,y,slice,:) = signal; % The image intensities should be between 0 and 1000 for ACID
            clear signal
        end
end


name_fix = '_whole_brain';
fname =['NoiseFree_simulation' name_fix];
VG.fname =  [outdir filesep fname '.nii']  ;
VG.descrip = 'NIFTI-1 Image';

my_write_vol_nii(simulated_signals(:,:,:,:) ,VG,'' ,'') ;
if fit_data
    jobfile_dki = {[path_of_script filesep '..'  filesep 'batches' filesep 'batch_fit_dki_73e1d23dc_job.m']};
    jobfile_axdki = {[path_of_script filesep '..'  filesep 'batches' filesep 'batch_fit_axdki_73e1d23dc_job.m']};
    path_dMRI_dataset = VG.fname;
    path_dki_fit_results = [path_of_script filesep '..' filesep 'data' filesep 'results' filesep 'noise_free_whole_brain_simulation'];
    roi = {''};

    fit_simulated_data(jobfile_axdki,path_dMRI_dataset,bval,bvec,fname,path_defaults,path_dki_fit_results,36,roi);
    fit_simulated_data(jobfile_dki,path_dMRI_dataset,bval,bvec,fname,path_defaults,path_dki_fit_results,36,roi);
end

end