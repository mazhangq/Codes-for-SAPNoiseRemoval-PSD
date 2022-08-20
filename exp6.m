%  Color images
%  Results: Fig.11 , Table 4


close all;
clear
addpath('functions','images','results');

filename={'mirror1280.jpg'};
%filename={'mirror3000.jpg'};
noises=0.7;
bh=8;bw=8;

%%%%%%%%%%PSD parameters%%%%%%%%%%%%%%
beta=0.001;
fun=@(x) 1./(x.^2+eps);
%%%%%%%%%%padmm parameters%%%%%%%%%%%%%%
Amap = @(X)X;
Atmap = @(X)X;
LargestEig = 1;
p = 2;
lambda = 0.8;
acc = 1/255;
penalty_ratio = 10;

warning('off','all');
implement=1;  % 0---load the results; 1---run code
if implement
    for i=1:numel(filename)
        img_color= imread(filename{i});
        img_color =rgb2gray(img_color);
 
        [m,n,c]=size(img_color);
        psnrsb=[];
        for j=1:numel(noises)
             t_PSD=[];
            psnra=[];
            % test 3 or 5 times
            for t=1:3
                I = imnoise(img_color,'salt & pepper',noises(j));
                img_PSD=zeros(size(I));
                 tstart=tic;
                 % gray image k=1:1; color image k=1:3
                for k=1:1
                   
                    img_RAMF(:,:,k)=RAMF(I(:,:,k),21);
                    Mask=(img_RAMF(:,:,k)~=I(:,:,k)) &...
                        (I(:,:,k)==0 | I(:,:,k)==255);
                    mask=~Mask;
                     t_AMF=toc(tstart);
              
                    emask=expandimg(mask,bh/2,bw/2);
                    img=expandimg(img_RAMF(:,:,k),bh/2,bw/2);
                    img_PSD(:,:,k)=denoise(img,emask,bh,bw,beta,0.1,2500,fun);
                    img_PSD(:,:,k)=smblock(img_PSD(:,:,k),mask,bh,bw);
                     
                end
                t_PSD=[t_PSD;toc(tstart)];
                img_PSD=uint8(img_PSD);
                psnra = [psnra,[psnr(I,img_color);psnr(img_RAMF,img_color);...
                    psnr(img_PSD,img_color)]];
            end
            psnrsb(:,:,j)=[psnra,mean(psnra,2)];
            meant=mean(t_PSD)
            psnrsb(3,4)
        end
        psnrs_rgb{i}=psnrsb;
    end
    

    
    save('results\psnrs_rgb.mat','psnrs_rgb');
else
    load('psnrs_rgb.mat');
end

images=[img_color,I,img_PSD];

imshow(images)

