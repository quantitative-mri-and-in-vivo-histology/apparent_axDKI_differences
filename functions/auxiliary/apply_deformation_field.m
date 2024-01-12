function apply_deformation_field(path_deformation_field,path_template,paths_of_images_that_the_deformation_field_is_applied_to)

jobfile = {'/projects/crunchie/Malte/apparent_axdki_differences_paper/batches/batch_apply_deformation_field_73e1d23dc_job.m'};
jobs = repmat(jobfile, 1, 1);
inputs = cell(3, 1);

inputs{1, 1} = {path_deformation_field}; % Deformations: Deformation Field - cfg_files
inputs{2, 1} = {path_template}; % Deformations: Image to base Id on - cfg_files
inputs{3, 1} = paths_of_images_that_the_deformation_field_is_applied_to; % Deformations: Apply to - cfg_files

spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});


end