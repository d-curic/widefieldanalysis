function exp = checkifCoefficientsExist(exp, project)

filterdir = [project.folder 'newanalysis/processing/'];


switch exp.band
    case 'BP'
    filtername = ['Filter_FIR_' exp.band '_' num2str(exp.filtparams(1)) '_' num2str(exp.filtparams(2)) '_' num2str(exp.FR) 'Hz_order' num2str(exp.filterorder)];
    case 'HP'
        'not yet implemented'
    case 'LP' 
        'not yet implemented'
    case 'BS'
        'not yet implemented'
    otherwise
        'valid filter bands are BP, HP, LP, BS'
end


if exist([filterdir filtername '.mat'], 'file') == 2
     'coefficients exist'
     exp.coefffile = [filterdir filtername '.mat'];
else
     'coefficients do not exist, generating .... '
     designFilter(exp, project);
     exp.coefffile = [filterdir filtername '.mat'];
end

    

end
