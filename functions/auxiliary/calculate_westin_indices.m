function [westinIndices] = calculate_westin_indices(path_of_script,VG)

path_results = [path_of_script filesep '..' filesep 'data' filesep 'results'];

L1_map =  acid_read_vols(spm_vol([path_results filesep 'noise_free_whole_brain_simulation'  filesep 'derivatives' filesep 'DKI-NLLS' filesep 'NoiseFree_simulation_whole_brain_desc-DKI-NLLS-L1_map.nii']), VG,1);
L2_map =  acid_read_vols(spm_vol([path_results filesep 'noise_free_whole_brain_simulation'  filesep 'derivatives' filesep 'DKI-NLLS' filesep 'NoiseFree_simulation_whole_brain_desc-DKI-NLLS-L2_map.nii']), VG,1);
L3_map =  acid_read_vols(spm_vol([path_results filesep 'noise_free_whole_brain_simulation'  filesep 'derivatives' filesep 'DKI-NLLS' filesep 'NoiseFree_simulation_whole_brain_desc-DKI-NLLS-L3_map.nii']), VG,1);



westinIndices.cL = (L1_map-L2_map) ./ L1_map;
westinIndices.cP = (L2_map-L3_map) ./ L1_map;
westinIndices.cS = L3_map ./ L1_map;


end