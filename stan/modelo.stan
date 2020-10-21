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
  int y[n];
}
parameters {
  real<lower=0,upper=1> mu;
  real<lower=0> kappa;
  real<lower=0,upper=1> p_est[num_estratos];
  real log_sigma_est[num_estratos];
}
transformed parameters{

}
model {
  mu ~ beta_proportion(mu_pars[1], mu_pars[2]);
  kappa ~ gamma(kappa_pars[1], kappa_pars[2]);
  p_est ~ beta_proportion(mu, kappa);
  log_sigma_est ~ normal(0, 1);
  for(i in 1:n){
    int j = muestra[i];
    int lnom = nom[i];
    if(lnom == 0) {
      lnom = 1200;
    }
    y[i] ~ normal(p_est[est[j]], exp(log_sigma_est[est[j]]) * sqrt(p_est[est[j]]*(1 - p_est[est[j]])/lnom));
  }
}

generated quantities {
  real part_muestra;
  real total_ln_muestra = 0;
  real total_y_muestra = 0;

  for(i in 1:N){
    int lnom = nom[i];
    if(lnom == 0) {
      lnom = 1200;
    }
    real p_casilla = normal_rng(p_est[est[i]], exp(log_sigma_est[est[i]]) *sqrt(p_est[est[i]]*(1 - p_est[est[i]])/lnom));
    real y_sim = nom[i] * p_casilla;
    total_ln_muestra+= nom[i];
    total_y_muestra+= y_sim;
  }
  part_muestra = total_y_muestra / total_ln_muestra;
}

