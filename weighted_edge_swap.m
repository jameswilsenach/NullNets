% function W_rand = weighted_edge_swap(W, num_swaps)
%     % Randomizes a weighted adjacency matrix W while preserving node strengths
%     % W: Input weighted adjacency matrix (NxN)
%     % num_swaps: Number of edge swaps to perform
% 
%     % Ensure W is symmetric if it's an undirected network
% 
%     % Get edge list (i, j, w)
%     % [i, j, w] = find(triu(W)); % Use only upper triangle for undirected case
%     % num_edges = length(i);
% 
%     W = (W+W')/2;
% 
%     for swap = 1:num_swaps
%         % Randomly select two edges (A-B and C-D)
%         idx = randperm(size(W,1), 4);
%         a = idx(1); b = idx(2); c = idx(3); d = idx(4);
% 
%         % % Ensure no duplicate edges & no self-loops
%         % if length(unique([a, b, c, d])) < 4
%         %     continue;
%         % end
% 
%         % Swap edges: A-B and C-D → A-D and C-B (preserving weights)
%         w_ab = W(a,b);
%         w_cd = W(c,d);
%         w_ad = W(a,d);
%         w_bc = W(b,c);
% 
%         W(a,b)=w_ad; W(b,a)=w_ad;
%         W(a,d)=w_ab; W(d,a)=w_ab;
% 
%         W(b,c)=w_cd; W(c,b)=w_cd;
%         W(c,d)=w_bc; W(d,c)=w_bc;
% 
%     end
% 
%     W_rand = W;
% 
%     % % Ensure symmetry
%     % W_rand = max(W, W');
% end


function W_rand = weighted_edge_swap(W)

    W = (W+W')/2;
    upper = triu(ones(size(W)),1);



    [i, j, weights] = find(triu(W, 1)); % Only upper triangle, no diagonal

    degs = sum(W);
    orig = degs.*degs';
    expected = orig(upper>0);
    Wh = zeros(size(W));
    chosen = zeros(size(weights));
    wchosen = zeros(size(weights));

    for swap = 1:length(weights)
        notchosen = find(chosen==0); 
        wnotchosen = find(wchosen==0); 

        [~,args] = sort(expected(notchosen));

        [wrankednotchosen,wrs] = sort(weights(wnotchosen));

        id = randi(length(wnotchosen));
        idx = notchosen(id);
        rank = find(args == id);
        chosen(idx) = 1; 

        w = wrankednotchosen(rank);
        wid = wrs(rank);
        widx = wnotchosen(wid);
        wchosen(widx)=1;

        ir = i(idx);
        jr = j(idx);


        Wh(ir,jr) = w;

        expected = degs-sum(Wh);
        expected = expected.*expected';
        expected = expected(upper>0);
    end

    W_rand = (Wh+Wh');

end