function y = aprior(gamma_hat)
	m = mean(gamma_hat);
  	s2 = var(gamma_hat);
  	y=(2*s2+m^2)/s2;
end