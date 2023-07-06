data {
  int N;
  int N_trials;
  real inspecting[N];
  int groupsize_id[N];
  vector[N] temp;
  vector[N] fish_length;
  int trial_id[N];
}

parameters{
  // real intercept;
  vector[3] b_groupsize; // fixed
  real b_temp; // fixed
  real b_fish_length; // fixed
  vector[N_trials] z_trial; // random
  real<lower=0> z_sigma; // var
  real<lower=0> beta; // shape
}

transformed parameters{
  vector[N] log_mu;
  log_mu = b_groupsize[groupsize_id] + b_temp*temp + b_fish_length*fish_length + z_trial[trial_id] * z_sigma;
}

model{
  inspecting ~ gamma(exp(log_mu)*beta, beta);
  // inspecting ~ poisson(exp(log_mu));
  // priors
  // intercept ~ normal(0, 1);
  b_groupsize ~ normal(0, 1);
  b_temp ~ normal(0, 1);
  b_fish_length ~ normal(0, 1);
  z_trial ~ normal(0, z_sigma);
  z_sigma ~ normal(0, 1);
  beta ~ normal(0, 1);
}

generated quantities{
  real predicted[N];
  predicted = gamma_rng(exp(log_mu)*beta, beta);
  // predicted = poisson_rng(exp(log_mu));
}



