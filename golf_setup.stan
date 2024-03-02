data {
  int<lower = 1> N;
  array[N] real<lower = 0> distance_feet;
  array[N] int<lower = 0> tries;
  array[N] int<lower = 0> successes;
}
transformed data {
  vector[N] y = to_vector(successes) ./ to_vector(tries);
}
parameters {
  real theta;
}
model {
  theta ~ normal(0, 1);
}
