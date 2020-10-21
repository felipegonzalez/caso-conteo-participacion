data {
  // datos fijos
  int num_estratos;
  //int n_est[num_estratos]; // num casillas por estrato
  int N; // num casillas total
  int nom[N]; // tamaño de lista nominal en cada casilla
  int est[N]; // indicador de estrato para cada casilla
  int n; // tamaño de muestra
  int muestra[n]; //indices de casillas en la muestra
  // inicial
  real mu_pars[2];
  real kappa_pars[2];
  real sigma_pars[2];
}

generated quantities {
  real p_est[num_estratos];
  real log_sigma_est[num_estratos];
  real total_ln_muestra = 0;
  real total_y_muestra = 0;
  real mu = beta_proportion_rng(mu_pars[1], mu_pars[2]);
  real kappa = gamma_rng(kappa_pars[1], kappa_pars[2]);
  real y[n];

  for(i in 1:num_estratos) {
    p_est[i] = beta_proportion_rng(mu, kappa);
    log_sigma_est[i] = normal_rng(0, 1);
  }
  for(i in 1:n){
    int j = muestra[i];
    int lnom = nom[i];
    if(lnom == 0) {
      lnom = 1200;
    }
    real sigma_est = exp(log_sigma_est[est[j]]);
    real p_casilla = normal_rng(p_est[est[j]], sigma_est * sqrt(p_est[est[j]]*(1-p_est[est[j]]) / lnom));
    y[i] = nom[j] * p_casilla;
    total_ln_muestra+= nom[j];
    total_y_muestra+= y[i];
  }
  real part_muestra = total_y_muestra / total_ln_muestra;
}
