%%---This program is designed to estimate the PSD
%%---directly from the sampled signals
%%---G: a graph
%%---s1:  matrix whose eachcolumn is a sampled signal
%%---Mask:A matrix the same size as s. A element is 1 
%%--       means known label, and 0 means unknown label
%%---psd: the estimated PSD


function psd=my_psd_estimate(G,s1)
S=cov(s1');
psd=diag(G.U'*S*G.U);

% psd=smooth(psd,61); 
% psd=smooth(psd,51);
% psd=smooth(psd,45);

% psd=smooth(psd,51); 
% psd=smooth(psd,45);
% psd=smooth(psd,39);


