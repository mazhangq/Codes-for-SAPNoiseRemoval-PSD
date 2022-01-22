close all;
clear
addpath('functions','images','results');

filename={'barbara256.bmp','baboon256.bmp','couple256.bmp','pepper256.bmp',...
    'lena512.bmp','cameraman512.bmp','street512.bmp'};

noises=0.3:0.2:0.9;
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

warning('off','all');
implement=0;  % 0---load the results; 1---run code
if implement
    for i=1:numel(filename)
        img_gray = imread(filename{i});
        [m,n]=size(img_gray);
        statics_TSM=[];
        statics_PDA=[];
        statics_PADMM=[];
        statics_PSD=[];
        for j=1:numel(noises)
            t_PSD=[];
            t_TSM=[];
            t_PDA=[];
            t_PADMM=[];
            for t=1:5
                I = imnoise(img_gray,'salt & pepper',noises(j));
                
                tstart=tic;
                img_RAMF=RAMF(I,21);
                
                Mask=(img_RAMF~=I) &...
                    (I==0 | I==255);
                mask=~Mask;
                t_AMF=toc(tstart);
                %%%%%%%%%2 stage %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                tstart=tic;
                img_TSM=uint8(255*twostage(I,mask,500));
                t_TSM=[t_TSM;toc(tstart)];
                %%%%%%%%L0TVPDA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                tstart=tic;
                img_PDA=uint8(255*L0TVPDA(double(img_RAMF),mask,1.4));
                t_PDA=[t_PDA;toc(tstart)+t_AMF];
                %%%%%%%%%%padmm%%%%%%%%%%%%%%
                tstart=tic;
                img_padmm = l0tv_padmm_color(double(img_RAMF)/255,mask,Amap,...
                    Atmap,p,lambda,LargestEig,acc,penalty_ratio);
                img_padmm=uint8(255*img_padmm);
                t_PADMM=[t_PADMM;toc(tstart)+t_AMF];
                %%%%%%%%%%%OURS%%%%%%%%%%%%%%%
                tstart=tic;
                emask=expandimg(mask,bh/2,bw/2);
                img=expandimg(img_RAMF,bh/2,bw/2);
                img_PSD=denoise(img,emask,bh,bw,beta,0.1,2500,fun);
                img_PSD=uint8(smblock(img_PSD,mask,bh,bw));
                t_PSD=[t_PSD;toc(tstart)+t_AMF];
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            end
            cputime{i,j}=[t_TSM,t_PDA,t_PADMM,t_PSD];
        end
    end
    
    save('results\cputime.mat','cputime');
else
    load('cputime.mat');
end

%%%%%%%%%%%%%%%%%%%%cputime vs noise level for 256%%%%%%%%%
meantime=[];
errs=[];
for j=1:numel(noises)
      aa=cputime{1,j};
      meantime=[meantime;mean(aa)];
      errs=[errs;std(aa)];
end
figure;
plot(1:4,meantime(:,1),'-s','LineWidth',2,'MarkerSize',10);
hold on;
plot(1:4,meantime(:,2),'-^','LineWidth',2,'MarkerSize',10);
plot(1:4,meantime(:,3),'-V','LineWidth',2,'MarkerSize',10);
plot(1:4,meantime(:,4),'-o','LineWidth',2,'MarkerSize',10);
xlabel('Noise level');
ylabel('CPU time (senconds)');
% legend({'TSM','PDA','PADMM','OURS'},'Location','northwest','NumColumns',4);
xticks(1:4);
xticklabels({'30%','50%','70%','90%'});
ax=gca;
ax.FontName='Times New Roman';
ax.FontSize = 20;
meantime(4,:)
errs(4,:)
print('-f1','cputime1','-djpeg');
%%%%%%%%%%%%%%%%%%%%cputime vs noise level for 512%%%%%%%%%
meantime=[];
errs=[];
for j=1:numel(noises)
      aa=cputime{5,j};
      meantime=[meantime;mean(aa)];
      errs=[errs;std(aa)];
end
figure;
plot(1:4,meantime(:,1),'-s','LineWidth',2,'MarkerSize',10);
hold on;
plot(1:4,meantime(:,2),'-^','LineWidth',2,'MarkerSize',10);
plot(1:4,meantime(:,3),'-V','LineWidth',2,'MarkerSize',10);
plot(1:4,meantime(:,4),'-o','LineWidth',2,'MarkerSize',10);
xlabel('Noise level');
ylabel('CPU time (senconds)');
% legend({'TSM','PDA','PADMM','OURS'},'Location','northwest','NumColumns',4);
xticks(1:4);
xticklabels({'30%','50%','70%','90%'});
ax=gca;
ax.FontName='Times New Roman';
ax.FontSize = 20;
print('-f2','cputime2','-djpeg');
meantime(4,:)
errs(4,:)
%%%%%%%%%%%%%%%%%%%%cputime vs test images for 256%%%%%%%%%
meantime=[];
for i=1:4
      aa=cputime{i,4};
      meantime=[meantime;mean(aa)];
end
figure;
plot(1:4,meantime(:,1),'-s','LineWidth',2,'MarkerSize',10);
hold on;
plot(1:4,meantime(:,2),'-^','LineWidth',2,'MarkerSize',10);
plot(1:4,meantime(:,3),'-V','LineWidth',2,'MarkerSize',10);
plot(1:4,meantime(:,4),'-o','LineWidth',2,'MarkerSize',10);
%xlabel('Noise level');
ylabel('CPU time (senconds)');
% legend({'TSM','PDA','PADMM','OURS'},'Location','northwest','NumColumns',4);
xticks(1:4);
xticklabels({'Barbara','Baboon','Couple','Pepper'});
axis([1 4 0 5]);
ax=gca;
ax.FontName='Times New Roman';
ax.FontSize = 20;
print('-f3','cputime3','-djpeg');

%%%%%%%%%%%%%%%%%%%%cputime vs test images for 512%%%%%%%%%
meantime=[];
for i=5:7
      aa=cputime{i,4};
      meantime=[meantime;mean(aa)];
end
figure;
plot(1:3,meantime(:,1),'-s','LineWidth',2,'MarkerSize',10);
hold on;
plot(1:3,meantime(:,2),'-^','LineWidth',2,'MarkerSize',10);
plot(1:3,meantime(:,3),'-V','LineWidth',2,'MarkerSize',10);
plot(1:3,meantime(:,4),'-o','LineWidth',2,'MarkerSize',10);
%xlabel('Noise level');
ylabel('CPU time (senconds)');
% legend({'TSM','PDA','PADMM','OURS'},'Location','northwest','NumColumns',4);
xticks(1:4);
xticklabels({'Lena','Cameraman','Street'});
axis([1 3 0 22]);
ax=gca;
ax.FontName='Times New Roman';
ax.FontSize = 20;
print('-f4','cputime4','-djpeg');

