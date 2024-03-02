data {
  int<lower = 1> N;
  array[N] real<lower = 0> distance_feet;
  array[N] int<lower = 0> tries;
  array[N] int<lower = 0> successes;
}
transformed data {
  real r = 1.68 / 12 / 2;
  real R = 4.25 / 12 / 2;
  vector[N] threshold_angle = asin((R - r) ./ to_vector(distance_feet));
}
parameters {
  real<lower = 0> sigma;
}
model {
  vector[N] p = 2 * Phi(threshold_angle / sigma) - 1;
  successes ~ binomial(tries, p);
}
generated quantities {
  real sigma_degrees = sigma * 180 / pi();
}
