data {
  int<lower=1> num_timesteps;
  int<lower=1> num_groups;
  array[num_timesteps] real times; // this errors because it is a cmdstan feature and r uses rstan syntax checker
  
  matrix[num_timesteps, num_groups] Y;           // time (seconds)
  array[num_timesteps, num_groups] int phase;
  array[num_timesteps, num_groups] int groupsize;
  array[num_timesteps, num_groups] int groupsize_phase;
  
  array[num_timesteps, num_groups] real pool_temp;
  array[num_timesteps, num_groups] real fish_length;
  
  array[num_timesteps, num_groups] int group_id;
  
  array[num_timesteps, num_groups] int timesteps;
  int priors_only;
}

transformed data {
  real delta = 1e-9;         // don't love this fudge factor but it's what stan says to do to ensure cov mat is +ve semi-definite
}

parameters {
  real<lower=0> rho;         // smoothing term for covariance matrix
  real<lower=0> alpha;       // 
  real<lower=0> kappa;       // 
  matrix[num_timesteps, num_groups] z;
  vector[2] b_phase;
  vector[3] b_groupsize;
  vector[6] b_groupsize_phase;
  real b_pool_temp;
  real b_fish_length;
  
  vector[15] b_group_id;
}

transformed parameters{
  matrix[num_timesteps, num_groups] b_time;
  matrix[num_timesteps, num_groups] logit_mu;
  
  matrix[num_timesteps, num_timesteps] time_cov = cov_exp_quad(times, alpha, rho);     

  // diagonal elements
  for (i in 1:num_timesteps) {
    time_cov[i, i] = time_cov[i, i] + delta;                           // gets the variance for each data point (adds noise)
  }

  
  for (g in 1:num_groups) {
    b_time[, g] = cholesky_decompose(time_cov) * z[, g];                                         // this describes the effect of time on area
    for (t in 1:num_timesteps) {
      if (Y[t, g] != 0) {
        logit_mu[t, g] = b_phase[phase[t, g]] + b_groupsize[groupsize[t, g]] + b_groupsize_phase[groupsize_phase[t, g]] + b_pool_temp*pool_temp[t, g] + b_fish_length*fish_length[t, g] + b_time[t, g] + b_group_id[group_id[t, g]];
      }
    }
  }
}

model {
  rho ~ inv_gamma(5, 5);
  alpha ~ std_normal();
  for (g in 1:num_groups){
    z[, g] ~ std_normal();
  }
  
  kappa ~ std_normal();
  
  b_phase ~ normal(0, 1);
  b_groupsize ~ normal(0, 1);
  b_groupsize_phase ~ normal(0, 1);
  b_pool_temp ~ normal(0, 1);
  b_fish_length ~ normal(0, 1);
  b_group_id ~ normal(0, 1);
  
  if (priors_only == 0){
    for (g in 1:num_groups) {
      for (t in 1:num_timesteps){
        if (Y[t, g] != 0){
          Y[t, g] ~ beta_proportion(inv_logit(logit_mu[t, g]), kappa);
        }
      }
    }
  }
}

generated quantities {
  array[num_timesteps, num_groups] real y_predicted;
  // prior checks
  // real pc_y[N];
  // vector[N] pc_alpha;
  // real pc_beta;
  // vector[N] log_lik;
  for (g in 1:num_groups) {
    for (t in 1:num_timesteps){
      if (Y[t, g] != 0){
        y_predicted[t, g] = beta_proportion_rng(inv_logit(logit_mu[t, g]), kappa);
      }
    }
  }
  // prior checks
  // pc_y = beta_proportion_rng(pc_alpha, pc_beta);
  // pc_alpha = alpha;
  // pc_beta = beta;
  // for (i in 1:N){
  //   log_lik[i] = beta_proportion_lpdf(y[i] | alpha[i], beta);
  // }
}


