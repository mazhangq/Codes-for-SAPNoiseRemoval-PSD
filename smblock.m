function II=smblock(II,mask,bh,bw)
[h,w]=size(II);

xx=[0,ones(1,bw-2),0];
xx=repmat(xx,1,w/bw-2);
xx=[ones(1,7),0,xx,0,ones(1,7)];
x=1:h;
hs=[];
for i=1:h
    xx1=xx;
    idx=find(isnan(II(i,:)));
    xx1(idx)=0;
    idx=find(mask(i,:));
    xq=unique([find(xx1),idx]);
    yq=II(i,xq);
    s = interp1(xq,yq,x,'spline');
    hs=[hs;s];
end
vs=[];
for i=1:w
    xx1=xx';
    idx=find(isnan(II(:,i)));
    xx1(idx)=0;
    idx=find(mask(:,i));
    xq=unique([find(xx1);idx]);
    yq=II(xq,i);
    s = interp1(xq,yq,x,'spline');
    vs=[vs,s'];
end
II=(hs+vs)/2;
II=round(II);
idx=find(II>255);
II(idx)=255;
idx=find(II<0);
II(idx)=0;
