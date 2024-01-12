function create_directories_single_voxels(outdir, snrs, voxel_names,simulation_parameters)

  
folder_data = [outdir filesep];

if ~exist(folder_data,'dir')
  status = mkdir(folder_data);
end
            

for inx_names = 1:numel(voxel_names)
    folder_voxel_name = [folder_data filesep voxel_names{inx_names}];
          if ~exist(folder_voxel_name,'dir')
            status = mkdir(folder_voxel_name);
          end

    for inx_snr = 1 : size(snrs,2)
        folder_snr = [folder_voxel_name filesep 'simulated_SNR_' num2str(snrs(inx_snr))];
          if ~exist(folder_snr,'dir')
            status = mkdir(folder_snr);
          end

          for inx_protocol = 1 : numel(simulation_parameters.measurement_protocol)
              folder_protocol = [folder_snr filesep simulation_parameters.measurement_protocol{inx_protocol}];
              if ~exist(folder_protocol,'dir')
                  status = mkdir(folder_protocol);
              end
          end


    end

end



end

