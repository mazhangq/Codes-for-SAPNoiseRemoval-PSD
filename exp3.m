close all;
clear
addpath('functions','images','results');
filename={'barbara256.bmp','baboon256.bmp','cameraman512.bmp','couple256.bmp',...
    'lena512.bmp','pepper256.bmp','street512.bmp'};

bh=8;bw=8;

%%%%%%%%%%PSD parameters%%%%%%%%%%%%%%
beta=0.001;
fun=@(x) 1./(x.^2+eps);%exp(-200*x);%
%%%%%%%%%%padmm parameters%%%%%%%%%%%%%%
Amap = @(X)X;
Atmap = @(X)X;
LargestEig = 1;
p = 2;
lambda = 0.8;
acc = 1/255;
penalty_ratio = 10;

noises=0.1:0.2:0.9;
implement=0;  % 0---load the results; 1---run code
if implement
    for i=1:numel(filename)
        img_gray = imread(filename{i});
        psnrsb=[];
        for j=1:numel(noises)
            [m,n]=size(img_gray);
            psnra=[];
            
            for t=1:10  %repeat 10 times for each image and each noise level
                I = imnoise(img_gray,'salt & pepper',noises(j));
                img_RAMF=RAMF(I,21);
                
                Mask=(img_RAMF~=I) &...
                    (I==0 | I==255);
                mask=~Mask;
                
                
                emask=expandimg(mask,bh/2,bw/2);
                img=expandimg(img_RAMF,bh/2,bw/2);
                img_PSD=denoise(img,emask,bh,bw,beta,0.1,2500,fun);
                img_PSD=uint8(smblock(img_PSD,mask,bh,bw));
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                psnra = [psnra,[psnr(I,img_gray);psnr(img_RAMF,img_gray);...
                    psnr(img_PSD,img_gray)]];
            end
            psnrsb(:,:,j)=[psnra,mean(psnra,2)];
        end
        psnrs{i}=psnrsb;
    end
    save('results\psnrs.mat','psnrs');
else
    load('psnrs.mat');
end
for i=1:numel(filename)
    mpsnr=[];
    for j=1:numel(noises)
        mpsnr=[mpsnr,psnrs{i}(:,end,j),std(psnrs{i}(:,1:end-1,j),[],2)];
    end
    disp(filename{i});
    disp('noise level    30%----------------50%-----------------70%----------------90%---');
    disp(['Noisy Image: ',...
    num2str(mpsnr(1,3)),'+-',num2str(mpsnr(1,4)),'   ',...
    num2str(mpsnr(1,5)),'+-',num2str(mpsnr(1,6)),'   ',...
    num2str(mpsnr(1,7)),'+-',num2str(mpsnr(1,8)),'   ',...
    num2str(mpsnr(1,9)),'+-',num2str(mpsnr(1,10))]);
    disp(['AMF:         ',...
    num2str(mpsnr(2,3)),'+-',num2str(mpsnr(2,4)),'   ',...
    num2str(mpsnr(2,5)),'+-',num2str(mpsnr(2,6)),'   ',...
    num2str(mpsnr(2,7)),'+-',num2str(mpsnr(2,8)),'   ',...
    num2str(mpsnr(2,9)),'+-',num2str(mpsnr(2,10))]);
    disp(['OURs:         ',...
    num2str(mpsnr(3,3)),'+-',num2str(mpsnr(3,4)),'   ',...
    num2str(mpsnr(3,5)),'+-',num2str(mpsnr(3,6)),'   ',...
    num2str(mpsnr(3,7)),'+-',num2str(mpsnr(3,8)),'   ',...
    num2str(mpsnr(3,9)),'+-',num2str(mpsnr(3,10))]);
end
