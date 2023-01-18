data {
  int N;
  int N_trials;
  int inspecting[N];
  int groupsize_id[N];
  vector[N] refuge_use;
  vector[N] temp;
  vector[N] fish_length;
  int trial_id[N];
}

parameters{
  // real intercept;
  vector[3] b_groupsize;
  real b_refugeuse;
  real b_temp;
  real b_fish_length;
  vector[N_trials] z_trial;
  real<lower=0> z_sigma;
}

transformed parameters{
  vector[N] log_mu;
  log_mu = b_groupsize[groupsize_id] + 
    b_refugeuse*refuge_use +
    b_temp*temp + 
    b_fish_length*fish_length + 
    z_trial[trial_id] * z_sigma;
}

model{
  // define everything (up top)
  // this is the model!
  inspecting ~ poisson(exp(log_mu));
  // priors
  // intercept ~ normal(0, 1);
  b_groupsize ~ normal(0, 1);
  b_refugeuse ~ normal(0, 1);
  b_temp ~ normal(0, 1);
  z_trial ~ normal(0, z_sigma);
  z_sigma ~ normal(0, 1);
}

generated quantities{
  real predicted[N];
  predicted = poisson_rng(exp(log_mu));
}



