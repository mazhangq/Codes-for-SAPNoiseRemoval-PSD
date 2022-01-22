%%---This program is designed to reconstruct signals
%%---G: a graph
%%---s: A matrix whose eachcolumn is a sampled signal
%%---Mask:A matrix the same size as s. A element is 1 
%%--       means known label, and 0 means unknown label
%%---beta: the regularization parameter
%%---w: the weight function, if default, reconstruct signal by GM
%%---ff: the reconstructed signals which is s matrix the same size as s


function ff = reconstructer(G,s,Mask,beta,w)
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%if the weight function default,set w=G.e
if nargin<5
    w=[];
end
%E=eye(G.N);
[N,Ns]=size(Mask);
idx=find(Mask);
if isempty(idx)
    ff=s;
else
    mc=sum(s(idx))/numel(idx); %calculate the mean
    ff=[];
    %--the maximum value of the weight function is
    %--standardized to $\lambda_{max}$
    
    ws=numel(find(G.W));
    s1=s.*Mask;
    if isempty(w)
        KL=G.L;
    else
        w=G.lmax*w/max(w);
        KL=G.U*(repmat(w,1,G.N).*G.U');
    end
    
    for j=1:Ns
        labels=find(Mask(:,j));
        if isempty(labels)
            f=mc*ones(1,N);
        else
            lbs=numel(labels);
            Ek=diag(Mask(:,j));
            %V=(Ek.^2)/lbs+beta*KL/ws;
            V=Ek/lbs+beta*KL/ws;
            f=inv(V)*s1(:,j)/lbs;
            %((Mask(:,j).^2).*s(:,j)/lbs);
        end
        ff=[ff,f];
    end
end



