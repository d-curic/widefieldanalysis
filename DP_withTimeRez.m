clear all
M = 100;


numtrials=1000000;
Tmax = 1000000;

IntegratedLattice =zeros(M,M);

time_rez =200;

MaxFrames = 1000;
time_rez_list = [1:5:10];
siz = [M M];

%%

params.siz = siz;
params.MaxFrames = MaxFrames;
params.LatticeSize = M;
params.numtrials = numtrials;
params.Tmax = Tmax;

%%
for p = 0.2:0.05:0.285
params.prob = p;
    for k = 1:length(time_rez_list)
    time_rez = time_rez_list(k);
    t_tot = 1;
    nframe = 1;
    trial = 1;
    
    while trial <numtrials
        s = [];
        Lattice = zeros(M,M);
        
        seed = randi(M*M);
        
        Lattice(seed) = 1;
        ActiveIdx = find(Lattice==1);
        t = 1;

        while ~isempty(ActiveIdx) & t<Tmax
            ActiveIdx = find(Lattice==1);
            Lattice = updateLattice(ActiveIdx, Lattice, params);
            IntegratedLattice = IntegratedLattice + Lattice;
            
            if mod(t_tot,time_rez) == 0 ;
                IntegratedLattice(IntegratedLattice >1) = 1;
                
                frame(:,:,nframe) = IntegratedLattice;
                
                
                IntegratedLattice = zeros(size(Lattice));
                nframe = nframe + 1;
                if mod(nframe,100) == 0; nframe
                end
            end
            t_tot = t_tot+1;
            if nframe > MaxFrames; t = Tmax; trial = numtrials; 'here'
            end
        end
        
        trial = trial + 1;
        clear s
    end
    %%
    CC = bwconncomp(frame);
    S = cellfun(@length, CC.PixelIdxList);
    
    S(S == 0) = [];
    SizeDist{k} = logpdf(S,30);
    clear frame CC S
end
%%

export = {SizeDist; time_rez_list};
savedir = pwd;
savename = [savedir '/' 'SizeDist_from' num2str(time_rez_list(1)) 'to' num2str(time_rez_list(end))];
savename = [savename '_p=' num2str(p) '_numframes=' num2str(MaxFrames)]
savename = [savename '_size=' num2str(M) 'x' num2str(M)];

save([savename '.mat'], 'export')
end




function Lattice = updateLattice(ActiveIdx, Lattice, params)
siz = params.siz;
p = params.prob;
[I,J] = ind2sub(siz,ActiveIdx);
for k=1:length(ActiveIdx)
    Lattice(I(k),J(k)) = 0;
    nidx = Neighbours(I(k),J(k),siz);
    for n = 1:size(nidx,1);
        if rand < p; Lattice(nidx(n,1), nidx(n,2)) = 1; end
    end
end
end


function neigh =  Neighbours(i,j, siz)
neigh = [];
if i+1 < siz(1);   neigh = [i+1, j;  neigh]; end
if j+1 < siz(2);   neigh = [i, j+1;  neigh]; end
if i-1 > 1;   neigh = [i-1, j;  neigh]; end
if j-1 > 1;   neigh = [i, j-1;  neigh]; end

end