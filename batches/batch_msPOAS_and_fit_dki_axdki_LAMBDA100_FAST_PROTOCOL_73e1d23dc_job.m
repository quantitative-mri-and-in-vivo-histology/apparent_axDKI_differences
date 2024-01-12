%-----------------------------------------------------------------------
% Job saved on 15-Dec-2023 23:22:08 by cfg_util (rev $Rev: 6942 $)
% spm SPM - SPM12 (7219)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.tools.dti.startup.dummy_choice.existing.images_existing = '<UNDEFINED>';
matlabbatch{1}.spm.tools.dti.startup.dummy_choice.existing.bvals_bvecs.bvals_bvecs_exp_type.bvals_exp = '<UNDEFINED>';
matlabbatch{1}.spm.tools.dti.startup.dummy_choice.existing.bvals_bvecs.bvals_bvecs_exp_type.bvecs_exp = '<UNDEFINED>';
matlabbatch{1}.spm.tools.dti.startup.filename = '<UNDEFINED>';
matlabbatch{1}.spm.tools.dti.startup.p_out = '<UNDEFINED>';
matlabbatch{1}.spm.tools.dti.startup.acid_setdef.customised = '<UNDEFINED>';
matlabbatch{2}.spm.tools.dti.prepro_choice.poas.in_vols(1) = cfg_dep('Startup: Created/Imported 4D NIfTI file', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rsource'));
matlabbatch{2}.spm.tools.dti.prepro_choice.poas.mask = '<UNDEFINED>';
matlabbatch{2}.spm.tools.dti.prepro_choice.poas.bvals_bvecs.bvals_bvecs_exp_type.bvals_exp(1) = cfg_dep('Startup: Extracted/Imported b-values', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','bvals'));
matlabbatch{2}.spm.tools.dti.prepro_choice.poas.bvals_bvecs.bvals_bvecs_exp_type.bvecs_exp(1) = cfg_dep('Startup: Extracted/Imported b-vectors', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','bvecs'));
matlabbatch{2}.spm.tools.dti.prepro_choice.poas.kstar = 10;
matlabbatch{2}.spm.tools.dti.prepro_choice.poas.sigma_type.sigma_exp = '<UNDEFINED>';
matlabbatch{2}.spm.tools.dti.prepro_choice.poas.lambda = 100;
matlabbatch{2}.spm.tools.dti.prepro_choice.poas.kappa_type.kappa = 0.9999;
matlabbatch{2}.spm.tools.dti.prepro_choice.poas.ncoils = 1;
matlabbatch{3}.spm.tools.dti.fit_choice.dki_fit.dummy_DKI = 1;
matlabbatch{3}.spm.tools.dti.fit_choice.dki_fit.in_vols(1) = cfg_dep('msPOAS: Smoothed images', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rsource'));
matlabbatch{3}.spm.tools.dti.fit_choice.dki_fit.bvals_bvecs.bvals_bvecs_exp_type.bvals_exp(1) = cfg_dep('Startup: Extracted/Imported b-values', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','bvals'));
matlabbatch{3}.spm.tools.dti.fit_choice.dki_fit.bvals_bvecs.bvals_bvecs_exp_type.bvecs_exp(1) = cfg_dep('Startup: Extracted/Imported b-vectors', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','bvecs'));
matlabbatch{3}.spm.tools.dti.fit_choice.dki_fit.dummy_algo.nlls_axDKI.dummy_nlls = 1;
matlabbatch{3}.spm.tools.dti.fit_choice.dki_fit.dummy_algo.nlls_axDKI.dummy_RBC.RBC_OFF.dummy_RBC_OFF = 1;
matlabbatch{3}.spm.tools.dti.fit_choice.dki_fit.dummy_algo.nlls_axDKI.dummy_write_K = 1;
matlabbatch{3}.spm.tools.dti.fit_choice.dki_fit.dummy_algo.nlls_axDKI.n_workers = '<UNDEFINED>';
matlabbatch{3}.spm.tools.dti.fit_choice.dki_fit.mask = '<UNDEFINED>';
