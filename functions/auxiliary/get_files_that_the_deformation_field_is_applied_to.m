function [file_names] = get_files_that_the_deformation_field_is_applied_to(folderPath,pattern,pattern_to_exclude)


files = dir(fullfile(folderPath, '*.nii')); 

matchedFiles = [];

for i = 1:numel(files)
    if ~isempty(regexp(files(i).name, pattern, 'once')) && isempty(regexp(files(i).name, pattern_to_exclude, 'once'))
        matchedFiles = [matchedFiles; files(i)]; 
    end
end


for i = 1:numel(matchedFiles)
    file_names{i,:} = [folderPath (matchedFiles(i).name)];
end


end