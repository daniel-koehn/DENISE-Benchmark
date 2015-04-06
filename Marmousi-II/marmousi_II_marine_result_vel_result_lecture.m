% Plot FWI results
% Daniel Koehn
%
% Kiel, the 2nd of September 2013

clear all;
close all;

% load marine FWI colormap
load('../custom_cmap/FWI_marine');

% File extension for output of the results
% IMG_EXT = 'png';
% IMG_FORMAT = 'png';

IMG_EXT = 'eps';
IMG_FORMAT = 'psc2';

% write model output files
WRITEMODE=0;
READMODE=1;

% Material parameter
% SHOW = 1 - P-wave velocity
% SHOW = 2 - S-wave velocity
% SHOW = 3 - Density
SHOW=2;

% SMOOTH = 1 - smooth model with Laplacian 
SMOOTH=0;

% SHOW1==1 - show each parameter in one plot
% SHOW1==3 - show profile through anomalies 
SHOW1=1;

FW=0.0;
FSize=20;

itmin=4;
itmax=4;

nx=500;
ny=174;

nx1=nx;
ny1=ny;

for itnum=itmin:1:itmax
if(READMODE==1)

% load true model
 file=['classical_FWT/start/Vel/marmousi_II_marine.vp'];
 disp([' loading file ' file]);
 fid=fopen(file,'r','ieee-le');
 vp_mod=fread(fid,[ny,nx],'float');
 fclose(fid);
    
% load true model
 file=['classical_FWT/start/Vel/marmousi_II_smooth2.vp'];
 disp([' loading file ' file]);
 fid=fopen(file,'r','ieee-le');
 vp_start=fread(fid,[ny,nx],'float');
 fclose(fid);
 
% load inversion_result
 file=['VSP_FWT/LBFGS/05_04_2015/modelTest_vp_stage_',int2str(itnum),'.bin'];
 disp([' loading file ' file]);
 fid=fopen(file,'r','ieee-le');
 vp_result=fread(fid,[ny1,nx1],'float');
 fclose(fid);

% load true model
 file=['classical_FWT/start/Vel/marmousi_II_marine.vs'];
 disp([' loading file ' file]);
 fid=fopen(file,'r','ieee-le');
 vs_mod=fread(fid,[ny,nx],'float');
 fclose(fid);
    
% load true model
 file=['classical_FWT/start/Vel/marmousi_II_smooth2.vs'];
 disp([' loading file ' file]);
 fid=fopen(file,'r','ieee-le');
 vs_start=fread(fid,[ny,nx],'float');
 fclose(fid);
 
% load inversion_result
 file=['VSP_FWT/LBFGS/05_04_2015/modelTest_vs_stage_',int2str(itnum),'.bin'];
 disp([' loading file ' file]);
 fid=fopen(file,'r','ieee-le');
 vs_result=fread(fid,[ny1,nx1],'float');
 fclose(fid);


 % load true model
 file=['classical_FWT/start/Vel/marmousi_II_marine.rho'];
 disp([' loading file ' file]);
 fid=fopen(file,'r','ieee-le');
 rho_mod=fread(fid,[ny,nx],'float');
 fclose(fid);
    
% load true model
 file=['classical_FWT/start/Vel/marmousi_II_smooth2.rho'];
 % file=['grav_FWT/marmousi_II_start_gauss_const_density.rho'];
 disp([' loading file ' file]);
 fid=fopen(file,'r','ieee-le');
 rho_start=fread(fid,[ny,nx],'float');
 fclose(fid);

% load inversion_result
%  file=['VSP_FWT/LBFGS/05_04_2015/modelTest_rho_stage_',int2str(itnum),'.bin'];
%  disp([' loading file ' file]);
%  fid=fopen(file,'r','ieee-le');
%  rho_result=fread(fid,[ny1,nx1],'float');
%  fclose(fid);

end

if(SHOW==1)
caxis_value1 = 800.0;
caxis_value2 = max(max(vp_mod));
end

if(SHOW==2)
caxis_value1 = 500.0;
caxis_value2 = max(max(vs_mod));
end

if(SHOW==3)
caxis_value1 = 1200.0;
caxis_value2 = 2800.0;
end

% -------------------------------------------------------------------------
% P-Wave Velocity
% -------------------------------------------------------------------------
%load 'seismic.map'
%colormap(seismic);
%colormap(jet(256));
%colormap(gray(256));
colormap(cm);

% gridsize and grid spacing (as specified in parameter-file) 

NX1=1; NX2=500;
NY1=1; NY2=174; 

IDX=1; IDY=1;
dh=20.0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% grid size
nx=NX2-NX1+1; 
ny=NY2-NY1+1;

% plot range and increment
xp1=NX1*dh; xp2=NX2*dh; yp1=NY1*dh; yp2=NY2*dh; 

% Computing range for axis and subscript range for the movie
x=xp1:IDX*dh:xp2;
y=yp1:IDY*dh:yp2;

x=x./1000;
y=y./1000;

if(SHOW1==1)

np=3;
sh=zeros(np,1);
ch=zeros(np,1);

sh(1)=subplot(2,1,1);

    if(SHOW==1)
	imagesc(x,y,vp_result);
    %imagesc(x,y,vp_start);
    
    
    if(WRITEMODE==1)       
      file1=['marmousi_II_marine_start_1D.vp'];
      fid1=fopen(file1,'w','ieee-le');
      fwrite(fid1,vp_start,'float')
      fclose(fid1);
    end
    
    end
    
    if(SHOW==2)

	imagesc(x,y,vs_result);
%     imagesc(x,y,vs_start);
    
    
    if(WRITEMODE==1)       
      file1=['marmousi_II_marine_start_1D.vs'];
      fid1=fopen(file1,'w','ieee-le');
      fwrite(fid1,vs_start,'float')
      fclose(fid1);
    end
    
    end
    
    if(SHOW==3)
	imagesc(x,y,rho_result);
    
    
    if(WRITEMODE==1)       
      file1=['marmousi_II_marine_start_1D.rho'];
      fid1=fopen(file1,'w','ieee-le');
      fwrite(fid1,rho_start,'float')
      fclose(fid1);
    end
    
    end
    
	hold on;
        %plot(xrec,yrec,'wo');
	%plot(xshot,yshot,'r*');
	
        caxis([caxis_value1 caxis_value2]);
    
        ch(1)=colorbar('v6');
	%set(gca,'YDir','normal');
        %colorbar;
        %axis equal;
       %set(gca,'DataAspectRatio',[1 1 1]);
       set(get(gca,'title'),'FontSize',FSize);
       set(get(gca,'title'),'FontWeight','bold');
       set(get(gca,'Ylabel'),'FontSize',FSize);
       set(get(gca,'Ylabel'),'FontWeight','bold');
       set(get(gca,'Xlabel'),'FontSize',FSize);
       set(get(gca,'Xlabel'),'FontWeight','bold');
       set(gca,'FontSize',FSize);
       set(gca,'FontWeight','bold');
       set(gca,'Box','on');
       set(gca,'Linewidth',1.0);
       axis([min(x)+FW max(x)-FW min(y) max(y)-FW])
		 axis ij
       
       %xlabel('x [km]');
       ylabel('Depth [km]');
       
       %if(SHOW==1)
       %iter_text=['P-Wave Velocity (FWT iteration no.',int2str(itnum),') [m/s]'];
       %end

       %if(SHOW==2)
       %iter_text=['S-Wave Velocity (FWT iteration no.',int2str(itnum),') [m/s]'];
       %end
       
       %if(SHOW==3)
       %iter_text=['Density (FWT iteration no.',int2str(itnum),') [kg/m^3]'];
       %end       
       
       if(SHOW==1)
       %iter_text=['P-wave velocity (FWT result after ',int2str(itnum),' iterations)'];
       iter_text=['P-wave velocity (Waveform Tomography)'];
       %iter_text=['P-wave velocity (Traveltime Tomography)'];
       end

       if(SHOW==2)
       iter_text=['S-wave velocity (Waveform Tomography)'];
       %iter_text=['S-wave velocity (Traveltime Tomography)'];
       end

       if(SHOW==3)
       % iter_text=['Density (FWT result after ',int2str(itnum),' iterations)'];
       iter_text=['Density (Waveform Tomography)'];
       % iter_text=['Density (const. half-space model)'];
       end
       
       if(SHOW==4)
       iter_text=['S-wave velocity'];
       end
       
       title(iter_text);

sh(2)=subplot(2,1,2);
 
    if(SHOW==1)
	imagesc(x,y,vp_mod);
    
    %if(WRITEMODE==1)       
    %  file1=['marmousi_II_marine.vp'];
    %  fid1=fopen(file1,'w','ieee-le');
    %  fwrite(fid1,vp_mod,'float')
    %  fclose(fid1);
    %end
    
    end

    if(SHOW==2)
	imagesc(x,y,vs_mod);
    
    
    if(WRITEMODE==1)       
      file1=['marmousi_II_marine.mu'];
      fid1=fopen(file1,'w','ieee-le');
      fwrite(fid1,mu_mod,'float')
      fclose(fid1);
    end
    
    
    end

    if(SHOW==3)
	imagesc(x,y,rho_mod);
    
    
    if(WRITEMODE==1)       
      file1=['marmousi_II_marine.rho'];
      fid1=fopen(file1,'w','ieee-le');
      fwrite(fid1,rho_mod,'float')
      fclose(fid1);
    end
    
    
    end
    
	hold on;
	
        caxis([caxis_value1 caxis_value2]);
    
        ch(2)=colorbar('v6');
	%set(gca,'YDir','normal');
        %colorbar;
        %axis equal;
       %set(gca,'DataAspectRatio',[1 1 1]);
       set(get(gca,'title'),'FontSize',FSize);
       set(get(gca,'title'),'FontWeight','bold');
       set(get(gca,'Ylabel'),'FontSize',FSize);
       set(get(gca,'Ylabel'),'FontWeight','bold');
       set(get(gca,'Xlabel'),'FontSize',FSize);
       set(get(gca,'Xlabel'),'FontWeight','bold');
       set(gca,'FontSize',FSize);
       set(gca,'FontWeight','bold');
       set(gca,'Box','on');
       set(gca,'Linewidth',1.0);
       axis([min(x)+FW max(x)-FW min(y) max(y)-FW])
		 axis ij
       
       xlabel('Distance [km]');
       ylabel('Depth [km]');
       
       if(SHOW==1)
       iter_text=['P-wave velocity (true model)'];
       end
       
       if(SHOW==2)
       iter_text=['S-wave velocity (true model)'];
       end
       
       if(SHOW==3)
       iter_text=['Density (true model)'];
       end
      
       title(iter_text);
       
      
clear x;
clear y;
clear vp_cut;

     set(ch(1),'visible','off');
     tp=get(ch(1),'position');
     bp=get(ch(2),'position');
     %cp=[bp(1:3),tp(2)+tp(4)-bp(2)];
     cp=[0.833 0.003 0.097 0.997]; 
     set(ch(2),'OuterPosition',cp);
     axes(sh(1));
     
       if(SHOW==1)
       title(ch(2),'V_p [m/s]','FontSize',FSize,'FontWeight','bold');
       end
       
       if(SHOW==2)
       title(ch(2),'V_s [m/s]','FontSize',FSize,'FontWeight','bold');
       end
       
       if(SHOW==3)
       title(ch(2),'\rho [kg/m^3]','FontSize',FSize,'FontWeight','bold');
       end
       
     set(ch(2),'FontSize',FSize,'FontWeight','bold');
     
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperSize', [5 7]);
    
    set(gcf,'position',[0 0, 1200 1200]);
    set(gcf,'PaperPositionMode','Auto');
     
    if(SHOW==1)
    imfile=['marmousi_vp_result_it_',int2str(itnum),'.',IMG_EXT];
    eval([['print -d',IMG_FORMAT,' '] imfile]);
    end
    
    if(SHOW==2)
    imfile=['marmousi_vs_result_it_',int2str(itnum),'.',IMG_EXT];
    eval([['print -d',IMG_FORMAT,' '] imfile]);
    end
     
    if(SHOW==3)
    imfile=['marmousi_rho_result_it_',int2str(itnum),'.',IMG_EXT];
    eval([['print -d',IMG_FORMAT,' '] imfile]);
    end
    
end

end

if(SHOW1==3)

     sh(1)=subplot(3,1,1);
    
    x1D = 1:length(y);
    x1D = x1D.*dh;
    
    if(SHOW==1)
    plot(x1D,vp_mod(:,50),x1D,vp_result(:,50),'r-',x1D,vp_start(:,50),'g-');
    end

    if(SHOW==2)
    plot(x1D,vs_mod(:,50),x1D,vs_result(:,50),'r-',x1D,vs_start(:,50),'g-');
    end

	   set(get(gca,'title'),'FontSize',FSize);
       set(get(gca,'title'),'FontWeight','bold');
       set(get(gca,'Ylabel'),'FontSize',FSize);
       set(get(gca,'Ylabel'),'FontWeight','bold');
       set(get(gca,'Xlabel'),'FontSize',FSize);
       set(get(gca,'Xlabel'),'FontWeight','bold');
       set(gca,'FontSize',FSize);
       set(gca,'FontWeight','bold');
       
       set(gca,'Box','on');
       set(gca,'Linewidth',1.0);
		 axis ij
	
		 axis tight
       
       if(SHOW==1)  
       ylabel('P-wave velocity (result) [m/s]');
       
       iter_text=['P-wave velocity (result) [m/s]'];
       end
       
       if(SHOW==2)  
       ylabel('Lamé Parameter \mu (result) [m/s]');
       
       iter_text=['S-wave velocity (result) [m/s]'];
       end
       
       legend('true model','FWT result','starting model',2);
       
       title(iter_text);

     sh(2)=subplot(3,1,2);
    
    
    if(SHOW==1)
    plot(x1D,vp_mod(:,100),x1D,vp_result(:,100),'r-',x1D,vp_start(:,100),'g-');
    end
    
    if(SHOW==2)
    plot(x1D,vs_mod(:,100),x1D,vs_result(:,100),'r-',x1D,vs_start(:,100),'g-');
    end
    
	   set(get(gca,'title'),'FontSize',FSize);
       set(get(gca,'title'),'FontWeight','bold');
       set(get(gca,'Ylabel'),'FontSize',FSize);
       set(get(gca,'Ylabel'),'FontWeight','bold');
       set(get(gca,'Xlabel'),'FontSize',FSize);
       set(get(gca,'Xlabel'),'FontWeight','bold');
       set(gca,'FontSize',FSize);
       set(gca,'FontWeight','bold');
       
       set(gca,'Box','on');
       set(gca,'Linewidth',1.0);
		 axis ij
	
		 axis tight
       
       if(SHOW==1)  
       ylabel('P-wave velocity (result) [m/s]');
       
       iter_text=['P-wave velocity (result) [m/s]'];
       end
       
       
       if(SHOW==2)  
       ylabel('S-wave velocity (result) [m/s]');
       
       iter_text=['S-wave velocity (result) [m/s]'];
       end
       
       legend('true model','FWT result','starting model',2);
       title(iter_text);

sh(3)=subplot(3,1,3);
    
    
    if(SHOW==1)
    plot(x1D,vp_mod(:,150),x1D,vp_result(:,150),'r-',x1D,vp_start(:,150),'g-');
    end
  
    if(SHOW==2)
    plot(x1D,vs_mod(:,150),x1D,vs_result(:,150),'r-',x1D,vs_start(:,150),'g-');
    end
    
	   set(get(gca,'title'),'FontSize',FSize);
       set(get(gca,'title'),'FontWeight','bold');
       set(get(gca,'Ylabel'),'FontSize',FSize);
       set(get(gca,'Ylabel'),'FontWeight','bold');
       set(get(gca,'Xlabel'),'FontSize',FSize);
       set(get(gca,'Xlabel'),'FontWeight','bold');
       set(gca,'FontSize',FSize);
       set(gca,'FontWeight','bold');
       
       set(gca,'Box','on');
       set(gca,'Linewidth',1.0);
		 axis ij
	
		 axis tight
       
       if(SHOW==1)  
       ylabel('P-wave velocity (result) [m/s]');
       
       iter_text=['P-wave velocity (result) [m/s]'];
       end
       
       
       if(SHOW==2)  
       ylabel('S-wave velocity (result) [m/s]');
       
       iter_text=['S-wave velocity (result) [m/s]'];
       end
     
       
       legend('true model','FWT result','starting model',2);
       title(iter_text);
       
       
end