data {
  int<lower = 1> N;
  vector<lower = 0>[N] distance_feet;
  array[N] int tries;
  array[N] int successes;
}
parameters {
  real a;
  real b;
}
model {
  successes ~ binomial_logit(tries, a + b * distance_feet);
}
