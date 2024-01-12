function [color,marker] = asign_hex_colors_to_voxels(voxel_name)

if strcmp(voxel_name,'AW_voxel3_plus_0_comma_010')
    color = '#2f4f4f';
    marker = '+';
elseif strcmp(voxel_name,'RW_voxel1_minus_0_comma_064')
    color = '#7f0000';
    marker = 'o';
elseif strcmp(voxel_name,'RW_voxel3_minus_0_comma_019')
    color = '#008000';
     marker = '*';
elseif strcmp(voxel_name,'AW_voxel4_plus_0_comma_029')
    color = '#00008b';
     marker = 'x';
elseif strcmp(voxel_name,'AW_voxel1_minus_0_comma_039')
    color = '#ff8c00';
     marker = 'square';
elseif strcmp(voxel_name,'RW_voxel2_minus_0_comma_039')
    color = '#ffff00';
     marker = 'diamond';
elseif strcmp(voxel_name,'AW_voxel2_minus_0_comma_009')
    color = '#00ff00';
     marker = 'pentagram';
elseif strcmp(voxel_name,'RW_voxel6_minus_0_comma_109')
    color = '#00ffff';
     marker = 'hexagram';
elseif strcmp(voxel_name,'RW_voxel4_minus_0_comma_014')
    color = '#ff00ff';
     marker = '^';
elseif strcmp(voxel_name,'AW_voxel5_plus_0_comma_106')
    color = '#1e90ff';
     marker = 'v';
elseif strcmp(voxel_name,'AW_voxel6_minus_0_comma_098')
    color = '#f5deb3';
     marker = '>';
elseif strcmp(voxel_name,'RW_voxel5_plus_0_comma_034')
    color = '#ff69b4';
     marker = '<';
end


end