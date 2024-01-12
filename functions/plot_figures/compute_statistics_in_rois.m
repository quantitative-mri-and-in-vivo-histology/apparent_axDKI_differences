function [coregistered_SNR39_whole_brain_simulation_bias_in_roi,coregistered_SNR39_whole_brain_simulation_bias_in_roi_as_array] = compute_statistics_in_rois(rois_used_in_paper,roi_names,coregistered_results,coregistered_results_bias_maps)


struct_field_names = {'msPOAS_DKIax' , 'msPOAS_DKI'};

empty = zeros(size(coregistered_results.fast_199_protocol.msPOAS_DKIax.AD));

AxTM_names = {'MW','AW','RW','AD','RD'};

for inx_protocol = 1:2
    if inx_protocol == 1
        protocol_name = 'standard_protocol';
        results = struct_field_names;
    elseif inx_protocol == 2
        protocol_name = 'fast_199_protocol';
        results = {struct_field_names{1}};
    end


for inx_roi = 1:numel(roi_names)
       
       mask = rois_used_in_paper.(roi_names{inx_roi});

    for inx_results = 1:numel(results)
        for inx_AxTM_names = 1:numel(AxTM_names)

            values_in_subregion = empty;

            values_in_subregion(mask) = coregistered_results_bias_maps.(protocol_name).(results{inx_results}).(AxTM_names{inx_AxTM_names})(mask);
            values_in_subregion_as_array = coregistered_results_bias_maps.(protocol_name).(results{inx_results}).(AxTM_names{inx_AxTM_names})(mask);

            coregistered_SNR39_whole_brain_simulation_bias_in_roi.(protocol_name).(results{inx_results}).(AxTM_names{inx_AxTM_names}).(string(roi_names{inx_roi})) =  values_in_subregion;
            coregistered_SNR39_whole_brain_simulation_bias_in_roi_as_array.(protocol_name).(results{inx_results}).(AxTM_names{inx_AxTM_names}).(string(roi_names{inx_roi})) =  values_in_subregion_as_array;
            

        end
    end
end 
   

end





