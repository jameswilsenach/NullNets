function ts_randomized = phase_randomize(ts, seed)
% PHASE_RANDOMIZE Performs phase randomization on each variable (column) of a multivariate time series independently.
% 
%   ts_randomized = phase_randomize(ts, seed)
% 
%   Inputs:
%       ts    - A 2D matrix where rows represent time steps and columns represent variables.
%       seed  - (Optional) Random seed for reproducibility.
% 
%   Output:
%       ts_randomized - Phase-randomized time series with the same shape as input.

    if nargin > 1
        rng(seed);
    end
    
    [n, d] = size(ts);
    ts_randomized = zeros(n, d);
    
    for i = 1:d
        x = ts(:, i);
        
        % Compute the FFT of the time series
        X = fft(x);
        
        % Number of unique frequencies
        lenX = length(X);
        half_len = floor(lenX / 2); % Half-length of FFT spectrum
        
        % Generate random phases while keeping DC and Nyquist components unchanged
        random_phases = exp(1j * (2 * pi * rand(half_len - 1, 1))); 
        
        % Apply phase randomization
        X_new = X;  % Copy original spectrum
        X_new(2:half_len) = X(2:half_len) .* random_phases; % Randomize only positive frequencies
        
        % Maintain Hermitian symmetry for real-valued signals
        X_new(end - half_len + 2:end) = conj(X_new(2:half_len)); 
        
        % Perform the inverse FFT
        x_randomized = ifft(X_new, 'symmetric');
        
        % Store the phase-randomized time series
        ts_randomized(:, i) = x_randomized;
    end
end