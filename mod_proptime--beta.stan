data {
  int N;
  int N_trials;
  real inspecting[N]; // y
  int groupsize_id[N];
  vector[N] temp;
  vector[N] fish_length;
  int trial_id[N];
  real<lower=0> fixed_prior;
  real<lower=0> random_prior;
  real<lower=0> kappa_prior;
  int priors_only;
}

parameters {
  vector[3] b_groupsize;
  real b_temp;
  real b_fish_length;
  vector[N_trials] z_trial;
  real<lower=0> z_sigma;

  real<lower=0> kappa;
}

transformed parameters{
  vector[N] logit_mu;

  logit_mu = b_groupsize[groupsize_id] + 
        b_temp * temp +
        b_fish_length * fish_length +
        z_trial[trial_id] * z_sigma;
}

model {
  if (priors_only == 0){
    inspecting ~ beta_proportion(inv_logit(logit_mu), kappa);
  }
  
  b_groupsize ~ normal(0, fixed_prior);
  b_temp ~ normal(0, fixed_prior);
  b_fish_length ~ normal(0, fixed_prior);
  z_trial ~ normal(0, z_sigma);
  z_sigma ~ normal(0, 1);
  kappa ~ normal(0, kappa_prior);
}

generated quantities{
  real predicted[N];
  predicted = beta_proportion_rng(inv_logit(logit_mu), kappa);
}


