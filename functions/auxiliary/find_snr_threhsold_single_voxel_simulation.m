function [SNR_threshold_axDKI,SNR_threshold_DKI] = find_snr_threhsold_single_voxel_simulation(axDKI_inherent_bias,standardDKI_std,axDKI_std,snrs)


 index_of_interest = max(find(axDKI_std >= axDKI_inherent_bias));
 if and (~isempty(index_of_interest), snrs(index_of_interest) ~= max(snrs))
     SNR_threshold_axDKI = snrs(1+index_of_interest);
 else
     SNR_threshold_axDKI = NaN;
 end
    
 clear index_of_interest
  index_of_interest = max(find(standardDKI_std >= axDKI_inherent_bias));
 if and (~isempty(index_of_interest), snrs(index_of_interest) ~= max(snrs))
     SNR_threshold_DKI = snrs(1+index_of_interest);
 else
     SNR_threshold_DKI = NaN;
 end


end