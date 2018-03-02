/*
 *   Model homogeneous half space
 *   last update 11.04.02, T. Bohlen
 */

#include "fd.h"

void model_elastic(float  **  rho, float **  pi, float **  u){

	/*--------------------------------------------------------------------------*/
	/* extern variables */

	extern int NX, NY, NXG, NYG,  POS[3], L, MYID;
	extern char  MFILE[STRING_SIZE];	
	extern char INV_MODELFILE[STRING_SIZE];
	extern float DH;
	
	/* local variables */
	float vp, vs, rhov, grad1, grad2, grad3, x, depth, topo;
	int i, j, ii, jj;
	char modfile[STRING_SIZE]; 
	
	/* parameters for homogeneous medium */
	const float vp1=3200.0, vs1=1847.5, rho1=2200.0;
	
	/* parameters for air above topography */
	const float vp0=0.0, vs0=0.0, rho0=0.0;
	
	/* geometry of the topography */
	const float z0=2000.0, z1=2705.31, xlength=4000.0; 
	float zdiff = z1 - z0;
	
	/*-----------------------------------------------------------------------*/		
	/* loop over global grid */
		for (i=1;i<=NXG;i++){
			for (j=1;j<=NYG;j++){
							
				vp=vp1;
				vs=vs1;
				rhov=rho1;
				
				depth = j*DH;
				    x = i*DH;
				
				 topo = (zdiff/xlength) * x + z0;
				
				/* add topography */
				if(topo<depth){
				   vp=vp0;
				   vs=vs0;
				   rhov=rho0;
				}

					
				/* only the PE which belongs to the current global gridpoint 
				  is saving model parameters in his local arrays */
				if ((POS[1]==((i-1)/NX)) && 
				    (POS[2]==((j-1)/NY))){
					ii=i-POS[1]*NX;
					jj=j-POS[2]*NY;

					u[jj][ii]=vs;
					rho[jj][ii]=rhov;
					pi[jj][ii]=vp;
				}
			}
		}	

		
sprintf(modfile,"%s_rho.bin",INV_MODELFILE);
writemod(modfile,rho,3);
MPI_Barrier(MPI_COMM_WORLD);
if (MYID==0) mergemod(modfile,3);

sprintf(modfile,"%s_vs.bin",INV_MODELFILE);
writemod(modfile,u,3);
MPI_Barrier(MPI_COMM_WORLD);
if (MYID==0) mergemod(modfile,3);

sprintf(modfile,"%s_vp.bin",INV_MODELFILE);
writemod(modfile,pi,3);
MPI_Barrier(MPI_COMM_WORLD);
if (MYID==0) mergemod(modfile,3);

}



