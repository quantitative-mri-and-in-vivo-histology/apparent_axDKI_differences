function [thresholds_for_plotting] = set_thresholds_for_image_plotting

    thresholds_for_plotting = struct;


    thresholds_for_plotting.AxTM.upper.MW = 2; 
    thresholds_for_plotting.AxTM.upper.AW = 5; 
    thresholds_for_plotting.AxTM.upper.RW = 2; 
    thresholds_for_plotting.AxTM.upper.AD = 3e-3; 
    thresholds_for_plotting.AxTM.upper.RD = 3e-3;  

    thresholds_for_plotting.AxTM.lower = 0;  

    thresholds_for_plotting.BP.upper.AWF = 1; 
    thresholds_for_plotting.BP.upper.KAPPA = 10; 
    thresholds_for_plotting.BP.upper.DE_PERP = 3e-3; 
    thresholds_for_plotting.BP.upper.DE_PARA = 3e-3; 
    thresholds_for_plotting.BP.upper.DA = 5e-3;  

    thresholds_for_plotting.BP.lower = 0;  

end