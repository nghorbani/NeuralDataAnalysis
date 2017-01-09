function b = extractFeatures(w)
% Extract features for spike sorting.
%   b = extractFeatures(w) extracts features for spike sorting from the
%   waveforms in w, which is a 3d array of size length(window) x #spikes x
%   #channels. The output b is a matrix of size #spikes x #features.
%
%   This implementation does PCA on the waveforms of each channel
%   separately and uses the first three principal components. Thus, we get
%   a total of 12 features.

b=[];

for ch=1:size(w, 3) %number of channels
    channel_waveforms = w(:,:,ch); %all the waveforms in the channel
    U_3 = PCA(channel_waveforms);%3 principle components
    Z = channel_waveforms' * U_3;% 3*number of spikes
    b = [b, Z];%extr

end
