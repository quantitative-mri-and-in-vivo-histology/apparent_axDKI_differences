function main_function_apparent_axDKI_differences

path_of_script = fileparts(mfilename('fullpath'));
addpath(genpath([path_of_script]));

raw_data_available = false; % raw data must not be uploaded to github

if raw_data_available == true
    simulation_and_analysis_if_raw_data_available(path_of_script)
elseif raw_data_available == false
    simulation_and_analysis_if_raw_data_NOT_available(path_of_script)
end

end