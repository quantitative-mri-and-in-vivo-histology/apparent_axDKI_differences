function create_directories_noise_free_data(outdir)


folder_simulation_data = [outdir filesep];

if ~exist(folder_simulation_data,'dir')
  status = mkdir(folder_simulation_data);
end

      
end







