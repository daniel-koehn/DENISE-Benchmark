% Postprocess and Plot RTM image
%
% Daniel Köhn
% Kiel, the 10/12/2011

clear all
close all

FSize=20; % font size

% define screen size
screen_x = 1920;
screen_z = 1080;

% define format of the output image file
FILENAME = 'RTM_marmousi_S_image';

% IMG_FORMAT = 'png';
% IMG_EXT = 'png';

IMG_FORMAT = 'psc2';
IMG_EXT = 'eps';

% RTM = 1 display RTM for true model
% RTM = 2 display RTM for inital model
% RTM = 3 display RTM for FWI model
RTM=3;

% apply spatial filter
SPAT_FILT=0;
size_med = 10;

nx=500;
ny=174;
DH=20.0;


% load RTM result
 if(RTM==1)
   file='OBC_FWT/RTM/RTM_image_true_vs.bin';
 end
 
 if(RTM==2)
   file='OBC_FWT/RTM/RTM_image_initial_vs.bin';
 end
 
 if(RTM==3)
   file='OBC_FWT/RTM/RTM_image_FWI_vs.bin';
 end
 
 %file='classical_FWT/start/Vel/marmousi_II_marine.vs';
 disp([' loading file ' file]);
 fid=fopen(file,'r','ieee-le');
 image=fread(fid,[ny,nx],'float');
 fclose(fid);
 
 
 % S-wave image
 caxis_value2 = 3e-9;
 caxis_value1 = -caxis_value2;

 % scale with depth 
%   for i=1:nx
%      for j=1:ny
%        
%        depth=j.*DH; 
%        image(j,i) = image(j,i).*depth;     
%        
%      end
%   end

if(SPAT_FILT==1)
    imaged=medfilt2(image, [size_med size_med]);
else
    imaged=image;
end

 % calculate second derivative in z-direction
 for i=1:nx
     for j=2:ny-1
    
       imaged(j,i) = (image(j+1,i) + image(j-1,i) - 2.0.*image(j,i))./(DH*DH);     
       
 
     end
 end

imaged(1,:)=0.0;
imaged(ny,:)=0.0;
  
% apply damping of image in the PML layers
DAMPING=99;
amp=1.0-DAMPING./100.0;   % amplitude at the edge of the numerical grid 
ifw=1;  % frame width in gridpoints 
a=sqrt(-log(amp)./(ifw.^2));
        
for i=1:ifw
    %coeff(i)=exp(-(a.^2.*(ifw-i).^2));
    coeff(i) = 0.0;
end

% initialize array of coefficients with one 
for j=1:ny
    for i=1:nx 
      absorb_coeff(j,i)=1.0;
    end
end

% coefficients for left and right boundary
yb=1; 
ye=ny;
  for i=1:ifw
      ye=ny-i+1;
        for j=yb:ye
          absorb_coeff(j,i)=coeff(i);
        end           
  end

yb=1; 
ye=ny;
  for i=1:ifw
      ii=nx-i+1;
      ye=ny-i+1;
        for j=yb:ye
          absorb_coeff(j,ii)=coeff(i);
        end           
  end
  
% coefficients for bottom boundary
xb=1; 
xe=nx;
  for j=1:ifw
      xb=j;
      jj=ny-j+1;
      xe=nx-j+1;
        for i=xb:xe
          absorb_coeff(jj,i)=coeff(j);
        end           
  end

absorb_coeff(1:ifw,:)=0.0;  
  
 % apply damping in PML boundaries 
  imaged = imaged .* absorb_coeff; 
 
 % set coordinate system 
  x=DH.*(1:nx)./1000.0;
  y=DH.*(1:ny)./1000.0;
 
Fig = figure;
figure(Fig)
  
 % plot model
 colormap(gray(256));
 imagesc(x,y,imaged);
 caxis([caxis_value1 caxis_value2]);
 
 set(get(gca,'title'),'FontSize',FSize);
 set(get(gca,'title'),'FontWeight','bold');
 set(get(gca,'Ylabel'),'FontSize',FSize);
 set(get(gca,'Ylabel'),'FontWeight','bold');
 set(get(gca,'Xlabel'),'FontSize',FSize);
 set(get(gca,'Xlabel'),'FontWeight','bold');
 set(gca,'FontSize',FSize);
 set(gca,'FontWeight','bold');
 set(gca,'Box','on');
 set(gca,'Linewidth',2.0);
 axis ij;
 axis equal;
 axis tight;
%  axis([min(x) max(x) min(y) maxzz]);
 
 xlabel('Distance [km]');
 ylabel('Depth [km]');
 
 if(RTM==1)
   title('Marmousi RTM S-wave image (true)');
 end
 
 if(RTM==2)
   title('Marmousi RTM S-wave image (inital)');
 end
 
 if(RTM==3)
   title('Marmousi RTM S-wave image (FWI)');
 end
 
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [5 7]);

set(Fig,'position',[0 0, screen_x screen_z])
set(Fig,'PaperPositionMode','Auto')   

if(RTM==1)
  RTM_EXT = 'true';  
end

if(RTM==2)
  RTM_EXT = 'init';  
end

if(RTM==3)
  RTM_EXT = 'FWI';  
end

% Saving the snapshot:
imfile=[FILENAME,'_',RTM_EXT,'.',IMG_EXT];
eval([['print -d',IMG_FORMAT,' '] imfile]);
