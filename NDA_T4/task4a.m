close all; clear all;
load('NDA_Data_2p_only.mat')

for dataIdx = 1:length(NDA_Data)
    calcTrace = NDA_Data(dataIdx).GalvoTraces;
    fr = NDA_Data(dataIdx).fps;
    inferredRate = estimateRateFromCa(calcTrace,fr);
    NDA_Data(dataIdx).predictedRate = inferredRate;
end