function simulate_noisy_single_voxels(path_of_script,VG,bval,bvec,fit_data,path_defaults)

snrs = 1:1:140;
number_of_noise_samples  = 2500;

[voxel_names] = get_voxels_to_be_simulated;

load([path_of_script filesep '..' filesep 'data' filesep 'single_voxel_simulation_files_if_raw_data_not_available' filesep 'single_voxel_tensor_values.mat'])


simulation_parameters.simulated_SNRs = snrs;
simulation_parameters.measurement_protocol = {'standard','fast_199'};

outdir = [path_of_script filesep '..' filesep 'data' filesep 'simulation' filesep 'noisy_data' filesep 'single_voxels'];
create_directories_single_voxels(outdir, snrs, voxel_names,simulation_parameters);

outdir_fit_results = [path_of_script filesep '..' filesep 'data' filesep 'results' filesep 'noisy_data' filesep 'single_voxels'];
create_directories_single_voxels(outdir_fit_results, snrs, voxel_names,simulation_parameters);

[bval_199, bvec_199] = create_199_protocol();


%% Specify values for simulation
%  bval = bval/1000; %already divided the bval values by 1000

[design_matrix_kurtosis_standard_protocol] = design_matrix_standardDKI(bvec,bval(1,:));
[design_matrix_kurtosis_fast_199_protocol] = design_matrix_standardDKI(bvec_199,bval_199);

rng('default');

%% Simulation
for inx_protocol = 1: numel(simulation_parameters.measurement_protocol)
    if inx_protocol == 1
        design_matrix_kurtosis = design_matrix_kurtosis_standard_protocol;
        bvalues = bval;
        bvectors = bvec;
    elseif inx_protocol == 2
        design_matrix_kurtosis = design_matrix_kurtosis_fast_199_protocol;
        bvalues = bval_199;
        bvectors = bvec_199;
    end

    sz = [size(design_matrix_kurtosis,1) 1];
    simulated_signals = zeros([size(bvalues,2),number_of_noise_samples]);

    for inx_voxel = 1: numel(voxel_names)
        name_fix = [voxel_names{inx_voxel}];

        [simulation_tensor_values] =  single_voxel_tensor_values.(name_fix);

        for inx_snr = 1 : size(snrs,2)
            sigma = ( (1/(simulation_parameters.simulated_SNRs(inx_snr))) ) ;     %SNR = S0/sigma
            pd = makedist('Normal', 0, sigma);
            for inx_number_of_noise_samples = 1: number_of_noise_samples
                path_out = [outdir filesep voxel_names{inx_voxel} filesep 'simulated_SNR_' num2str(simulation_parameters.simulated_SNRs(inx_snr)) filesep simulation_parameters.measurement_protocol{inx_protocol}];

                traceterm_1 = ((simulation_tensor_values(1)+simulation_tensor_values(2)+simulation_tensor_values(3))/3); 
                traceterm = traceterm_1.^2;

                signal = exp(design_matrix_kurtosis(:,1:6) * squeeze(simulation_tensor_values(1:6)) +  traceterm.* (design_matrix_kurtosis(:,8:22) * squeeze(simulation_tensor_values(8:22)) ) )  ; 
                
                real = random(pd, sz);
                imaginary = random(pd,sz);
                contaminated_signal = abs( ( signal ) + complex ( real , imaginary ) ) ;
                signal = contaminated_signal;
     

                simulated_signals(:,inx_number_of_noise_samples) = signal .* 1000;
                clear signal
            end



            fname =['SNR_' num2str(simulation_parameters.simulated_SNRs(inx_snr)) '_' simulation_parameters.measurement_protocol{inx_protocol} '_protocol_voxel_' num2str(inx_voxel)];

            VG.fname =  [path_out filesep fname '.nii']  ;
            VG.descrip = 'NIFTI-1 Image';
            VG.dim = [2 number_of_noise_samples 2];

            k = 1;

            for slice = 2
                for i = 2
                    for j = 1: number_of_noise_samples
                        temporary_signal = reshape(simulated_signals(:,k), [1,1,numel(bvalues)]);
                        A(i, j, slice , 1:numel(bvalues)) = temporary_signal;
                        k = k+1;
                    end
                end
            end



            my_write_vol_nii(A(:,:,:,:) ,VG,'' ,'') ;

            if fit_data
                jobfile_dki = {[path_of_script filesep '..'  filesep 'batches' filesep 'batch_fit_dki_73e1d23dc_job.m']};
                jobfile_axdki = {[path_of_script filesep '..'  filesep 'batches' filesep 'batch_fit_axdki_73e1d23dc_job.m']};
                path_dMRI_dataset = VG.fname;
                path_fit_results = [outdir_fit_results filesep voxel_names{inx_voxel} filesep 'simulated_SNR_' num2str(snrs(inx_snr)) filesep simulation_parameters.measurement_protocol{inx_protocol}];
                roi = {''};

                fit_simulated_data(jobfile_axdki,path_dMRI_dataset,bvalues,bvectors,fname,path_defaults,path_fit_results,1,roi);
                fit_simulated_data(jobfile_dki,path_dMRI_dataset,bvalues,bvectors,fname,path_defaults,path_fit_results,1,roi);
            end

            clear A

        end
    end
end







end