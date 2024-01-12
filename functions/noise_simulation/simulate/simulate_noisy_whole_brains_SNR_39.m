function simulate_noisy_whole_brains_SNR_39(path_of_script,VG,bval,bvec,simulated_tensors,b0,fit_data,path_defaults,masked_volume)

snrs = [39];
number_of_noise_samples  = 100;
%SNR:Veraart 2020 eLIFE, SNR = 52
%SNR:Veraart Manzanon-Patron, bioarxiv, SNR = 30,15,5

simulation_parameters.simulated_SNRs = snrs;
simulation_parameters.measurement_protocol = {'standard','fast_199'};

outdir = [path_of_script filesep '..' filesep 'data' filesep 'simulation' filesep 'noisy_data' filesep 'whole_brains'];
create_directories_noisy_whole_brains(outdir, snrs, number_of_noise_samples,simulation_parameters)

outdir_fit_results = [path_of_script filesep '..' filesep 'data' filesep 'results' filesep 'noisy_data' filesep 'whole_brains_lambda_equals_100'];
create_directories_noisy_whole_brains(outdir_fit_results, snrs, number_of_noise_samples,simulation_parameters)


[bval_199, bvec_199] = create_199_protocol();
%%


path_wm_westin_mask = [path_of_script filesep '..' filesep 'data' filesep 'masks' filesep 'WM_Westin_mask.nii'];
path_wm_mask = [path_of_script filesep '..' filesep 'data' filesep 'masks' filesep 'WM_mask.nii'];
signal_scaling_factor = mean(b0(msk_wm));


%% Specify values for simulation
%  bval = bval/1000; %already divided the bval values by 1000


[design_matrix_kurtosis_standard_protocol] = design_matrix_standardDKI(bvec,bval(1,:));
[design_matrix_kurtosis_fast_199_protocol] = design_matrix_standardDKI(bvec_199,bval_199);

rng('default');



%% Simulation

for inx_protocol = 1:2
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
    simulated_signals = zeros([size(masked_volume), size(bvalues,2)]);

    for inx_snr = 1 : size(snrs,2)
        sigma = ( (1/(simulation_parameters.simulated_SNRs(inx_snr))) ) ;     %SNR = S0/sigma
        pd = makedist('Normal', 0, sigma);

        for inx_number_of_noise_samples = 1
            path_out = [outdir filesep 'simulated_SNR_' num2str(simulation_parameters.simulated_SNRs(inx_snr)) filesep 'noise_sample_' num2str(inx_number_of_noise_samples) filesep simulation_parameters.measurement_protocol{inx_protocol}];
            for slice = 1: VG.dim(3)
                    voxel_position = find(masked_volume(:,:,slice) ==1);
                    for inx_voxel = 1: nnz(masked_volume(:,:,slice))
                        [x,y] = ind2sub(VG.dim(1:2),voxel_position(inx_voxel));

                        traceterm_1 = ((simulated_tensors(x,y,slice,1)+simulated_tensors(x,y,slice,2)+simulated_tensors(x,y,slice,3))/3); %for the trace term in the DKI signal equation
                        traceterm = traceterm_1.^2;
                        signal = (1/ signal_scaling_factor ) .* exp(design_matrix_kurtosis(:,1:6) * squeeze(simulated_tensors(x,y,slice,1:6)) +  traceterm.* (design_matrix_kurtosis(:,8:22) * squeeze(simulated_tensors(x,y,slice,8:22)) ) ) .* b0(x,y,slice); %b0(x,y,slice) ; % DKI-MODEL
                       
                        real = random(pd, sz);
                        imaginary = random(pd,sz);
                        contaminated_signal = abs( ( signal ) + complex ( real , imaginary ) ) ;
                        signal = contaminated_signal;
                        simulated_signals(x,y,slice,:) = signal .* signal_scaling_factor;
                        clear signal
                    end
            end
             name_fix = '_whole_brain';
             fname =['SNR_' num2str(simulation_parameters.simulated_SNRs(inx_snr)) '_simulation_with_' simulation_parameters.measurement_protocol{inx_protocol} '_protocol' name_fix '_noise_realisation_' num2str(inx_number_of_noise_samples)];
 
             VG.fname =  [path_out filesep fname '.nii']  ;
             VG.descrip = 'NIFTI-1 Image';
             my_write_vol_nii(simulated_signals(:,:,:,:) ,VG,'' ,'');



            if fit_data
                path_dMRI_dataset = VG.fname;
                path_fit_results = [outdir_fit_results filesep 'simulated_SNR_' num2str(simulation_parameters.simulated_SNRs(inx_snr)) filesep 'noise_sample_' num2str(inx_number_of_noise_samples) filesep simulation_parameters.measurement_protocol{inx_protocol}];
                roi = '';
                roi_msPOAS = '';
                noise_in_image = ( (1/(simulation_parameters.simulated_SNRs(inx_snr))) ) * signal_scaling_factor;     %SNR = S0/sigma
                

                if inx_protocol == 1
                    jobfile = {[path_of_script filesep '..'  filesep 'batches' filesep 'batch_msPOAS_and_fit_dki_axdki_LAMBDA100_73e1d23dc_job.m']};
                    fit_simulated_noisy_whole_brain_data_variable_lambda(jobfile,path_dMRI_dataset,bvalues,bvectors,fname,path_defaults,path_fit_results,70,roi,roi_msPOAS,noise_in_image)
                elseif inx_protocol == 2
                    jobfile_fast_protocol = {[path_of_script filesep '..'  filesep 'batches' filesep 'batch_msPOAS_and_fit_dki_axdki_LAMBDA100_FAST_PROTOCOL_73e1d23dc_job.m']};
                    fit_simulated_noisy_whole_brain_data_variable_lambda_fast(jobfile_fast_protocol,path_dMRI_dataset,bvalues,bvectors,fname,path_defaults,path_fit_results,70,roi,roi_msPOAS,noise_in_image)
                end
            end
  

        end
    end

end

end