function [masks] = load_or_compute_masks(path_of_script,VG)
%% WM
    wm_mask_vol  = spm_vol([path_of_script filesep '..' filesep 'data' filesep 'masks' filesep 'thresholded_c2Masked_R1_Image.nii']);
    masks.wm     = logical(acid_read_vols(wm_mask_vol,VG,0));
%% FA
    [fa_mask] = generate_FA_mask(0.55,'above_or_equal',path_of_script);
    masks.fa = fa_mask;
%% Westin
    [westinIndices] = calculate_westin_indices(path_of_script,VG);
    westinIndices_mask =  false(size(masks.wm));
    westinIndices_mask(westinIndices.cL >= 0.4 & westinIndices.cP <= 0.2 & westinIndices.cS <= 0.35) = true;
    masks.westin_indices = westinIndices_mask;


    
end