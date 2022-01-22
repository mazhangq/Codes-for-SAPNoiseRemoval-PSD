function img=denoise(img,mask,bh,bw,beta,sigma1,sigma2,fun)
if nargin<8 
    fun=[];
end

kir1=[-1 -2 -1;0 0 0;1 2 1];
kir2=kir1';
kir3=[2 1 0;1 0 -1;0 -1 -2];
kir4=rot90(kir3);
kir1=kir1(:);
kir2=kir2(:);
kir3=kir3(:);
kir4=kir4(:);

[m,n]=size(img);
f=[];
exth=2*bh;
extw=2*bw;
for j=1:8:m-extw+1
    for i=1:8:n-exth+1
        I=img(i:exth+i-1,j:extw+j-1);
        mmask=mask(i:exth+i-1,j:extw+j-1);
        bs=[];
        [bbh,bbw]=size(I);
        for jj=1:bbw-bw+1
            for ii=1:bbh-bh+1
                bb=double(I(ii:ii+bh-1,jj:jj+bw-1));
                bs=[bs,bb(:)];
                if ii==(bbh-bh)/2+1 & jj==(bbw-bw)/2+1
                    x=bb(:);
                    bbm=mmask(ii:ii+bh-1,jj:jj+bw-1);
                    xmask=bbm(:);
                    %%%%%%%%%%%%%%%
                    fbs=double(I(ii-1:ii+bh,jj-1:jj+bw));
                    fve=[];
                    for mm=2:bh+1
                        for nn=2:bw+1
                            mn=fbs(mm-1:mm+1,nn-1:nn+1);
                            mn=mn(:);
                            fve=[fve;[mm-1,nn-1,...%mn(5),mean(mn),...
                                sum(mn.*kir1),...
                                sum(mn.*kir2),...
                                sum(mn.*kir3),...
                                sum(mn.*kir4)]];
                        end
                    end
                    %%%%%%%%%%%%%%%%%
                end
            end
        end
        W1=squareform(exp(-pdist(fve(:,1:2)/sigma1)));
        W2=squareform(exp(-pdist(fve(:,3:end)/sigma2)));
        G.W=W1.*W2;
        G.d=sum(G.W,2);
        G.L=diag(G.d)-G.W;
        [G.U,G.e]=eig(G.L);
        G.e=diag(G.e);
        G.lmax=max(G.e);
        G.N=length(G.e);
        
        mbs=mean(bs,2);
        x=x-mbs;
        
        if isempty(fun)
            xx = reconstructer(G,x,xmask,beta);
        else
            s1=bs-mbs;
            psd=my_psd_estimate(G,s1);
            psd=psd/sum(psd);
            wf=fun(psd);
            xx = reconstructer(G,x,xmask,beta,wf); %reconstruct by ours
        end
        f=[f,xx+mbs];
    end
end
img=resblocks(f,bh,bw,sqrt(size(f,2))*8,sqrt(size(f,2))*8);
end
