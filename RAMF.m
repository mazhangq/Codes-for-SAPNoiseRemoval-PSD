function img_RAMF = RAMF(img_noise, max)

%��ȡͼ�������
m=size(img_noise,1);
%��ȡͼ�������
n=size(img_noise,2);

%ȷ�������˲��뾶
Nmax=max;       

%�����Ǳ߽���չ��ͼ���������Ҹ�����Nmax���ء�
imgn=zeros(m+2*Nmax,n+2*Nmax,'uint8');
imgn(Nmax+1:m+Nmax,Nmax+1:n+Nmax)=img_noise;

imgn(1:Nmax,Nmax+1:n+Nmax)=img_noise(1:Nmax,1:n);                 %��չ�ϱ߽�
imgn(1:m+Nmax,n+Nmax+1:n+2*Nmax+1)=imgn(1:m+Nmax,n:n+Nmax);    %��չ�ұ߽�
imgn(m+Nmax+1:m+2*Nmax+1,Nmax+1:n+2*Nmax+1)=imgn(m:m+Nmax,Nmax+1:n+2*Nmax+1);    %��չ�±߽�
imgn(1:m+2*Nmax+1,1:Nmax)=imgn(1:m+2*Nmax+1,Nmax+1:2*Nmax);       %��չ��߽�

re=imgn;
for i=Nmax+1:m+Nmax
    for j=Nmax+1:n+Nmax
        
        r=1;                %��ʼ�˲��뾶
        while r <= Nmax
            W=imgn(i-r:i+r,j-r:j+r);
            %W = my_sort(W);
            W=sort(W(:));
            W_size = size(W);
            Imin=W(1);
            Imax=W(W_size(1));
            Imed=W(ceil(W_size(1)/2));
           
            if Imin<Imed && Imed<Imax       %�����ǰ������ֵ���������㣬��ô���ô˴ε�����
               break;
            else
                r=r+1;              %�������󴰿ڣ������ж�
            end          
        end
        
        if Imin<imgn(i,j) && imgn(i,j)<Imax         %�����ǰ������ز���������ԭֵ���
            re(i,j)=imgn(i,j);
        else                                        %�������������ֵ
            re(i,j)=Imed;
        end
        
    end
end

img_RAMF = re(Nmax+1:m+Nmax,Nmax+1:n+Nmax);