/*
 *   Simple, elastic anisotropic VTI/TTI RTM test problem
 * 
 *   
 *   last update 16/02/2017 
 *   D. Koehn
 *
 */

#include "fd.h"

void model_elastic_TTI(float  **  rho, float **  c11, float **  c13, float **  c33, float **  c44, float **  theta){

	/*--------------------------------------------------------------------------*/
	/* global variables */
	extern int NX, NY, NXG, NYG,  POS[3], MYID;
	extern char  MFILE[STRING_SIZE], INV_MODELFILE[STRING_SIZE];	
	extern float DH;
	
        /* local variables */	
	int i, j, ii, jj;
	char filename[STRING_SIZE];
	float y;
	
	/* anisotropic parameters in the layers */
	float vp0, vsv, rhoh, delta, epsilon, thetah;	
	
	/* 1st layer: isotropic acoustic water layer */
        float vp01 = 1500.0, vsv1 = 0.0, rhoh1 = 1000.0, delta1 = 0.0, epsilon1 = 0.0, thetah1 = 0.0;	
	
	/* 2nd layer: anisotropic VTI medium */
	float vp02 = 1800.0, vsv2 = 1040.0, rhoh2 = 2000.0, delta2 = 0.70968, epsilon2 = 0.830645, thetah2 = 0.0;
	
	/* 3rd layer: anisotropic TTI medium */
	float vp03 = 2200.0, vsv3 = 1270.0, rhoh3 = 2000.0, delta3 = 0.70968, epsilon3 = 0.830645, thetah3 = 0.0;
	
	/* 4th layer: anisotropic TTI medium */
	float vp04 = 2800.0, vsv4 = 1620.0, rhoh4 = 2000.0, delta4 = 0.70968, epsilon4 = 0.830645, thetah4 = 0.0;
		

        /* transform Thomsen's parameters to elastic tensor components */
        float c33h, c44h, c11h, c13h;
	
	float d1=300.0, d2=450.0, d3=1100.0;
		
	/*-----------------------------------------------------------------------*/

		
	/* loop over global grid */
		for (i=1;i<=NXG;i++){
			for (j=1;j<=NYG;j++){
			
			        /* properties of the first layer */
				vp0 = vp01; vsv = vsv1; rhoh = rhoh1; delta = delta1; epsilon = epsilon1; thetah = thetah1;
				
				
				/* calculate depth */
				y = j*DH;
				
				if(y > d1){vp0 = vp02; vsv = vsv2; rhoh = rhoh2; delta = delta2; epsilon = epsilon2; thetah = thetah2;}
				if(y > d2){vp0 = vp03; vsv = vsv3; rhoh = rhoh3; delta = delta3; epsilon = epsilon3; thetah = thetah3;}	
				if(y > d3){vp0 = vp04; vsv = vsv4; rhoh = rhoh4; delta = delta4; epsilon = epsilon4; thetah = thetah4;}				
			
			        /* transform Thomsen's parameters to elastic tensor components */
        			c33h = rhoh * vp0 * vp0;
        			c44h = rhoh * vsv * vsv;
			 	c11h = c33h * (1 + 2.0 * epsilon);
				c13h = sqrt((c33h-c44h) * (c33h-c44h) + 2.0 * delta * c33h * (c33h - c44h)) - c44h;
											
       				/* only the PE which belongs to the current global gridpoint 
				  is saving model parameters in his local arrays */
				if ((POS[1]==((i-1)/NX)) && 
				    (POS[2]==((j-1)/NY))){
					ii=i-POS[1]*NX;
					jj=j-POS[2]*NY;

					c11[jj][ii]=c11h;
					c13[jj][ii]=c13h;
					c33[jj][ii]=c33h;
					c44[jj][ii]=c44h;
					theta[jj][ii]=thetah * M_PI / 180.0;
					rho[jj][ii]=rhoh;
					
				}
			}
		}	

	/* each PE writes his model to disk and PE 0 merges model files */
	sprintf(filename,"%s.denise.c11",MFILE);
	writemod(filename,c11,3);
	MPI_Barrier(MPI_COMM_WORLD);

	if (MYID==0) mergemod(filename,3);
	
	sprintf(filename,"%s.denise.c13",MFILE);
        writemod(filename,c13,3);
	MPI_Barrier(MPI_COMM_WORLD);
	                           
	if (MYID==0) mergemod(filename,3);
	
	sprintf(filename,"%s.denise.c33",MFILE);
	writemod(filename,c33,3);
	MPI_Barrier(MPI_COMM_WORLD);
	                        
	if (MYID==0) mergemod(filename,3);

        sprintf(filename,"%s.denise.c44",MFILE);
	writemod(filename,c44,3);
	MPI_Barrier(MPI_COMM_WORLD);
	                        
	if (MYID==0) mergemod(filename,3);

	sprintf(filename,"%s.denise.theta",MFILE);
	writemod(filename,theta,3);
	MPI_Barrier(MPI_COMM_WORLD);
	                        
	if (MYID==0) mergemod(filename,3);

        /* clean up temporary files */
        MPI_Barrier(MPI_COMM_WORLD);

        sprintf(filename,"%s.denise.c11.%i%i",MFILE,POS[1],POS[2]);
        remove(filename);

        sprintf(filename,"%s.denise.c13.%i%i",MFILE,POS[1],POS[2]);
        remove(filename);

        sprintf(filename,"%s.denise.c33.%i%i",MFILE,POS[1],POS[2]);
        remove(filename);

        sprintf(filename,"%s.denise.c44.%i%i",MFILE,POS[1],POS[2]);
        remove(filename);

        sprintf(filename,"%s.denise.theta.%i%i",MFILE,POS[1],POS[2]);
        remove(filename);

}



