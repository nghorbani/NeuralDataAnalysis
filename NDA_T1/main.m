% Task 1 by Bernhard Lang and Nima Ghorbani
% prepare data
close all; clc;
load NDA_rawdata

Fs = 30000;
spikeType = 'extracellular';

x = gain * double(x);
x = x(1:10*Fs,:);
% run code
y = filterSignal(x,Fs);
[s, t] = detectSpikes(y,Fs,spikeType);
w = extractWaveforms_aligned(y,s,Fs,spikeType);
b = extractFeatures(w);
% % plot figures
task1_plots(x,y,s,t,w,b,Fs,spikeType)