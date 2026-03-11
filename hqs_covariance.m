function covariance_matrix = hqs_covariance(initial_cov)
% H-Q-S COVARIANCE Generates a random covariance matrix using the H-Q-S algorithm.
%
%   covariance_matrix = hqs_covariance(initial_cov)
%
%   Inputs:
%       initial_cov - An initial covariance matrix.
%
%   Output:
%       covariance_matrix - A transformed covariance matrix preserving correlation structure.

    % Eigen decomposition of the initial covariance matrix
    [V, D] = eig(initial_cov);
    
    % Get original eigenvalues
    old_eigenvalues = diag(D);
    
    % Generate random eigenvalues
    scaling_factor = 0.5 + rand(length(old_eigenvalues), 1); % Random scaling factor (0.5 to 1.5)
    target_eigenvalues = sort(old_eigenvalues .* scaling_factor, 'descend');
    
    % Ensure eigenvalues are sorted in ascending order
    [~, order] = sort(old_eigenvalues, 'ascend');
    V = V(:, order);
    
    % Construct new covariance matrix using target eigenvalues
    Lambda = diag(target_eigenvalues);
    covariance_matrix = V * Lambda * V';
    
    % Ensure symmetry
    covariance_matrix = (covariance_matrix + covariance_matrix') / 2;
end