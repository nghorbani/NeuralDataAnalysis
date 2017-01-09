function res = align_spikeTrace(spikeTrace,prePeakSamples,postPeakSamples,Fs)
    upsample_factor = 100;
    new_Fs = Fs * upsample_factor;
   
    [smoothedSpikeTrace,~] = smooth(spikeTrace,upsample_factor,Fs);

    % we have the length of the samples prior to peak
    % so we just move the peak so that it ends up at the right place
    aligned_spike = smoothedSpikeTrace;
    [~,peak_loc] = min(smoothedSpikeTrace);
    preSmoothPeakSamples = prePeakSamples * upsample_factor;

    shift_amount = abs(preSmoothPeakSamples-peak_loc);
    
    if preSmoothPeakSamples > peak_loc % then shift right
        aligned_spike = circshift(smoothedSpikeTrace,shift_amount,1);% to the right
        % shifted to the right so zeros should be replaced by the first value
        aligned_spike(1:shift_amount) = smoothedSpikeTrace(1);
    elseif preSmoothPeakSamples < peak_loc % then shift left
        aligned_spike = circshift(smoothedSpikeTrace,-1*shift_amount,1);% to the left
        % then element at the end should be replaced by the last value
        aligned_spike(length(aligned_spike)-shift_amount:end) = smoothedSpikeTrace(end);
    end
    res = smooth(aligned_spike,1/upsample_factor,new_Fs);
end