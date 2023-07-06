data {
  int N;
  int N_trials;
  real min_dist[N]; // Min_dist
  int groupsize_ID[N]; // Group_size
  vector[N] temp; // Pool_temp
  vector[N] fish_length;
  int trial_ID[N]; // call it ID because we will use 1-13
}

parameters{
  real intercept_mu;
  real intercept_alpha;
  vector[3] b_groupsize; // see bear
  real b_temp; // this is just 'one' because it's not a category so there is just one coefficient
  real b_fishlength;
  vector[N_trials] z_trial; // z_ because it is a 'random' effect
  real<lower=0> z_sigma;
  real<lower=0> alpha;
}

transformed parameters{
  vector[N] log_mu;
  
  log_mu = b_groupsize[groupsize_ID] + b_temp*temp + b_fishlength*fish_length + z_trial[trial_ID] * z_sigma; //
}

model{
  min_dist ~ gamma(alpha, alpha ./ exp(log_mu));
  b_groupsize ~ normal(0, 1);
  alpha ~ normal(0, 1);
  b_temp ~ normal(0, 1);
  z_trial ~ normal(0, z_sigma);
  z_sigma ~ normal(0, 1);
}

generated quantities{
  real predicted[N];
  predicted = gamma_rng(alpha, alpha ./ exp(log_mu));
}



