function [fa_mask] = generate_FA_mask(fa_threshold,keyword,path_of_script)
   
    path_results = [path_of_script filesep '..' filesep 'data' filesep 'results'];

    fa_path =   [path_results filesep 'noise_free_whole_brain_simulation' filesep 'derivatives' filesep 'DKI-NLLS' filesep 'NoiseFree_simulation_whole_brain_desc-DKI-NLLS-FA_map.nii'];

    fa_vol = spm_vol(char(fa_path));
    fa_mask = acid_read_vols(fa_vol,fa_vol,0);

    if strcmp(keyword,'below_or_equal')
        idx_above = (fa_mask > fa_threshold);
        idx_below = (fa_mask <= fa_threshold);

        fa_mask(idx_above) = 0;
        fa_mask(idx_below) = 1;
    elseif strcmp(keyword, 'above_or_equal')
        idx_above = (fa_mask >= fa_threshold);
        idx_below = (fa_mask < fa_threshold);

        fa_mask(idx_above) = 1;
        fa_mask(idx_below) = 0;
    end

    fa_mask(isnan(fa_mask)) = 0;

    fa_mask = logical(fa_mask);

end