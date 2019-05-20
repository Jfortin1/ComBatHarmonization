%indices = batches{j};
%sdat = s_data(:,indices);
%ghat = gamma_hat(j,:);
%dhat = delta_hat(j,:);
% g.star is first row
% d.star is second row
function adjust = inteprior(sdat, ghat, dhat)
    gstar = [];
    dstar = [];
    r = size(sdat,1);
    for i = 1:r
        g = ghat;
        d = dhat;
        g(i)=[];
        d(i)=[];
        x = sdat(i,:);
        n = size(x,2);
        j = repmat(1,1,size(x,2));
        dat = repmat(x,size(g,2),1);
        resid2 = (dat-repmat(g',1,size(dat,2))).^2;
        sum2 = resid2 * j';
        LH = 1./(2*pi*d).^(n/2).*exp(-sum2'./(2.*d));
        gstar = [gstar sum(g.*LH)./sum(LH)];
        dstar = [dstar sum(d.*LH)./sum(LH)];
    end
    adjust = [gstar; dstar];
end