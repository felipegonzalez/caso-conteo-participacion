data {
  // datos fijos
  int num_estratos;
  int n_est[num_estratos]; // num casillas por estrato
  int N; // num casillas total
  int m_nominal[N]; // tamaño de lista nominal en cada casilla
  int est[N]; // indicador de estrato para cada casilla
  int n; // tamaño de muestra
  int muestra[n]; //indices de casillas en la muestra
  // observaciones
  int y_obs[n]; // conteos en cada casilla de votos totales
}


