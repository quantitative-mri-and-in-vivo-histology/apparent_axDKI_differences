<div align="center">

# Investigating apparent differences between standard DKI and axisymmetric DKI and its consequences for biophysical parameter estimates

</div>

# Description
Code used for simulation and analysis of "Investigating apparent differences between standard DKI and axisymmetric DKI and its consequences for biophysical parameter estimates". 
# Installation
## Clone repository
```bash
git clone https://github.com/quantitative-mri-and-in-vivo-histology/apparent_axDKI_differences.git
```

## Setup Matlab toolboxes
Install spm12 (https://www.fil.ion.ucl.ac.uk/spm/software/spm12/) and ACID toolbox (https://bitbucket.org/siawoosh/acid-artefact-correction-in-diffusion-mri/src/master/) for Matlab. Reset ACID toolbox to Commit 73e1d23dc.
# How to run
- Open Matlab, add spm12 folder to Matlab path and open spm12. 
- Run "functions\main_function_apparent_axDKI_differences.m" to simulate and analyze paper data used for Figure 4. 
- The complete human brain data used in the paper cannot be published, therefore the code as is only reproduces Figure 4. Simulation, analysis and figure generation of the other figures is still documented in "functions\auxiliary\simulation_and_analysis_if_raw_data_available.m" but wont run without the raw data.


