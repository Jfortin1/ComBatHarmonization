function y = bprior(gamma_hat)
	m = mean(gamma_hat);
  	s2 = var(gamma_hat);
  	y=(m*s2+m^3)/s2;
end