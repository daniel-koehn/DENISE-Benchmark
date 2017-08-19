# DENISE-Benchmark
Benchmark problems for DENISE-Black-Edition and GERMAINE

Collection of benchmark problems including input-, source and receiver files for DENISE-Black-Edition.
Input files might not up to date with the latest version of DENISE-Black-Edition. Therefore, always compare the 
contents with the files in the DENISE-Black-Edition/par directory, e.g. with 

diff FWI_workflow_marmousi.inp DENISE-Black-Edition/par/FWI_workflow_marmousi.inp

Currently the following benchmark problems are included:

- 2 cross TE mode example
- 2 inclusion toy example
- acoustic analytical solution
- anisotropic elastic VTI/TTI zinc model
- simple anisotropic elastic TTI RTM test problem
- Modified Marmousi-II problem for different acquisition geometries
- 2D isotropic elastic Overthrust model
- Rayleigh wave ultrasonic data from the Porta Nigra in Trier (Germany)

Visualization of the FWI results can be accomplished with Matplotlib and custom colormaps.
