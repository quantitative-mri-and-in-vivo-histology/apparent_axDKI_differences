function  create_directories_noisy_whole_brains(outdir, snrs, number_of_noise_samples,simulation_parameters)

folder_data = [outdir filesep];

if ~exist(folder_data,'dir')
  status = mkdir(folder_data);
end
            

for inx_snr = 1 : size(snrs,2)
    folder_snr = [folder_data filesep 'simulated_SNR_' num2str(snrs(inx_snr))];
      if ~exist(folder_snr,'dir')
        status = mkdir(folder_snr);
      end

      for inx_number_of_noise_samples = 1: number_of_noise_samples

          folder_noise_sample = [folder_snr filesep 'noise_sample_' num2str(inx_number_of_noise_samples)];
          if ~exist(folder_noise_sample,'dir')
            status = mkdir(folder_noise_sample);
          end

                
                for inx_protocol = 1 : numel(simulation_parameters.measurement_protocol)
                    folder_protocol = [folder_noise_sample filesep simulation_parameters.measurement_protocol{inx_protocol}];
                   if ~exist(folder_protocol,'dir')
                      status = mkdir(folder_protocol);
                   end
                end




      end

      
end







