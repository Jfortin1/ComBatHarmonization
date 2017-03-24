function y = postmean(g_hat ,g_bar, n,d_star, t2)
	y=(t2*n.*g_hat+d_star.*g_bar)./(t2*n+d_star);
end