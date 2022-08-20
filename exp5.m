%  Color images
%  Results: Fig.10 , Table 3

close all;
clear
addpath('functions','images','results');

filename={'baboon_rgb.bmp'};
noises=0.9;
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
        img_color = imread(filename{i});
        img_color=imresize(img_color ,[256 256]);
        [m,n,c]=size(img_color);
        psnrsb=[];
        for j=1:numel(noises)
            psnra=[];
            for t=1:5
                I = imnoise(img_color,'salt & pepper',noises(j));
                img_PSD=zeros(size(I));
                for k=1:3
                    img_RAMF(:,:,k)=RAMF(I(:,:,k),21);
                    Mask=(img_RAMF(:,:,k)~=I(:,:,k)) &...
                        (I(:,:,k)==0 | I(:,:,k)==255);
                    mask=~Mask;
                   
                    emask=expandimg(mask,bh/2,bw/2);
                    img=expandimg(img_RAMF(:,:,k),bh/2,bw/2);
                    img_PSD(:,:,k)=denoise(img,emask,bh,bw,beta,0.1,2500,fun);
                    img_PSD(:,:,k)=smblock(img_PSD(:,:,k),mask,bh,bw);
                end
                img_PSD=uint8(img_PSD);
                psnra = [psnra,[psnr(I,img_color);psnr(img_RAMF,img_color);...
                    psnr(img_PSD,img_color)]];
            end
            psnrsb(:,:,j)=[psnra,mean(psnra,2)];
        end
        psnrs_rgb{i}=psnrsb;
    end
    save('results\psnrs_rgb.mat','psnrs_rgb');
else
    load('psnrs_rgb.mat');
end
for i=1:numel(filename)
    mpsnr=[];
    for j=1:numel(noises)
        mpsnr=[mpsnr,psnrs_rgb{i}(:,end,j),std(psnrs_rgb{i}(:,1:end-1,j),[],2)];
    end
    disp(filename{i});
%    disp('noise level    30%----------------50%-----------------70%----------------90%---');
%     disp(['Noisy Image: ',...
%     num2str(mpsnr(1,3)),'+-',num2str(mpsnr(1,4)),'   ',...
%     num2str(mpsnr(1,5)),'+-',num2str(mpsnr(1,6)),'   ',...
%     num2str(mpsnr(1,7)),'+-',num2str(mpsnr(1,8)),'   ',...
%     %num2str(mpsnr(1,9)),'+-',num2str(mpsnr(1,10))]);
%     num2str(mpsnr(1,8)),'+-',num2str(mpsnr(1,8))]);
%     disp(['AMF:         ',...
%     num2str(mpsnr(2,3)),'+-',num2str(mpsnr(2,4)),'   ',...
%     num2str(mpsnr(2,5)),'+-',num2str(mpsnr(2,6)),'   ',...
%     num2str(mpsnr(2,7)),'+-',num2str(mpsnr(2,8)),'   ',...
%     num2str(mpsnr(2,8)),'+-',num2str(mpsnr(2,8))]);
%     %num2str(mpsnr(2,9)),'+-',num2str(mpsnr(2,10))]);
%     disp(['OURs:         ',...
%     num2str(mpsnr(3,3)),'+-',num2str(mpsnr(3,4)),'   ',...
%     num2str(mpsnr(3,5)),'+-',num2str(mpsnr(3,6)),'   ',...
%     num2str(mpsnr(3,7)),'+-',num2str(mpsnr(3,8)),'   ',...
%     %num2str(mpsnr(3,9)),'+-',num2str(mpsnr(3,10))]);
%     num2str(mpsnr(3,8)),'+-',num2str(mpsnr(3,8))]);
end
images=[img_color,I,img_PSD];


filename={'lena_rgb.bmp'};
implement=1;  % 0---load the results; 1---run code
if implement
    for i=1:numel(filename)
        img_color = imread(filename{i});
        img_color=imresize(img_color ,[256 256]);
        [m,n,c]=size(img_color);
        psnrsb=[];
        for j=1:numel(noises)
            psnra=[];
            for t=1:5
                I = imnoise(img_color,'salt & pepper',noises(j));
                img_PSD=zeros(size(I));
                for k=1:3
                    img_RAMF(:,:,k)=RAMF(I(:,:,k),21);
                    Mask=(img_RAMF(:,:,k)~=I(:,:,k)) &...
                        (I(:,:,k)==0 | I(:,:,k)==255);
                    mask=~Mask;
                   
                    emask=expandimg(mask,bh/2,bw/2);
                    img=expandimg(img_RAMF(:,:,k),bh/2,bw/2);
                    img_PSD(:,:,k)=denoise(img,emask,bh,bw,beta,0.1,2500,fun);
                    img_PSD(:,:,k)=smblock(img_PSD(:,:,k),mask,bh,bw);
                end
                img_PSD=uint8(img_PSD);
                psnra = [psnra,[psnr(I,img_color);psnr(img_RAMF,img_color);...
                    psnr(img_PSD,img_color)]];
            end
            psnrsb(:,:,j)=[psnra,mean(psnra,2)];
        end
        psnrs_rgb{i}=psnrsb;
    end
    save('results\psnrs_rgb.mat','psnrs_rgb');
else
    load('psnrs_rgb.mat');
end

images=[img_color,I,img_PSD,images];

imshow(images)




