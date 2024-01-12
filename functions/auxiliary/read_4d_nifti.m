function [images] = read_4d_nifti(path)


if size(path,1) == 1
    struct4D = nifti(path);
    dim4D = struct4D.dat.dim;
    n = dim4D(4);
    if n == 1
        error('A single 3D source image was selected. Choose a single 4D volume or select all 3D volumes manually!');
    end
    files = strcat(repmat(path(1:end), n, 1), ',', num2str([1:n]'));
end




    volume = spm_vol(files(1,:));
    images = zeros([volume.dim,size(files,1)]);
    
    for inx = 1:size(files,1)
        vol = spm_vol(files(inx,:));
        images(:,:,:,inx) = acid_read_vols(vol,vol,1);
    end



end