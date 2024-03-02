data {
  int<lower = 1> N;
  vector<lower = 0>[N] distance_feet;
  array[N] int<lower = 0> tries;
  array[N] int<lower = 0> successes;
}
transformed data {
  vector[N] y = to_vector(successes) ./ to_vector(tries);
}
parameters {
  real a;
  real b;
  real<lower = 0> sigma;
}
model {
  y ~ normal(a + b * distance_feet, sigma);
}
generated quantities {
  vector[40] x;
  vector[40] y_hat;
  for (n in 1:40) {
    x[n] = n * 0.5;
    y_hat[n] = a + b * x[n];
  }
}
