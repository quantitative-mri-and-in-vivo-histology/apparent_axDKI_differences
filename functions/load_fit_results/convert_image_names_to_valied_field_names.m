function [valid_field_name] = convert_image_names_to_valied_field_names(image_name)

if strcmp(image_name,'MW_map')
    valid_field_name = 'MW';
elseif strcmp(image_name,'AW_map')
    valid_field_name = 'AW';
elseif strcmp(image_name,'RW_map')
    valid_field_name = 'RW';
elseif strcmp(image_name,'AD_map')
    valid_field_name = 'AD';
elseif strcmp(image_name,'RD_map')
    valid_field_name = 'RD';
elseif strcmp(image_name,'AWF_map')
    valid_field_name = 'AWF';
elseif strcmp(image_name,'KAPPA_map')
    valid_field_name = 'KAPPA';
elseif strcmp(image_name,'DE-PERP_map')
    valid_field_name = 'DE_PERP';
elseif strcmp(image_name,'DE-PARA_map')
    valid_field_name = 'DE_PARA';
elseif strcmp(image_name,'DA_map')
    valid_field_name = 'DA';
end


end