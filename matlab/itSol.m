function adjust = itSol(sdat,g_hat,d_hat,g_bar,t2,a,b, conv)
  g_old = g_hat;
  d_old = d_hat;
  change = 1;
  count = 0;
  n = size(sdat,2);
  while change>conv 
    g_new = postmean(g_hat,g_bar,n,d_old,t2);
    sum2  = sum(((sdat-g_new'*repmat(1,1,size(sdat,2))).^2)');
    d_new = postvar(sum2,n,a,b);

    change = max(max(abs(g_new-g_old)./g_old), max(abs(d_new-d_old)./d_old));
    g_old = g_new;
    d_old = d_new;
    count = count+1;
  end
  adjust = [g_new; d_new];
end
