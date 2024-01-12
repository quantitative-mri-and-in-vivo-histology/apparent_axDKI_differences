function [apparent_differences] = compute_apparent_differences(fit_results,image_names_AxTM,image_names_BP)

apparent_differences = struct;



for inx_images = 1:numel(image_names_AxTM)

    [valid_field_name_dki] = convert_image_names_to_valied_field_names(image_names_AxTM{inx_images});
    [valid_field_name_bp] = convert_image_names_to_valied_field_names(image_names_BP{inx_images});

    dki_map = fit_results.dki.(valid_field_name_dki);
    axdki_map = fit_results.axdki.(valid_field_name_dki);

    dki_based_bp_map = fit_results.dki.(valid_field_name_bp);
    axdki_based_bp_map = fit_results.axdki.(valid_field_name_bp);

    apparent_differences.bias.AxTM.(valid_field_name_dki) = 100* abs((dki_map - axdki_map) ./ dki_map);
    apparent_differences.bias.BP.(valid_field_name_bp) = 100* abs((dki_based_bp_map - axdki_based_bp_map) ./ dki_based_bp_map);

    apparent_differences.direct_subtraction.AxTM.(valid_field_name_dki) =  abs((dki_map - axdki_map));
    apparent_differences.direct_subtraction.BP.(valid_field_name_bp) =  abs((dki_based_bp_map - axdki_based_bp_map));



end




end