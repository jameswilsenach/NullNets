function W_shuffled = shuffle_weights(W, C)
    % Function to shuffle weights in a weighted network
    % while optionally preserving community structure.
    %
    % INPUTS:
    %   W - NxN weighted adjacency matrix (assumed symmetric)
    %   C - Nx1 community assignment vector (optional)
    %
    % OUTPUT:
    %   W_shuffled - NxN shuffled weighted adjacency matrix
    
    % Ensure the matrix is symmetric
    % if ~isequal(W, W')
    %     error('Input adjacency matrix must be symmetric.');
    % end
    
    % Get the number of nodes
    N = size(W,1);
    
    % Find nonzero edges (upper triangle to avoid redundancy)
    [i, j] = find(triu(W, 1));
    weights = W(sub2ind(size(W), i, j)); % Extract weights
    
    % If no community structure is given, shuffle all weights randomly
    if nargin < 2 || isempty(C)
        shuffled_weights = weights(randperm(length(weights))); % Fully random shuffle
    else
        % Shuffle weights separately within and between communities
        shuffled_weights = weights;
        
        % Identify unique communities
        unique_communities = unique(C);
        
        % Shuffle weights within each community separately
        for c = unique_communities'
            nodes_in_c = find(C == c);
            mask_within = ismember(i, nodes_in_c) & ismember(j, nodes_in_c);
            
            % Get indices of within-community edges
            idx_within = find(mask_within);
            
            % Shuffle only these weights
            shuffled_weights(idx_within) = weights(idx_within(randperm(numel(idx_within))));
        end
        
        % Shuffle weights between different communities separately
        mask_between = C(i) ~= C(j); % Identifies inter-community edges
        idx_between = find(mask_between);
        
        % Shuffle only these weights
        shuffled_weights(idx_between) = weights(idx_between(randperm(numel(idx_between))));
    end
    
    % Reconstruct shuffled adjacency matrix
    W_shuffled = zeros(N);
    W_shuffled(sub2ind(size(W), i, j)) = shuffled_weights;
    W_shuffled = W_shuffled + W_shuffled'; % Make symmetric

end

%% OLD SHUFFLE
% 
% function W_rand = shuffle_weights(W)
%     % SHUFFLE_WEIGHTS Randomizes edge weights while preserving network topology.
%     %
%     %   W_rand = shuffle_weights(W) takes an undirected weighted adjacency matrix W
%     %   and returns a new matrix W_rand where the edge weights are shuffled
%     %   while keeping the topology unchanged.
%     %
%     %   INPUT:
%     %       W - NxN weighted adjacency matrix (undirected, symmetric)
%     %   OUTPUT:
%     %       W_rand - NxN weighted adjacency matrix with shuffled weights
% 
%     % Ensure the input matrix is symmetric (undirected)
% 
%     % Extract upper triangular weights (excluding diagonal)
%     mask = triu(W, 1); % Upper triangle without diagonal
%     weights = nonzeros(mask); % Extract weights as a column vector
% 
%     % Shuffle the weights randomly
%     shuffled_weights = weights(randperm(length(weights)));
% 
%     % Create a new empty adjacency matrix
%     W_rand = zeros(size(W));
% 
%     % Get the indices of the upper triangular part
%     [row_idx, col_idx] = find(mask);
% 
%     % Assign shuffled weights back to the matrix
%     for k = 1:length(shuffled_weights)
%         W_rand(row_idx(k), col_idx(k)) = shuffled_weights(k);
%     end
% 
%     % Make the matrix symmetric to maintain undirected structure
%     W_rand = W_rand + W_rand';
% 
% end