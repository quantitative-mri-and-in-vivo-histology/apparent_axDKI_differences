function [simulated_tensors] = read_simulation_tensors(DT, KT)
%% prepare if first volume of a 4D file was selected

if size(DT,1) == 1
    struct4D = nifti(DT);
    dim4D = struct4D.dat.dim;
    n = dim4D(4);
    if n == 1
        error('A single 3D source image was selected. Choose a single 4D volume or select all 3D volumes manually!');
    end
    DT_files = strcat(repmat(DT(1:end-2), n, 1), ',', num2str([1:n]'));
end



if size(KT,1) == 1
    struct4D = nifti(KT);
    dim4D = struct4D.dat.dim;
    n = dim4D(4);
    if n == 1
        error('A single 3D source image was selected. Choose a single 4D volume or select all 3D volumes manually!');
    end
    KT_files = strcat(repmat(KT(1:end-2), n, 1), ',', num2str([1:n]'));
end



    volume = spm_vol(DT_files(1,:));
    simulated_tensors = zeros([volume.dim,22]);
    
    for inx = 1:22
        if inx <=6
             vol_DT = spm_vol(DT_files(inx,:));
            simulated_tensors(:,:,:,inx) = acid_read_vols(vol_DT,vol_DT,1) *1000; % *1000 to convert diffusivities units to um²/ms
        elseif inx == 7
            simulated_tensors(:,:,:,inx) = 1;
        elseif inx > 7
            vol_KT = spm_vol(KT_files(inx-7,:));
            simulated_tensors(:,:,:,inx) = acid_read_vols(vol_KT,vol_KT,1);
        end
    end


end