%indices = batches{j};
%sdat = s_data(:,indices);
%ghat = gamma_hat(j,:);
%dhat = delta_hat(j,:);
% g.star is first row
% d.star is second row
% Optimized and parallelized by John C. Williams JCW 06/30/2023
function adjust = inteprior(sdat, ghat, dhat)
    r = size(sdat,1);
    n = size(sdat,2);
    [gstar,dstar] = deal(nan(1,r));
    prcalc_for_LH = 1./(2*pi*dhat).^(n/2);
    parfor i = 1:r
        chooseVec = true(r,1);
        chooseVec(i) = false;
        g = ghat(chooseVec);
        d = dhat(chooseVec);
        x = sdat(i,:);
        resid2 = (x - g.').^2;
        sum2 = sum(resid2,2);
        this_prcalc_for_LH = prcalc_for_LH(chooseVec);
        thisExpTerm = exp(-sum2'./(2.*d));
        LH = this_prcalc_for_LH .* thisExpTerm;
        gstar(i) = sum(g.*LH)./sum(LH);
        dstar(i) = sum(d.*LH)./sum(LH);
    end
    adjust = [gstar; dstar];
end
